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

# SNS Topic for notifications
resource "aws_sns_topic" "app_notifications" {
  name = "${var.project_name}-${var.environment}-notifications"

  tags = local.common_labels
}

# SNS Topic Subscription (SQS)
resource "aws_sns_topic_subscription" "sqs_notification" {
  topic_arn = aws_sns_topic.app_notifications.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.app_queue.arn
}

# Lambda function (simulated in LocalStack)
resource "aws_lambda_function" "data_processor" {
  filename         = "lambda/lambda_function.zip"  # Changed path
  function_name    = "${var.project_name}-${var.environment}-processor"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "python3.9"

  tags = local.common_labels
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_labels
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/lambda/${aws_lambda_function.data_processor.function_name}"
  retention_in_days = 7

  tags = local.common_labels
}