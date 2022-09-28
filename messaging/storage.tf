
locals {
  s3_buckets = {
    "${var.ingestion_s3_bucket_name}" = "ingestion"
    "${var.converted_s3_bucket_name}" = "conversion"
  }
}

resource "aws_s3_bucket" "buckets" {
  for_each = local.s3_buckets
  bucket   = each.key
  tags = merge(var.tags, {
    Name      = each.key
    Component = each.value
  })
}


resource "aws_s3_bucket_notification" "file_created" {
  bucket = aws_s3_bucket.buckets[var.ingestion_s3_bucket_name].id

  dynamic "topic" {

    for_each = [".yml", ".yaml"]

    content {
      topic_arn     = aws_sns_topic.yaml_file_converter.arn
      events        = ["s3:ObjectCreated:*"]
      filter_suffix = topic.value
    }
  }
}
