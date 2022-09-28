resource "aws_lb" "application_lb" {
  name               = "application-lb-terra"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets           = [aws_subnet.public_subnet.id, aws_subnet.public_subnet2.id]
#   [for subnet in public_subnet : subnet.id]

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.bucket_example.id
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb" "network_lb" {
  name               = "network-lb-terra"

  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.public_subnet2.id]
# False gesetzt, damit die Loadbalancer bei erneutem deployen raus-
# geschmissen werden.
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

