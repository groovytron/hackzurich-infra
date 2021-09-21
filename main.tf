variable "teams" {
  type = list(object({
    teamName = string
    pubKey = string
  }))
  default = [
      {
        teamName        = "team-red"
        pubKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWYJF+cDgUZyOIoAHQlzmBV/BOl9PlOcKqLy3Vqy/eFoHABtOqNnMun2Bm3jdLzTdUCoV9N+oW+oyCYmt7NkxwiBHMe1oijRUG6amwKgeY+YQpmDymRWDr1ZY2Ww6JEG6BU33WXlF9TjfuR/SkDr1zi0g9HbJ06lNTGxqpyfQCNg7VgZAGXiOSt5RJAEzMm2DlIX3y4wJuwRNquMwQCLEzaFTCoj8U5tB0IImFYKy98CFld4+JJMMKIzIIcN7+UgLstW1yVjYl6uxXPfQFd90oop5rt7vcRlcJSdgc40Z896WxY0VyHzBWNGrssgq5umRrDFfrXeLVWQg7sehTL5BOts2D7IY8V5mbfRrLr+LKxjhwEm0cOnYdqoL/ghhPKQWyBqPZqGeuyvBGLheB96wL7uSqprW33eUjfAyICEhx82KkXM+CzwaoQChAoX/HToByOHuEm9uRAlLGupfOJpppVLrsiuWWpRoDHUUSVI0wjxvqLwXCxDNRgz4Q88Lv4+8= hackzurich"
      },
      {
        teamName        = "team-blue"
        pubKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWYJF+cDgUZyOIoAHQlzmBV/BOl9PlOcKqLy3Vqy/eFoHABtOqNnMun2Bm3jdLzTdUCoV9N+oW+oyCYmt7NkxwiBHMe1oijRUG6amwKgeY+YQpmDymRWDr1ZY2Ww6JEG6BU33WXlF9TjfuR/SkDr1zi0g9HbJ06lNTGxqpyfQCNg7VgZAGXiOSt5RJAEzMm2DlIX3y4wJuwRNquMwQCLEzaFTCoj8U5tB0IImFYKy98CFld4+JJMMKIzIIcN7+UgLstW1yVjYl6uxXPfQFd90oop5rt7vcRlcJSdgc40Z896WxY0VyHzBWNGrssgq5umRrDFfrXeLVWQg7sehTL5BOts2D7IY8V5mbfRrLr+LKxjhwEm0cOnYdqoL/ghhPKQWyBqPZqGeuyvBGLheB96wL7uSqprW33eUjfAyICEhx82KkXM+CzwaoQChAoX/HToByOHuEm9uRAlLGupfOJpppVLrsiuWWpRoDHUUSVI0wjxvqLwXCxDNRgz4Q88Lv4+8= hackzurich"
      },
      {
        teamName        = "team-pink"
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
  enable_dns_support = true

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
  public_key = "${each.value.pubKey}"
}

resource "aws_subnet" "hackzurich_test_subnet" {
  vpc_id     = aws_vpc.hackzurich_test.id
  #cidr_block = "10.1.1.0/24"
  cidr_block = "${cidrsubnet(aws_vpc.hackzurich_test.cidr_block, 3, 1)}"
  map_public_ip_on_launch = true


  #availability_zone = "eu-central-1"

  depends_on = [aws_internet_gateway.hackzurich_test_gw]
  tags = {
    Name = "hackzurich_test_subnet"
  }
}

resource "aws_route_table" "rt_hackzurich" {
  vpc_id = "${aws_vpc.hackzurich_test.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.hackzurich_test_gw.id}"
  }
  tags = {
    Name = "hackzurich_test-env-route-table"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.hackzurich_test_subnet.id}"
  route_table_id = "${aws_route_table.rt_hackzurich.id}"
}


# resource "aws_network_interface" "hackzurich_if" {
#   for_each          = { for o in var.teams : o.teamName => o }
#   subnet_id   = aws_subnet.hackzurich_test_subnet.id
#   #private_ips = ["10.1.1.${index(var.teams, each.value) + 1}"]
#   security_groups = [aws_security_group.allow_ssl_http.id]
#   tags = {
#     Name = "primary_network_interface"
#   }
# }
resource "aws_security_group" "allow_ssl_http" {
  name        = "hack-zurich-test-group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.hackzurich_test.id

  ingress = [
    {
      description      = "SSH from *"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = true
    }
  ]
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
  tags = {
    Name = "allow_ssl_http"
  }
}

resource "aws_instance" "app_server" {
  for_each          = { for o in var.teams : o.teamName => o }
  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  key_name = "deployer-key-${each.value.teamName}"
  security_groups = ["${aws_security_group.allow_ssl_http.id}"]
  subnet_id = "${aws_subnet.hackzurich_test_subnet.id}"

  # network_interface {
  #   network_interface_id = aws_network_interface.hackzurich_if[each.value.teamName].id
  #   device_index         = 0
  # }
  tags = {
    Name = "ExampleAppServerInstance-hackzurich-${each.value.teamName}"
    Team = "${each.value.teamName}"
  }
}
