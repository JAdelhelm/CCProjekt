# Erzeugen eines S3-Buckets

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.bucket_example.id
  acl    = "public-read-write"
}



# Erzeugen einer MySQL-Datenbank

## Auto-Scaling 10 - 40

resource "aws_db_instance" "mysql-database" {
  allocated_storage    = 10
  max_allocated_storage = 40
  db_name              = "coolDB"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "supergutespasswort"
  skip_final_snapshot  = true
}