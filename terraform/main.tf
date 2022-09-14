# AWS Version - Konfiguration
# Provider definieren
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
# Terraform Version
  required_version = ">= 1.2.0"
}


# API KEY - AWS
# AWS Provider - Konfiguration
# 
# Hier werden die CREDENTIALS übergeben
provider "aws" {
  region     = "us-east-1"
  access_key = "ASIAWN4K27KAXPCE7TGV"
  secret_key = "3/hUqBS/8TUZY2z2duit896P3fe+Z4ZwVxvHFMLi"
  token = "FwoGZXIvYXdzEDQaDE+YofOEjWAzmPhxJiLWAXQrKZIrfsU+DJnVCFSEaUPOO1dxEuZOx6agpSXHMRNMW/P06MDEjo1kZJSd1dWYl1ypfFtevcfeWGTZMpzGpzXuGJFG8l6qEsycAvtrDHqCi7kjyXARFLbcF7iLNemyMtyakLGSrOg4Aht9XP7kvBaJG4GAVTgZy3eWdEYhrxTzDM8IfjALJLwhl4jMma9JPg88qKMJwq5++d63LNVE4a7ZlV6UbJQ+QeMxCWpBeN1MGRfK5oVfgNiuBlA9Ctq8j48olT/K3esEpCdXYqdOcAvF5hUwPfYoyeSGmQYyLUgBDAghhXREZG1CdaYlRzVTFl+ChM3Z3jhfcZYnfsfDoJ+hBanrFpyrkLQk7g=="
}





# Ressource zu AWS Provider hinzufügen
# Instance Type - Dokumentation wird benötigt
# Stellt eine VPC-Ressource zur Verfügung. // Virtuelle private Cloud
resource "aws_vpc" "app_vpc" {
  cidr_block = "178.0.0.0/16"
}

# Internet gateway für die vi rtuelle private cloud
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id
}


resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "178.0.0.0/16"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rt_association" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_instance" "webserver" {
  # Name = "Webserver Beispiel - Cloud Computing"
  ami             = "ami-052efd3df9dad4825"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.sg.id]

  user_data = <<-EOF
#!/bin/bash
    sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF
}



resource "aws_security_group" "sg" {
  name        = "allow_ssh_http"
  description = "Allow ssh http inbound traffic"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
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
    Name = "allow_ssh_http"
  }
}

output "web_instance_ip" {
  value = aws_instance.webserver.public_ip
}

# Load Balancer configuration

# Database configuration two times

# Webserver configuration

# App server configuration


# s3
