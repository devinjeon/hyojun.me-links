provider "aws" {
  region = "ap-northeast-1"
}

module "links" {
  source = "./module"

  acm_domain_name    = "*.hyojun.me"
  custom_domain_name = "links.hyojun.me"

  links = {
    "ndc18"   = "https://www.slideshare.net/ssuser380e9c/ndc18-95524337"
    "ndc18-2" = "https://www.slideshare.net/ssuser380e9c/ndc18-2-95522893"
    "wedding" = "http://dvmade.co.kr/invi/1536916904"
  }
}
