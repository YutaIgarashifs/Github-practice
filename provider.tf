terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # --------------------------------------------------------------------- 
  # 1. 最初はコメントアウト(#)したまま `terraform apply` でバケット作成
  # 2. その後にコメントアウトを外して `terraform init` でBackend有効化
  # ---------------------------------------------------------------------
   backend "s3" {
     bucket = "tf-state-igarashi-unique-name-123" 
     key    = "prod/terraform.tfstate"
     region = "ap-northeast-1"
   }
}

provider "aws" {
  region = var.region
}