data "github_user" "admin" {
  username = "magzim21"
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
