variable "teams" {
  type = list(object({
    teamName = string
    pubKey = string
  }))
  default = [
      {
        teamName        = "team-alpha"
        pubKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWYJF+cDgUZyOIoAHQlzmBV/BOl9PlOcKqLy3Vqy/eFoHABtOqNnMun2Bm3jdLzTdUCoV9N+oW+oyCYmt7NkxwiBHMe1oijRUG6amwKgeY+YQpmDymRWDr1ZY2Ww6JEG6BU33WXlF9TjfuR/SkDr1zi0g9HbJ06lNTGxqpyfQCNg7VgZAGXiOSt5RJAEzMm2DlIX3y4wJuwRNquMwQCLEzaFTCoj8U5tB0IImFYKy98CFld4+JJMMKIzIIcN7+UgLstW1yVjYl6uxXPfQFd90oop5rt7vcRlcJSdgc40Z896WxY0VyHzBWNGrssgq5umRrDFfrXeLVWQg7sehTL5BOts2D7IY8V5mbfRrLr+LKxjhwEm0cOnYdqoL/ghhPKQWyBqPZqGeuyvBGLheB96wL7uSqprW33eUjfAyICEhx82KkXM+CzwaoQChAoX/HToByOHuEm9uRAlLGupfOJpppVLrsiuWWpRoDHUUSVI0wjxvqLwXCxDNRgz4Q88Lv4+8= hackzurich"
      }
    ]
}



terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.59.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_vpc" "hackzurich_test" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "hackzurich-test-101"
  }
}

resource "aws_eip" "hackzurich_eip" {
  vpc = true
  depends_on                = [aws_internet_gateway.hackzurich_test_gw]
}

resource "aws_internet_gateway" "hackzurich_test_gw" {
  vpc_id = aws_vpc.hackzurich_test.id
}
resource "aws_key_pair" "deployer" {
  for_each          = { for o in var.teams : o.teamName => o }
  key_name   = "deployer-key-${each.value.teamName}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

resource "aws_subnet" "hackzurich_test_subnet" {
  vpc_id     = aws_vpc.hackzurich_test.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.hackzurich_test_gw]
  tags = {
    Name = "hackzurich_test_subnet"
  }
}
resource "aws_network_interface" "hackzurich_if" {
  for_each          = { for o in var.teams : o.teamName => o }
  subnet_id   = aws_subnet.hackzurich_test_subnet.id
  #private_ips = ["10.1.1.${index(var.teams, each.value) + 1}"]

  tags = {
    Name = "primary_network_interface"
  }
}
resource "aws_security_group" "allow_ssl_http" {
  name        = "hack-zurich-test-group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.hackzurich_test.id

  ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["10.1.1.0/24"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = true
    }
  ]

  tags = {
    Name = "allow_ssl_http"
  }
}

resource "aws_instance" "app_server" {
  for_each          = { for o in var.teams : o.teamName => o }
  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  key_name = "deployer-key-${each.value.teamName}"
  network_interface {
    network_interface_id = aws_network_interface.hackzurich_if[each.value.teamName].id
    device_index         = 0
  }
  tags = {
    Name = "ExampleAppServerInstance-hackzurich-test"
    Team = "${each.value.teamName}"
  }
}
