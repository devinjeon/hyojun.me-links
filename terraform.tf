# AWS
provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  backend "s3" {
    bucket = "devin-terraform"
    key    = "states/hyojun-links.tfstate"
    region = "ap-northeast-1"
  }
}
