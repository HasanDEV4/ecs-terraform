provider "aws" {
  region = var.aws_region
}

# ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = var.cluster_name
}

# Security Group for ECS
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow traffic for ECS tasks"
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
}

# IAM Role for ECS
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach ECS Execution Role Policy
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "my_task" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      cpu       = var.container_cpu
      memory    = var.container_memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "my_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets # Yahan private subnets ki IDs specify karen
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false # Public IP assign nahi hoga
  }

  dynamic "load_balancer" {
    for_each = var.target_group_arn != "" ? [var.target_group_arn] : []

    content {
      target_group_arn = load_balancer.value
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }
}
