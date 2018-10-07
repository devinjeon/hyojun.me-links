resource "aws_api_gateway_rest_api" "links" {
  name        = "links"
  description = "Redirection"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "links" {
  rest_api_id = "${aws_api_gateway_rest_api.links.id}"
  parent_id   = "${aws_api_gateway_rest_api.links.root_resource_id}"
  path_part   = "${element(sort(keys(var.links)), count.index)}"
  count       = "${length(keys(var.links))}"
}

resource "aws_api_gateway_method" "links" {
  rest_api_id   = "${aws_api_gateway_rest_api.links.id}"
  resource_id   = "${aws_api_gateway_resource.links.*.id[count.index]}"
  http_method   = "GET"
  authorization = "NONE"
  count         = "${length(keys(var.links))}"
}

resource "aws_api_gateway_integration" "links" {
  rest_api_id = "${aws_api_gateway_rest_api.links.id}"
  resource_id = "${aws_api_gateway_resource.links.*.id[count.index]}"
  http_method = "${aws_api_gateway_method.links.*.http_method[count.index]}"
  type        = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{"statusCode": 301}
EOF
  }

  count = "${length(keys(var.links))}"
}

resource "aws_api_gateway_integration_response" "links" {
  depends_on  = ["aws_api_gateway_integration.links"]
  rest_api_id = "${aws_api_gateway_rest_api.links.id}"
  resource_id = "${aws_api_gateway_resource.links.*.id[count.index]}"
  http_method = "${aws_api_gateway_method.links.*.http_method[count.index]}"
  status_code = 301

  response_parameters = {
    "method.response.header.location" = "'${var.links[element(sort(keys(var.links)), count.index)]}'"
  }

  count = "${length(keys(var.links))}"
}

resource "aws_api_gateway_method_response" "links" {
  rest_api_id = "${aws_api_gateway_rest_api.links.id}"
  resource_id = "${aws_api_gateway_resource.links.*.id[count.index]}"
  http_method = "${aws_api_gateway_method.links.*.http_method[count.index]}"
  status_code = 301

  response_parameters = {
    "method.response.header.location" = true
  }

  count = "${length(keys(var.links))}"
}

locals {
  # Deployment issue: https://github.com/hashicorp/terraform/issues/6613
  file_hashes = [
    "${md5(file("${path.module}/main.tf"))}",
    "${md5(jsonencode(var.links))}",
    "${md5(var.acm_domain_name)}",
    "${md5(var.custom_domain_name)}",
  ]

  deploy_hash = "${join(",", local.file_hashes)}"
}

resource "aws_api_gateway_deployment" "links" {
  depends_on = [
    "aws_api_gateway_integration.links",
  ]

  stage_description = "${local.deploy_hash}"

  rest_api_id = "${aws_api_gateway_rest_api.links.id}"
  stage_name  = "main"

  # Deployment issue: https://github.com/hashicorp/terraform/issues/10674
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_acm_certificate" "links" {
  domain   = "${var.acm_domain_name}"
  statuses = ["ISSUED"]
}

resource "aws_api_gateway_domain_name" "links" {
  domain_name              = "links.hyojun.me"
  regional_certificate_arn = "${data.aws_acm_certificate.links.arn}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "test" {
  api_id      = "${aws_api_gateway_rest_api.links.id}"
  stage_name  = "${aws_api_gateway_deployment.links.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.links.domain_name}"

  # Deployment issue: https://github.com/hashicorp/terraform/issues/10674
  lifecycle {
    create_before_destroy = true
  }
}
