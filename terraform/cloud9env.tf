# Cloud9 - Entwicklungsumgebung, um gemeinsam inm Browser Code zu schreiben


resource "aws_cloud9_environment_ec2" "example" {
  instance_type = "t2.micro"
  name          = "cc-group-env"
}

data "aws_instance" "cloud9_instance" {
  filter {
    name = "tag:aws:cloud9:environment"
    values = [
    aws_cloud9_environment_ec2.example.id]
  }
}

