#Key-gen
resource "tls_private_key" "key-gen" {
  algorithm = var.key_algorithm
  rsa_bits = var.rsa_bits
}

resource "aws_key_pair" "key" {
  key_name = "priv-key.pem"
  public_key = tls_private_key.key-gen.public_key_openssh
}

resource "local_file" "key-file" {
  content = tls_private_key.key-gen.private_key_pem
  filename = "priv-key.pem"
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical(ubuntu)
}

resource "aws_instance" "pub-ec2" {
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type
  associate_public_ip_address = var.in_public_subnet
  #subnet_id = var.pub_sub_a_id
  #vpc_security_group_ids = [var.sec_group_id]
  key_name = aws_key_pair.key.key_name
  user_data = "${path.module}/./user_data/${var.sh_file}"

  tags = {
    Name = "Custom EC2"
  }
}
