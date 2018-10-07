variable "links" {
  type        = "map"
  description = "'*.domain.com/<key>' is redirected to '<value>'"
}

variable "acm_domain_name" {
  type        = "string"
  description = "AWS Certificate Manager domain name. ref: https://ap-northeast-1.console.aws.amazon.com/acm/"
}

variable "custom_domain_name" {
  type        = "string"
  description = "Add custom domain name"
}
