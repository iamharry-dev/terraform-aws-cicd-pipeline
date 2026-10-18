variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name prefix for resources"
  type        = string
  default     = "cicd-pipeline"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "github_repo" {
  description = "GitHub repository allowed to assume the deploy role (owner/repo)"
  type        = string
  default     = "iamharry-dev/terraform-aws-cicd-pipeline"
}

variable "instance_type" {
  description = "EC2 instance type for the deployment host"
  type        = string
  default     = "t3.micro"
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 8000
}

variable "ssh_cidr" {
  description = "CIDR allowed to SSH"
  type        = string
  default     = "0.0.0.0/0"
}
