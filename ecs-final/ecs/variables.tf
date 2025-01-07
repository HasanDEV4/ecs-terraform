variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "my-ecs-cluster"
}

variable "vpc_id" {
  description = "ID of the VPC where the ECS cluster will reside"
  type        = string
}

variable "task_family" {
  description = "Name of the ECS task family"
  type        = string
  default     = "my-task-family"
}

variable "task_cpu" {
  description = "CPU units for the ECS task"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Memory (in MiB) for the ECS task"
  type        = string
  default     = "512"
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = "my-container"
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
  default     = "nginx:latest"
}

variable "container_cpu" {
  description = "CPU units for the container"
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "Memory (in MiB) for the container"
  type        = number
  default     = 512
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = 80
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "my-ecs-service"
}

variable "desired_count" {
  description = "Desired number of tasks for the ECS service"
  type        = number
  default     = 3
}

variable "subnets" {
  description = "List of subnets for ECS tasks"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the target group for the ECS service"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^arn:aws:elasticloadbalancing:[a-z0-9-]+:[0-9]+:targetgroup/[a-zA-Z0-9-]+/[a-zA-Z0-9]+$", var.target_group_arn))
    error_message = "Invalid Target Group ARN. Ensure it matches the required AWS ARN format."
  }
}

variable "private_subnets" {
  description = "List of private subnets for ECS tasks"
  type        = list(string)
}


