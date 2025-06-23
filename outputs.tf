output "kubernetes_namespace" {
  description = "Kubernetes namespace created"
  value       = kubernetes_namespace.app.metadata[0].name
}

output "kubernetes_service_nodeport" {
  description = "NodePort for accessing the application"
  value       = kubernetes_service.app.spec[0].port[0].node_port
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.app_bucket.bucket
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.app_table.name
}

output "sqs_queue_url" {
  description = "SQS queue URL"
  value       = aws_sqs_queue.app_queue.url
}

output "application_url" {
  description = "URL to access the application (after port-forward)"
  value       = "http://localhost:8080"
}

output "sns_topic_arn" {
  description = "SNS topic ARN"
  value       = aws_sns_topic.app_notifications.arn
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.data_processor.function_name
}
output "ingress_host" {
  description = "Ingress host for the application"
  value       = "my-local-app.local"
}

# output "persistent_volume_claim" {
#   description = "PVC name for application storage"
#   value       = kubernetes_persistent_volume_claim.app_storage.metadata[0].name
# }