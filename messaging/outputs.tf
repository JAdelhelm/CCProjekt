output "s3_buckets_arn" {
  value = {
    for bucket_name, meta_data in aws_s3_bucket.buckets : bucket_name => [meta_data.arn, meta_data.bucket_domain_name]
  }
}

output "sns_arn" {
  value = aws_sns_topic.yaml_file_converter.arn
}

output "sqs_arn" {
  value = aws_sqs_queue.yaml_json_converter.arn
}

output "lambda_arn" {
  value = aws_lambda_function.json_converter.arn
}

output "sensitive_db_password" {
  value = var.lambda_db_password
  sensitive = true 
}
