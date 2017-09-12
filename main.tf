terraform {
  backend "atlas" {
    name    = "j974670/dev"
    address = "https://lab01.cf.mcteague.co.uk"
  }
}

provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
}

resource "aws_elb" "web" {
  name = "terraform-example-elb"

  # The same availability zone as our instances

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  subnets = ["subnet-6f8c5b0b"]
  # The instances are registered automatically
  instances = ["${aws_instance.web.*.id}"]
}

resource "aws_instance" "web" {
  instance_type = "t2.large"
  ami           = "${lookup(var.aws_amis, var.aws_region)}"
  subnet_id     = "subnet-6f8c5b0b"
  # This will create 4 instances
  count = 1
}
