locals {
  cloudflare_domain  = "hyojun.me"
  acm_domain_name    = "*.hyojun.me"
  custom_domain_name = "links.hyojun.me"
}

module "links" {
  source = "github.com/DevinJeon/terraform-redirect?ref=1.0.2"

  acm_domain_name    = "${local.acm_domain_name}"
  custom_domain_name = "${local.custom_domain_name}"

  links = {
    "google"      = "https://www.google.com"
    "ndc18"       = "https://github.com/devinjeon/NDC18"
    "ndc18-slide" = "https://speakerdeck.com/devinjeon/ndc18-yasaengyi-ddang-dyuranggoyi-deiteo-enjinieoring-iyagi-rogeu-siseutem-gucug-gyeongheom-gongyu"
    "ndc19"       = "https://github.com/devinjeon/NDC19"
    "linkedin"    = "https://www.linkedin.com/in/devinjeon/"
    "github"      = "https://github.com/devinjeon"
    "vin.sh"      = "https://github.com/devinjeon/vin.sh"
    "resume"      = "https://www.notion.so/devinjeon/Hyojun-Jeon-e096c75cae4b4296a63233ab446a57ae"
    "resume-ko"   = "https://www.notion.so/devinjeon/dd9c03879a084c74b5a0ae179228badb"
  }
}

# ------------------------------------------------------------
# Cloudflare(Optional)
# * Create record and Make page rule in Cloudflare.
# * You can have pretty url that is more memorable!
# * Example
#    : https://domain.me/~{blahblah} = https://links.domain.me/{blahblah}
# * What is Page rule?
#    -> https://support.cloudflare.com/hc/en-us/articles/218411427-Page-Rules-Tutorial#redirects
# * Set variables `CLOUDFLARE_EMAIL` and `CLOUDFLARE_TOKEN` in shell.
#    -> https://support.cloudflare.com/hc/en-us/articles/200167836-Where-do-I-find-my-Cloudflare-API-key
# ------------------------------------------------------------

# 1. Create record -> links.{your_domain}
resource "cloudflare_record" "links" {
  domain = "${local.cloudflare_domain}"
  name   = "links"

  value   = "${module.links.target_domain_name}"
  type    = "CNAME"
  proxied = true
}

# 2. Make page rules for forwarding url
resource "cloudflare_page_rule" "links" {
  zone   = "${local.cloudflare_domain}"
  target = "${local.cloudflare_domain}/~*"

  actions = {
    forwarding_url {
      url         = "https://${local.custom_domain_name}/$1"
      status_code = "301"
    }
  }
}
