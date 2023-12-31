# get the hosted zone for our root domain
data "aws_route53_zone" "root_domain" {
  name         = var.root_domain
  private_zone = false
}
# create certificate 
resource "aws_acm_certificate" "certificate" {
  domain_name       = var.subdomain
  validation_method = "DNS"
}
# create new record in route53
resource "aws_route53_record" "certificate_validation" {
  name    = tolist(aws_acm_certificate.certificate.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.certificate.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.root_domain.zone_id
  records = [tolist(aws_acm_certificate.certificate.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}
# validate certificate
resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [aws_route53_record.certificate_validation.fqdn]
}

# create subdomain
resource "aws_api_gateway_domain_name" "domain_name" {
  domain_name              = var.subdomain
  regional_certificate_arn = aws_acm_certificate_validation.certificate_validation.certificate_arn
  endpoint_configuration {
    types = [
      "REGIONAL",
    ]
  }
}
# connect domain to stage and resources in stage
resource "aws_api_gateway_base_path_mapping" "path_mapping" {
  api_id      = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.rest_api_stage.stage_name
  domain_name = aws_api_gateway_domain_name.domain_name.domain_name
}

# create route53 record for the domain to be used with rest api
resource "aws_route53_record" "sub_domain" {
  name    = var.subdomain
  type    = "A"
  zone_id = data.aws_route53_zone.root_domain.zone_id
  alias {
    name                   = aws_api_gateway_domain_name.domain_name.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.domain_name.regional_zone_id
    evaluate_target_health = false
  }
}

