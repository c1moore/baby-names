resource "aws_route53_record" "baby-names" {
  name    = "${aws_api_gateway_domain_name.main.domain_name}"
  type    = "A"
  zone_id = "${aws_route53_zone.baby-names.id}"

  alias {
    evaluate_target_health = false
    name                   = "${aws_api_gateway_domain_name.main.regional_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.main.regional_zone_id}"
  }
}

resource "aws_route53_zone" "baby-names" {
  name = "baby-names.c1moore.codes"

  tags = {
    Name        = "fetch-guesses"
    Project     = "BabyNames"
    Environment = "production"
    Provisioner = "terraform"
    Expiration  = "2019-09-02"
  }
}
