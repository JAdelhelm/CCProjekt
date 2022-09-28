# Zugriffsberechtigungen
## Funktioniert in AWS Lab nicht
resource "aws_iam_role" "lambda_execution_role" {
  name = format("%s-%s-%s-lambda-exec-role", var.environment, var.service, var.component)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_execution_policy" {
  name = format("%s-%s-%s-lambda-exec-policy", var.environment, var.service, var.component)
  role = aws_iam_role.lambda_execution_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:eu-central-1:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:eu-central-1:*:log-group:/aws/lambda/*:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
              "sqs:DeleteMessage",
              "sqs:GetQueueAttributes",
              "sqs:ReceiveMessage"
            ],
            "Resource": [
              "${aws_sqs_queue.yaml_json_converter.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action":[
                "s3:*"
            ],
            "Resource":[
                "arn:aws:s3:::*"
            ]
        }
    ]
  }
  EOF
}

resource "aws_lambda_function" "json_converter" {
  filename         = var.lambda_source_code_file
  function_name    = format("%s-%s-%s", var.environment, var.service, var.component)
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = var.lambda_handler
  source_code_hash = filebase64sha256(var.lambda_source_code_file)

  runtime = var.lambda_runtime

  environment {
    variables = {
      CONVERTED_BUCKET = var.converted_s3_bucket_name
      LOG_LEVEL        = "INFO"
      DB_PASSWORD      = var.lambda_db_password
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs" {
  event_source_arn = aws_sqs_queue.yaml_json_converter.arn
  function_name    = aws_lambda_function.json_converter.arn
}
