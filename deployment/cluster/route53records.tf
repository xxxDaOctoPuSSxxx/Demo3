



resource "aws_route53_record" "bot" {
  zone_id = data.aws_route53_zone.jbot.zone_id
  name    = "${var.domain_name}"
  type    = "A"
  alias {
    name = aws_alb.main.dns_name
    zone_id = aws_alb.main.zone_id
    evaluate_target_health = true
  }

}

resource "aws_route53_record" "redirect_to_jbot" {
  zone_id = data.aws_route53_zone.jbot.zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = "5"

   weighted_routing_policy {
      weight = 10
    }
  set_identifier = "dev"
  records        = ["${var.sub_domain_name}"]
}
resource "aws_route53_record" "redirect_to_jbot1" {
  zone_id = data.aws_route53_zone.jbot.zone_id
  name    = "*.${var.domain_name}"
  type    = "CNAME"
  ttl     = "5"

   weighted_routing_policy {
      weight = 90
    }
  set_identifier = "main"
  records        = ["${var.sub_domain_name}"]
}


