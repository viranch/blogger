provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_instance" "blog_backend" {
    ami = "ami-21d30f42"
    instance_type = "${var.server_size}"
}
