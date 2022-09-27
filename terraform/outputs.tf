# Outputs referenzieren auf die Ressourcen und geben anschließend die
# entsprechenden Werte in der Konsole aus. (Optional)

# Gibt den Namen des S3 Bucket aus
output "s3_bucket_arn" {
    value = "S3-Bucket-Name: ${aws_s3_bucket.bucket_example.arn}"
}

# Gibt die IP aus, auf welcher Adresse der Webserver gehostet wird
output "web_instance_ip" {
  value = "Öffentliche-IP: ${aws_instance.webserver.public_ip}"
}

# Output des Namens von der MySQL Datenbank
# output "mysql_name" {
#     value = "MySQL-Name: ${aws_db_instance.mysql-database.db_name}"
# }
