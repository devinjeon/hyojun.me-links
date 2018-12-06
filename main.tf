module "links" {
  source = "github.com/DevinJeon/terraform-redirect?ref=1.0.1"

  acm_domain_name    = "*.hyojun.me"
  custom_domain_name = "links.hyojun.me"

  links = {
    "ndc18"     = "https://www.slideshare.net/ssuser380e9c/ndc18-95524337"
    "ndc18-2"   = "https://www.slideshare.net/ssuser380e9c/ndc18-2-95522893"
    "github"    = "https://github.com/devinjeon"
    "portfolio" = "https://hyojun.me/portfolio/"
    "vin.sh"    = "https://github.com/devinjeon/vin.sh"
  }
}

output "target_domain_name" {
  value = "${module.links.target_domain_name}"
}
