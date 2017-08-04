#
# Nomad controller instances
#
resource "aws_instance" "nomad_controller" {
  ami = "${data.aws_ami.centos7_ami.id}"
  instance_type               = "${var.instance_nomad_controller}"
  subnet_id                   = "${element(split( ",", data.terraform_remote_state.vpc_rs.private_subnet), count.index)}"
  key_name                    = "${var.ssh_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.nomad_controller.id}"]
  user_data                   = "${element(data.template_file.nomad_controller.*.rendered, count.index)}"
  associate_public_ip_address = false
  # This does not work :-(
  #count                       = "${length( split( ",", data.terraform_remote_state.vpc_rs.azs ) )}"
  count                       = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
  tags {
    Name  = "nomad-controller-0${count.index+1}"
    Owner = "${var.owner}"
  }
}

#
# Nomad slave instances
#
resource "aws_instance" "nomad_slave" {
  ami = "${data.aws_ami.centos7_ami.id}"
  instance_type               = "${var.instance_nomad_slave}"
  subnet_id                   = "${element(split( ",", data.terraform_remote_state.vpc_rs.private_subnet), count.index)}"
  key_name                    = "${var.ssh_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.nomad_slave.id}"]
  user_data                   = "${element(data.template_file.nomad_slave.*.rendered, count.index)}"
  associate_public_ip_address = false
  # This does not work :-(
  #count                       = "${length( split( ",", data.terraform_remote_state.vpc_rs.azs ) )}"
  count                       = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
  tags {
    Name  = "nomad-slave-0${count.index+1}"
    Owner = "${var.owner}"
  }
}

#
# Output
#
output "nomad_controller_ip" {
  value = ["${aws_instance.nomad_controller.*.private_ip}"]
}

output "nomad_controller_id" {
  value = ["${aws_instance.nomad_controller.*.id}"]
}

output "nomad_slave_ip" {
  value = ["${aws_instance.nomad_slave.*.private_ip}"]
}

output "nomad_slave_id" {
  value = ["${aws_instance.nomad_slave.*.id}"]
}
