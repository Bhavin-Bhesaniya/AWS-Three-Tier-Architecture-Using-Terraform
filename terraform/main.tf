terraform {
  backend "s3" {
    bucket         = "terraform-statefile-s3bucket"
    dynamodb_table = "state-lock"
    key            = "global/mystatefile/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.37.0"
    }
  }
}

provider "aws" {
  region = var.az
}

