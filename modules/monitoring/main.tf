locals {
  name_prefix = "${var.project}-${var.environment}"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ── Security Group: monitoring-core (Prometheus + Grafana + Alertmanager) ──────

resource "aws_security_group" "monitoring_core" {
  name        = "${local.name_prefix}-sg-monitoring-core"
  description = "SG para Prometheus, Grafana y Alertmanager"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  ingress {
    description = "Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = var.monitoring_allowed_cidrs
  }

  ingress {
    description = "Grafana UI"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = var.monitoring_allowed_cidrs
  }

  ingress {
    description = "Alertmanager"
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = var.monitoring_allowed_cidrs
  }

  # Tráfico interno VPC: permite que Prometheus alcance el backend y Loki
  ingress {
    description = "Trafico interno VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.name_prefix}-sg-monitoring-core"
    Project     = var.project
    Environment = var.environment
  }
}

# ── Security Group: monitoring-logs (Loki + Promtail + Jaeger) ────────────────

resource "aws_security_group" "monitoring_logs" {
  name        = "${local.name_prefix}-sg-monitoring-logs"
  description = "SG para Loki, Promtail y Jaeger"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  ingress {
    description = "Loki API"
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = var.monitoring_allowed_cidrs
  }

  ingress {
    description = "Jaeger UI"
    from_port   = 16686
    to_port     = 16686
    protocol    = "tcp"
    cidr_blocks = var.monitoring_allowed_cidrs
  }

  # Tráfico interno VPC: permite que Promtail reciba desde el backend y que Grafana consulte Loki
  ingress {
    description = "Trafico interno VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.name_prefix}-sg-monitoring-logs"
    Project     = var.project
    Environment = var.environment
  }
}

# ── Regla extra en sg-app: permite que Prometheus scrapeé node_exporter ───────
# Los puertos de la app (5511, 80, 443) ya están abiertos en el sg-ec2 existente.

resource "aws_security_group_rule" "app_allow_node_exporter" {
  type                     = "ingress"
  from_port                = 9100
  to_port                  = 9100
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.monitoring_core.id
  security_group_id        = var.sg_app_id
  description              = "Node Exporter desde Prometheus (monitoring-core)"
}

# ── EC2: monitoring-core ──────────────────────────────────────────────────────

resource "aws_instance" "monitoring_core" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.monitoring_core.id]
  key_name               = var.key_name

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
    encrypted   = true
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e
    yum update -y

    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user

    curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" \
      -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    mkdir -p /opt/monitoring/core
    chown ec2-user:ec2-user /opt/monitoring/core
  EOF
  )

  tags = {
    Name        = "${local.name_prefix}-monitoring-core"
    Project     = var.project
    Environment = var.environment
    Role        = "monitoring-core"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_eip" "monitoring_core" {
  instance = aws_instance.monitoring_core.id
  domain   = "vpc"

  tags = {
    Name        = "${local.name_prefix}-eip-monitoring-core"
    Project     = var.project
    Environment = var.environment
  }
}

# ── EC2: monitoring-logs ──────────────────────────────────────────────────────

resource "aws_instance" "monitoring_logs" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.monitoring_logs.id]
  key_name               = var.key_name

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
    encrypted   = true
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e
    yum update -y

    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user

    curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" \
      -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    mkdir -p /opt/monitoring/logs
    chown ec2-user:ec2-user /opt/monitoring/logs
  EOF
  )

  tags = {
    Name        = "${local.name_prefix}-monitoring-logs"
    Project     = var.project
    Environment = var.environment
    Role        = "monitoring-logs"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_eip" "monitoring_logs" {
  instance = aws_instance.monitoring_logs.id
  domain   = "vpc"

  tags = {
    Name        = "${local.name_prefix}-eip-monitoring-logs"
    Project     = var.project
    Environment = var.environment
  }
}
