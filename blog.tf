provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_key_pair" "user-key" {
    key_name = "deploy-key"
    public_key = "${var.ssh_key}"
}

resource "aws_instance" "backend" {
    count = "${var.server_count}"
    ami = "ami-21d30f42"
    instance_type = "${var.server_size}"
    key_name = "${aws_key_pair.user-key.key_name}"
    tags {
        Name = "${var.app}${count.index + 1}.${var.env}"
        Group = "backend"
        sshUser = "ubuntu"
    }
}

resource "aws_elb" "frontend" {
    availability_zones = ["${var.region}a", "${var.region}b"]
    listener {
        lb_port = 80
        instance_port = 80
        lb_protocol = "http"
        instance_protocol = "http"
    }
    instances = ["${aws_instance.backend.*.id}"]
}

output "elb_ip" {
    value = "${aws_elb.frontend.dns_name}"
}
