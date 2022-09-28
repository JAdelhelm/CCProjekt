# "Input"-Variablen definieren, welche Arguemente den entsprechenden Ressourcen
# übergeben werden sollen.
# Hier in diesem Beispiel soll bpsw. dem S3 Bucket der Name und die Tags
# übergeben werden.

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

# Hier werden über das Schlüsselwort "var"
# Die Variablen aus variables.tf übergeben
resource "aws_s3_bucket" "bucket_example" {
  bucket = var.s3_bucket_name
  tags   = var.tags

}

# Variable für die Cloud9-Umgebung
variable "region" {
  default = "us-east-1"

}