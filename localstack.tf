# S3 bucket for application assets
resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.project_name}-${var.environment}-assets"

  tags = local.common_labels
}

resource "aws_s3_bucket_versioning" "app_bucket_versioning" {
  bucket = aws_s3_bucket.app_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB table for application data
resource "aws_dynamodb_table" "app_table" {
  name           = "${var.project_name}-${var.environment}-data"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = local.common_labels
}

# SQS queue for async processing
resource "aws_sqs_queue" "app_queue" {
  name = "${var.project_name}-${var.environment}-queue"

  tags = local.common_labels
}

# Sample data in DynamoDB
resource "aws_dynamodb_table_item" "sample_data" {
  table_name = aws_dynamodb_table.app_table.name
  hash_key   = aws_dynamodb_table.app_table.hash_key

  item = jsonencode({
    id = {
      S = "sample-1"
    }
    message = {
      S = "Hello from Terraform!"
    }
    timestamp = {
      S = timestamp()
    }
  })
}