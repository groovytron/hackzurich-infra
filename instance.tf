resource "aws_instance" "hackzurich_training_server" {
  for_each        = { for o in var.teams : o.teamName => o }
  ami             = "ami-05f7491af5eef733a"
  instance_type   = var.instance_type
  key_name        = "${var.prefix}-${each.value.teamName}"
  security_groups = ["${aws_security_group.allow_ssl_http.id}"]
  subnet_id       = aws_subnet.hackzurich_subnet.id

  tags = {
    Name = "${var.prefix}-${each.value.teamName}"
    Team = "${each.value.teamName}"
  }
}
