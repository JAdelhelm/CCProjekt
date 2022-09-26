terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = "us-east-1"
  access_key = "ASIAWN4K27KA3PWH6B5Z"
  secret_key = "lclwq452F8bzk+MrApLxPj2khKf4Xn++3hfj1wjq"
  token      = "FwoGZXIvYXdzEFgaDMrbikGU4kdG4uJ3DiLWAYvECOve7wCeraFnsr+MyFvQKCd18cAEtlteaW+ir/7Lllrq9DxqF8GccVFb96r0pG8D0cG8/WcqEU7FAjLOue3tFFNTY/MJapTvaXtFJYC5Czmus9A3ywA5u2h7RdmeflNOiqPyRLEhOYRSp5MnAywoMO3hWPSueah5S1DgycmOpj1UAn4LmU6quO3e9SGFIo4U+j2EBrHxikGal76hopFuOtZZ91FEclvQgH2G+RkP/c4velPMz+cLcfj0CRwAi7OEBjSykrN+K2CKgJinFzT1WwdfIFooxevGmQYyLfJ4tmZqou8v7hDTjcZSLuwueS9SJOmGnRLdYVsHzd4zAddxr8K6qXETvel4lQ=="
}

resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id
}



resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
}




resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table_association" "public_rt_association" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_instance" "webserver" {
  ami               = "ami-052efd3df9dad4825"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  # security_groups   = [aws_security_group.sg.id]

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  user_data = <<-EOF
#!/bin/bash
    sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF

  tags = {
    Name = "apache-webserver"
  }
}

resource "aws_security_group" "sg" {
  name        = "allow_ssh_http_https"
  description = "Allow ssh http https inbound traffic"
  vpc_id      = aws_vpc.app_vpc.id

  # Port 22  SSH
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Port 80 HTTP
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Port 443 HTTPS
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_http_https"
  }
}

resource "aws_s3_bucket" "bucket_example" {
  bucket = var.s3_bucket_name
  tags   = var.tags

}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.bucket_example.id
  acl    = "public-read-write"
}


resource "aws_db_instance" "mysql-database" {
  allocated_storage    = 10
  db_name              = "coolDB"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "supergutespasswort"
  skip_final_snapshot  = true
}



# Optional, falls nicht erstellt wird, 
# weiß man auf Terraform-Seite allerdings nicht das 
#  die erstellt wurde (arn = Unique identifier)
output "s3_bucket_arn" {
    value = aws_s3_bucket.bucket_example.arn
}

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.public_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.sg.id]
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.igw]
}

output "web_instance_ip" {
  value = aws_instance.webserver.public_ip
}


