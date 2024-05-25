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
