#
# Consul key for signing in Puppet
#
resource "consul_keys" "nomad_controller_signing" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"
    count      = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
    # Set signing key
    key {
        path = "${data.terraform_remote_state.vpc_rs.vdc}/signed/nomad-controller-0${count.index+1}.${var.tld}"
        value = "true"
        delete = true
    }
}

resource "consul_keys" "nomad_slave_signing" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"
    count      = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
    # Set signing key
    key {
        path = "${data.terraform_remote_state.vpc_rs.vdc}/signed/nomad-slave-0${count.index+1}.${var.tld}"
        value = "true"
        delete = true
    }
}

#
# Consul key for consul hiera backend in Puppet
#
resource "consul_keys" "nomad_controller_hiera" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"
    count      = "${length( split( ",", lookup( var.azs, var.region ) ) )}"

    key {
        path = "${var.consul_hiera_path}/nomad-controller-0${count.index+1}.${var.tld}/role"
        value = "nomad-controller"
        delete = true
    }
}

resource "consul_keys" "nomad_slave_hiera" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"
    count      = "${length( split( ",", lookup( var.azs, var.region ) ) )}"

    key {
        path = "${var.consul_hiera_path}/nomad-slave-0${count.index+1}.${var.tld}/role"
        value = "nomad-slave"
        delete = true
    }
}
