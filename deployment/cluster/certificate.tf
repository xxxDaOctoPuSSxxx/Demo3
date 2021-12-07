
resource "aws_acm_certificate" "jbot" {
  domain_name       = "${var.domainname}"
  validation_method = "DNS"
}

data "aws_route53_zone" "jbot" {
  name         = "${var.domainname}"
  private_zone = false
}

resource "aws_route53_record" "jbot" {
  for_each = {
    for dvo in aws_acm_certificate.jbot.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.jbot.zone_id
}

resource "aws_acm_certificate_validation" "jbot" {
  certificate_arn         = aws_acm_certificate.jbot.arn
  validation_record_fqdns = [for record in aws_route53_record.jbot : record.fqdn]
}

