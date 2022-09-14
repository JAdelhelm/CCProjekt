# NEU
# S3 Bucket hinzufügen.

variable "s3_bucket_name" {
  description = "[Required, string] Name of the S3 bucket"
  type        = string
}


variable "tags" {
  description = "[Optional, map] tags"
  type        = map(any)
  default = {
    # Name muss einzigartig sein.
    Name        = "CloudComputingGroup"
    Environment = "staging"
  }
}

# Greift auf die Variable oben zu
resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name
  tags   = var.tags
}


# Optional, falls nicht erstellt wird, weiß man auf Terraform-Seite allerdings nicht das die erstellt wurde (arn = Unique identifier)
output "s3_bucket_arn" {
    value = aws_s3_bucket.bucket.arn
}