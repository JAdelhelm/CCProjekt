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
  access_key = "ASIAWN4K27KAQQQZDZDB"
  secret_key = "sM01q3u2YVLfKgqO9LCBQDJ+SwtKZoRXTV4I9Rhv"
  token      = "FwoGZXIvYXdzEHAaDJ076hJG/ot4uqIhZyLWAaLL3Ur+jQuQmGRr2eFuH/mG9C/xvMYUOArMmpSlcfGErlh9xNWNE5jvmjrVujXL+x1mDun1V+0RoftITNGoCMm1vxHDiExrbSPyWux366dHswYPHewgb0o/RJwA3rK0TibDbmFOoARFLtIxEIYVRkCqziCG0fz/coYUKSNYj3kPqnZvVmvSlOhkTtc+AhFi075KoQPKmr1d2mISi2hsAQ9Lho1AP/Zz3ZcBeweXeS240Em8ysAzIRUdYILrFlvtCBmx7yDFuhgeZgw+VjVmnsyLG9tfp6wogIvMmQYyLSdKAGo0VF2c/iNuhvzeAeW/quqaD38XGGD5AMeVo9TV6i1O9K5RoRwQwVMPDQ=="
}