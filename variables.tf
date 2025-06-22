variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "terraform-learning"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "local"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "localstack_enabled" {
  description = "Whether to use LocalStack for AWS services"
  type        = bool
  default     = true
}

variable "aws_access_key" {
  description = "AWS access key (not used with LocalStack)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key (not used with LocalStack)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "kube_context" {
  description = "Kubernetes context to use"
  type        = string
  default     = "kind-terraform-learning"
}

variable "app_replicas" {
  description = "Number of application replicas"
  type        = number
  default     = 2
}