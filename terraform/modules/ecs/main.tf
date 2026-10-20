# ============================================
# 1. ECR (Elastic Container Registry)
# ============================================
resource "aws_ecr_repository" "app" {
  name                 = "${var.project_name}-app"
  image_tag_mutability = "MUTABLE" # Allows us to overwrite 'latest' tag

  image_scanning_configuration {
    scan_on_push = true # Automatically scans images for CVEs
  }

  tags = {
    Environment = var.environment
  }
}

# ============================================
# 2. Security Groups
# ============================================

# ALB Security Group (Allow HTTP from anywhere)
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow inbound HTTP traffic to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

# ECS Task Security Group (Allow traffic ONLY from the ALB)
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.project_name}-ecs-tasks-sg"
  description = "Allow inbound traffic from ALB only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id] # Crucial: Only ALB can talk to it
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow ECS to reach ECR and CloudWatch
  }

  tags = {
    Name = "${var.project_name}-ecs-tasks-sg"
  }
}
