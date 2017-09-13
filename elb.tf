#
# ELB  Definitions
#

resource "aws_elb" "nomad_elb" {
  name       = "${var.ownerv2}-nomad-elb"
  subnets    = ["${split( ",", data.terraform_remote_state.vpc_rs.public_subnet)}"]
  depends_on = ["aws_instance.nomad_slave"]

  listener {
    instance_port      = 9999
    instance_protocol  = "tcp"
    lb_port            = 80
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 9998
    instance_protocol  = "tcp"
    lb_port            = 9998
    lb_protocol        = "tcp"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:9999"
    interval            = 10
  }

  instances                   = ["${aws_instance.nomad_slave.*.id}"]
  security_groups             = ["${aws_security_group.nomad_elb.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

    tags {
      Name  = "nomad_elb"
      owner = "${var.owner}"
    }

}

#
# Output
#

output "nomad_elb"{
  value = "${aws_elb.nomad_elb.dns_name}"
}
