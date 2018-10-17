provider "aws" {
  region = "ap-northeast-1"
}

module "links" {
  source = "github.com/DevinJeon/terraform-redirect?ref=1.0.0"

  acm_domain_name    = "*.hyojun.me"
  custom_domain_name = "links.hyojun.me"

  links = {
    "ndc18"   = "https://www.slideshare.net/ssuser380e9c/ndc18-95524337"
    "ndc18-2" = "https://www.slideshare.net/ssuser380e9c/ndc18-2-95522893"
    "wedding" = "http://dvmade.co.kr/invi/1536916904"
    "github"  = "https://github.com/DevinJeon"
  }
}

output "target_domain_name" {
  value = "${module.links.target_domain_name}"
}
