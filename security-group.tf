resource "aws_security_group" "allow_ssl_http" {
  name        = "hack-zurich-test-group"
  description = "Allow SSH & /HTTP/S inbound traffic & all outgoing"
  vpc_id      = aws_vpc.hackzurich_vpc.id

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
    },
    {
      description      = "HTTP from *"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = true
    },
    {
      description      = "HTTPS from *"
      from_port        = 443
      to_port          = 443
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
    Name = "${var.prefix}-allow_ssl_http_s"
  }
}