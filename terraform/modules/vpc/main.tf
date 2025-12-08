##############################
# VPC
##############################
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

##############################
# Public Subnets (No auto public IP)
##############################
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = false
  availability_zone       = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-public-${count.index}"
  }
}

##############################
# Private Subnets
##############################
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-private-${count.index}"
  }
}

##############################
# Internet Gateway
##############################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-igw"
  }
}

##############################
# Public Route Table
##############################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route_table_association" "public_association" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

##############################
# CloudWatch Log Group for VPC Flow Logs
##############################
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/${var.name}"
  retention_in_days = 365
  kms_key_id        = var.cloudwatch_kms_key_arn
}

##############################
# VPC Flow Logs
##############################
resource "aws_flow_log" "vpc" {
  vpc_id               = aws_vpc.this.id
  traffic_type         = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  iam_role_arn         = var.flow_log_iam_role_arn
}

##############################
# Default Security Group - Secure & Compliant
##############################
resource "aws_security_group" "default" {
  name        = "default"
  description = "Default security group - restrict all inbound traffic"
  vpc_id      = aws_vpc.this.id

  # No ingress rules = blocks all inbound traffic

  # Egress: restrict outbound traffic to within VPC
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow outbound traffic only within VPC"
  }

  revoke_rules_on_delete = true

  tags = {
    Name = "${var.name}-default-sg"
  }
}
