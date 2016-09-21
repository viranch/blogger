variable "env" {}
variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "ap-southeast-1"
}

variable "server_size" {
    default = "t2.micro"
}
variable "server_count" {
    default = 1
}

variable "ssh_key" {}
