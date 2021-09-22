resource "aws_key_pair" "deployer" {
  for_each   = { for o in var.teams : o.teamName => o }
  key_name   = "${var.prefix}-${each.value.teamName}"
  public_key = each.value.pubKey

  tags = {
    Name = "${var.prefix}-${each.value.teamName}"
    Team = "${each.value.teamName}"
  }
}
