#
# Consul key for FQDN
#
resource "consul_keys" "nomad_controller" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"
    count      = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
    # Create the entry for DNS
    key {
        path = "app/bind/${data.terraform_remote_state.vpc_rs.vdc}.lan/nomad-controller-0${count.index+1}"
        value = "A ${element(aws_instance.nomad_controller.*.private_ip, count.index)}"
        delete = true
    }
}

resource "consul_keys" "nomad_slave" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"
    count      = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
    # Create the entry for DNS
    key {
        path = "app/bind/${data.terraform_remote_state.vpc_rs.vdc}.lan/nomad-slave-0${count.index+1}"
        value = "A ${element(aws_instance.nomad_slave.*.private_ip, count.index)}"
        delete = true
    }
}
