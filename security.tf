###############################
# Security groups Definitions #
###############################

# Security group for access to nomad controller resources
resource "aws_security_group" "nomad_controller" {
  name        = "${var.owner}_nomad_controller"
  description = "Allow all inbound traffic to nomad controller"
  vpc_id      = "${data.terraform_remote_state.vpc_rs.vpc}"

  # Allow SSH remote acces
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${data.terraform_remote_state.bastion_rs.sg_bastion}"]
  }

  # Allow ICMP traffic
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  # Allow nomad traffic
  ingress {
    from_port   = 4646
    to_port     = 4648
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 4646
    to_port     = 4648
    protocol    = "udp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  # Allow consul traffic
  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 8400
    to_port     = 8400
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 8400
    to_port     = 8400
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 8300
    to_port     = 8305
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  # Allow outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name  = "${var.owner}_nomad_controller"
    owner = "${var.owner}"
  }
}

# Security group for access to nomad slave resources
resource "aws_security_group" "nomad_slave" {
  name        = "${var.owner}_nomad_slave"
  description = "Allow all inbound traffic to nomad slave"
  vpc_id      = "${data.terraform_remote_state.vpc_rs.vpc}"

  # Allow SSH remote acces
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${data.terraform_remote_state.bastion_rs.sg_bastion}"]
  }

  # Allow ICMP traffic
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  # Allow nomad traffic
  ingress {
    from_port   = 4646
    to_port     = 4648
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 4646
    to_port     = 4648
    protocol    = "udp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  # Allow consul traffic
  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 8400
    to_port     = 8400
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 8400
    to_port     = 8400
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 8300
    to_port     = 8305
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  # Allow outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name  = "${var.owner}_nomad_slave"
    owner = "${var.owner}"
  }
}

#
# Outputs
#

output "sg_nomad_controller" {
  value = "${aws_security_group.nomad_controller.id}"
}

output "sg_nomad_slave" {
  value = "${aws_security_group.nomad_slave.id}"
}
