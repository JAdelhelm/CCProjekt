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
  access_key = "ASIAYVV5L5WH6MIAD5XQ"
  secret_key = "cXjHQyccM7QOlATeo54Dv56dhOYKdi7X9+UIpa00"
  token      = "FwoGZXIvYXdzEBEaDEMMyPzKWw//B5nEpSLXARY94BYKPFVd1NAqh84cnYiT8QuwM4kkG82xxx+E4OJ8kOx26OVjpUR0Vz2kGEAtFV/oGAGvFXbwbjbA/S6UCW192Zwn+K02XgkgMN0brS+h8pHGAmDAorwE2lbYO+TfJOp2pLe8I48kZ628TkLoJcgkMCFFM1rGIP/OQMUPo3FCMRm47F3mQNOGCQ2OwCvnrpPflDKEdLihC/Lzpi9IO1fu4cNjeaisv1/tA8LasMNRk/+Rmcj50JEC2XgqL3d84+bl7bY3b4vJM9Yh5dLu64SgZdMICTwKKKCst5kGMi0cpzp5nfDSTMGAtE8oESN6CCsAPYeCL4WEESLYIqOy2+ecrCtdKz5cNrCp7Ko="
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

# Load Balancer configuration

# Database configuration two times

# Webserver configuration

# App server configuration


# s3
