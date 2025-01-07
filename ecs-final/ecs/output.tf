output "ecs_cluster_id" {
  description = "ID of the ECS Cluster"
  value       = aws_ecs_cluster.my_cluster.id
}

output "ecs_cluster_name" {
  description = "Name of the ECS Cluster"
  value       = aws_ecs_cluster.my_cluster.name
}

output "task_definition_arn" {
  description = "ARN of the ECS Task Definition"
  value       = aws_ecs_task_definition.my_task.arn
}

output "ecs_service_id" {
  description = "ID of the ECS Service"
  value       = aws_ecs_service.my_service.id
}

output "ecs_service_arn" {
  value = aws_ecs_service.my_service.id
}

