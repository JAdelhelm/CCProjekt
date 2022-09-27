terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Hier die Schlüsselpaare übergeben vom
# AWS LAB
provider "aws" {
  region     = "us-east-1"
  access_key = "ASIAWN4K27KA2QXA2PIS"
  secret_key = "nrPjY1s0Cg9dRI3YGDscb+4QpszU6sATfrgsPuzm"
  token      = "FwoGZXIvYXdzEGsaDMP+wHKwhG4YuBkdKCLWAXLVxt6cdIMAvMrqUmokaEIn4heVyOgudalqZOjI9TwB/4DpkDZcHJdrcBdCnydoZ+45uI6uowWKIIaL763Z2Gz9C0kz+TJcP/PPgYCKuKuewKNopw4/UEabD5IwA3YOMOO7OAONMSmixLdL+DbBgvrHXF81J3p1r1Q51cm71t3CMyr5jJZYFk8tF4UkbL7OZgV7U4J4bFRFt2cSomnpuheOjgCwiDb+3N4JnGq4VeYBxnIHeoEDirFoguVO6AkfWp5wYtXuYPhVeTFfhUKa76fKA8HW2zUowYvLmQYyLYGqV/XnpQ1AukAmY8SRw6cREyvUgpPkCBcFbDPWXrZ6d5ILJjoljg8e0dEYcw=="
}