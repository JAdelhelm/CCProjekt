
# Definition der Komponenten, ingestion und conversion.
# Es wird eine Map erstellt
locals {
  s3_buckets = {
    "${var.ingestion_s3_bucket_name}" = "ingestion"
    "${var.converted_s3_bucket_name}" = "conversion"
  }
}

# Foreach iteriert über die Map von Locals
resource "aws_s3_bucket" "buckets" {
  for_each = local.s3_buckets
  bucket   = each.key
# Mit dot-Notation kann auf das each (Objekt)
# zugegriffen werden
  tags = merge(var.tags, {
    Name      = each.key
    Component = each.value
  })
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification
# Sorgt für eine Event-Hook, wenn das YAML File hochgeladen wird
resource "aws_s3_bucket_notification" "file_created" {
  bucket = aws_s3_bucket.buckets[var.ingestion_s3_bucket_name].id

  dynamic "topic" {
# Für alle Dateien die mit .yml oder .yaml enden soll eine Hook erstellt werden und
# Auf eine SNS Topic referenzieren (Dynamische Topic, es kann meherere Blöcke geben)
    for_each = [".yml", ".yaml"]

    content {
      topic_arn     = aws_sns_topic.yaml_file_converter.arn
      events        = ["s3:ObjectCreated:*"]
      filter_suffix = topic.value
    }
  }
}
