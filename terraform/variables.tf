#Bucket name muss WELTWEIT einzigartig sein
variable "s3_bucket_name" {
  description = "[Required, string] Name of the S3 bucket"
  type        = string
}

variable "tags" {
  description = "[Optional, map] tags"
  type        = map(any)
  default = {
    Name        = "CloudComputingGroup17"
    Environment = "Production"
  }
}
