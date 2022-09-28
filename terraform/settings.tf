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
  access_key = "ASIAWN4K27KA7GFOBJUC"
  secret_key = "AkYl16XPKZnc7JXAzGTi2Q4eevbYFkbpsHrBbh/Q"
  token      = "FwoGZXIvYXdzEIv//////////wEaDG33lMgG3TV9V7KLaCLWAUe41dCk4Uvs22Gur0ZXheIkc6Oqx12ZJyGlGahc7p0M7z24s1GF0qwIVvRbWm65mCyx0MMutUui55m3ENTeBXhyQsLCQOttKSoBHe+yH6eBPYk24WCHdZS+669gPgLz8MOciPs9rfw5Ov0+SgCuzKDBsGN9kTmpJTGYuAl8sYVAelRMl4VPfp6NCXgSgahTOCytUyPHgQ7PV5DceKVyF9Ljyird2MpYVZkGmdVv0UXh53qS7HxvG6MW0vsQfvMMgzdZG7sFoMmqpdxgnO2ZB/62LpjRDFYo+P/RmQYyLQKByUmvxCZhlvBVDzuAbk7jpRrzMNWiMV+koAV+UAyfmigJdcJJ1/kx+4sxwQ=="
}