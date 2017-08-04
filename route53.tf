#
# ROUTE 53
#
resource "aws_route53_record" "nomad_controller" {
  zone_id = "${data.terraform_remote_state.vpc_rs.default_route53_zone}"
  name    = "nomad-controller-0${count.index+1}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.nomad_controller.*.private_ip, count.index)}"]
  count   = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
}


resource "aws_route53_record" "nomad_slave" {
  zone_id = "${data.terraform_remote_state.vpc_rs.default_route53_zone}"
  name    = "nomad-slave-0${count.index+1}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.nomad_slave.*.private_ip, count.index)}"]
  count   = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
}
