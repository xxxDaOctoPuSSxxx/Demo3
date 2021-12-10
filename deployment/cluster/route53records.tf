

#resource "aws_route53_zone_association" "app" {
#  zone_id = data.aws_route53_zone.jbot.zone_id
#  vpc_id  = aws_vpc.demo_vpc.id
#}

#data "aws_route53_zone" "public" {
#  name         = "${var.domain_name}"
#  private_zone = false
#}

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

#resource "aws_route53_record" "www" {
 # zone_id = data.aws_route53_zone.public.zone_id
  #name    = "${var.domainname}"
  #type    = "A"
  #ttl     = "300"
  #records = [aws_alb.main.dns_name]
#}
