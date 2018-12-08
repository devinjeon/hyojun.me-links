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

# Cloudflare
# * Set variable `CLOUDFLARE_TOKEN` and `CLOUDFLARE_EMAIL` in shell.
# * Where do I find my Cloudflare API Token?
# -> https://support.cloudflare.com/hc/en-us/articles/200167836-Where-do-I-find-my-Cloudflare-API-key
provider "cloudflare" {}
