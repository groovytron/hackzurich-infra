variable "teams" {
  type = list(object({
    teamName = string
    pubKey = string
  }))
  default = [
      {
        teamName        = "team-julien"
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
  cidr_block       = "10.2.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "julien_vpc"
  }
}

resource "aws_internet_gateway" "hackzurich_test_gw" {
  vpc_id = aws_vpc.hackzurich_test.id

  tags = {
    Name = "julien_gateway"
  }
}

resource "aws_route_table" "hackzurich_route_table" {
  vpc_id = aws_vpc.hackzurich_test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hackzurich_test_gw.id
  }
}

resource "aws_subnet" "hackzurich_test_subnet" {
  vpc_id     = aws_vpc.hackzurich_test.id

  cidr_block = "10.2.1.0/24"

  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.hackzurich_test_gw]

  tags = {
    Name = "julien_subnet"
  }
}

resource "aws_route_table_association" "public_route_table" {
  subnet_id      = aws_subnet.hackzurich_test_subnet.id
  route_table_id = aws_route_table.hackzurich_route_table.id
}

resource "aws_security_group" "julien_security_group" {
  name        = "julien-security-group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.hackzurich_test.id

  ingress = [
    {
      description      = "Access from everywhere"
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = true
    }
  ]

  egress = [
    {
      description      = "Access to everywhere"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self = false
      prefix_list_ids  = []
      security_groups  = []
    }
  ]

  tags = {
    Name = "julien_security_group"
  }
}

resource "aws_instance" "app_server" {
  for_each          = { for o in var.teams : o.teamName => o }
  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  # key_name = "deployer-key-${each.value.teamName}"

  vpc_security_group_ids = [
    aws_security_group.julien_security_group.id
  ]

  subnet_id = aws_subnet.hackzurich_test_subnet.id

  tags = {
    Name = "Instance julien"
    Team = "${each.value.teamName}"
  }
}
