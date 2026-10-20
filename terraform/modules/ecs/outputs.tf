output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "ecs_tasks_security_group_id" {
  value = aws_security_group.ecs_tasks.id
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}
