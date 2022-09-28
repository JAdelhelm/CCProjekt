variable "environment" {
  description = "[required, string] name of the environment"
  type        = string
}

variable "service" {
  description = "[required, string] Name of the service."
  type        = string
}

variable "component" {
  description = "[required, string] Name of the component."
  type        = string
}

variable "ingestion_s3_bucket_name" {
  description = "[required] Name of the s3 bucket where yaml files will be ingested"
  type        = string
}

variable "converted_s3_bucket_name" {
  description = "[required] Name of the s3 bucket where the converted json files will be stored"
  type        = string
}

variable "lambda_source_code_file" {
  description = "[optional, string, default=file-converter-v1.0.zip] The name or path of the source code zip file"
  type        = string
  default     = "file-converter-v1.0.zip"
}

variable "lambda_handler" {
  description = "[optional, string, default=app.lambda_handler.lambda_handler] The lambda handler path to get the entrypoint from source code"
  type        = string
  default     = "app.lambda_handler.lambda_handler"
}

variable "lambda_runtime" {
  description = "[optional, string, default=python3.8] Type of the lambda runtime environment"
  type        = string
  default     = "python3.8"
}

variable "lambda_db_password" {
  description = "[optional, string] A sensitive password for db connection"
  type = string
  sensitive = true # Taucht in den Logs/Konsole nicht auf
  default = "kOde5sQcVVD"
}

variable "tags" {
  description = "[Optional, map] tags"
  type        = map(any)
  default = {
    Environment = "staging"
    Service     = "file-converter"
  }
}
