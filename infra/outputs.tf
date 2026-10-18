output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.app.repository_url
}

output "github_actions_role_arn" {
  description = "ARN of the IAM role for GitHub Actions (OIDC)"
  value       = aws_iam_role.github_actions.arn
}

output "artifacts_bucket" {
  description = "S3 bucket for build artifacts"
  value       = aws_s3_bucket.artifacts.bucket
}

output "app_instance_public_ip" {
  description = "Public IP of the deployment host"
  value       = aws_instance.app.public_ip
}
