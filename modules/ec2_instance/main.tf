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

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ami.id
  instance_type = "t3.micro"
  associate_public_ip_address = true
  subnet_id = var.subnet_id
  vpc_security_group_ids = []
  key_name = aws_key_pair.key.key_name
  user_data = "${file("install_docker.sh")}"

  tags = {
    Name = "Custom EC2 - 2"
  }
}
