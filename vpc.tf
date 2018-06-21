#
# From: https://www.unixdaemon.net/cloud/managing-aws-vpc-default-security-group-terraform/
#


# Default VPC defnitiion so it doesn't freak out
resource "aws_vpc" "myvpc" {
  cidr_block = "10.2.0.0/16"
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.myvpc.id}"

  # ... snip ...
  # security group rules can go here
}

# We could also add a specified port here if we wanted.Thanks Major!
data "http" "my_local_ip" {
    url = "https://ipv4.icanhazip.com"
}

# Chomp here is a built in for tf that allows interpolation
resource "aws_security_group_rule" "ssh_from_me" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["${chomp(data.http.my_local_ip.body)}/32"]

  security_group_id = "${aws_default_security_group.default.id}"
}
