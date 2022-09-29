
locals {
  sns_topic_name = format("%s-yaml-file-converter", var.environment)
}


resource "aws_sns_topic" "yaml_file_converter" {
  # Name den AWS anlegt
  name = local.sns_topic_name

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "sns:Publish",
        "Resource": "*"
    }]
}
POLICY
}

resource "aws_sqs_queue" "yaml_json_converter" {
  name                      = format("%s-yaml-json-converter", var.environment)
  delay_seconds             = 0      # Zeitverzögerung der Nachrichten
  max_message_size          = 262144 # 256kB 
  message_retention_seconds = 345600 # Eine Nachricht bleibt vier Tage bestehen
  receive_wait_time_seconds = 10     # Langes Polling vs. kurzes Pooling

  tags = {
    Environment = var.environment
  }

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "sns.amazonaws.com" },
        "Action": "*",
        "Resource": "*"
    }]
}
POLICY
}

resource "aws_sns_topic_subscription" "json_converter_sqs_target" {
  topic_arn = aws_sns_topic.yaml_file_converter.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.yaml_json_converter.arn
  raw_message_delivery = true
}
