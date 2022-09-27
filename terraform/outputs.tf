# Optional, falls nicht erstellt wird, 
# weiß man auf Terraform-Seite allerdings nicht das 
#  die erstellt wurde (arn = Unique identifier)
output "s3_bucket_arn" {
    value = aws_s3_bucket.bucket_example.arn
}


output "web_instance_ip" {
  value = aws_instance.webserver.public_ip
}
