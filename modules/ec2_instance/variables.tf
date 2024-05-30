variable "instance_type" {
	type = string
	default = "t2.micro"
	description = "Type of EC2 instance(Mix of the CPU,RAM,Disk,Network components)"
}

variable "in_public_subnet" {
	type = bool
	default = true
	description = "Create instance in public subnet or not"
}

variable "pub_sub_a_id" {
	type = string
	description = "Id of the public subnet(in <a> zone)"
}

variable "pub_sub_b_id" {
  type = string
	default = ""
  description = "Id of the public subnet(in <b> zone)"
}

variable "priv_sub_a_id" {
  type = string
	default = ""
  description = "Id of the private subnet(in <a> zone)"
}

variable "priv_sub_b_id" {
  type = string
	default = ""
  description = "Id of the private subnet(in <b> zone)"
}

variable "sec_group_id" {
	type = any
	default = ""
}
