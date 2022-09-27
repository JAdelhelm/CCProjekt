resource "aws_lb" "application_lb" {
  name               = "application-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets           = [aws_subnet.public_subnet.id, aws_subnet.public_subnet2.id]
#   [for subnet in public_subnet : subnet.id]

  enable_deletion_protection = true

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
  name               = "network-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.public_subnet2.id]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

resource "aws_lb" "elasticIP" {
  name               = "elasticIPExample"
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet.id
    allocation_id = aws_eip.one.id
  }

  subnet_mapping {
    subnet_id     = aws_subnet.public_subnet2.id
    allocation_id = aws_eip.one.id
  }
}