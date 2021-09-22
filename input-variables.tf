variable "prefix" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "teams" {
  type = list(object({
    teamName = string
    pubKey = string
  }))
}
