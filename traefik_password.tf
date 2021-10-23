resource "random_password" "traefik" {
  count   = var.ingress == "traefik" ? 1 : 0
  length  = 16
  special = true
  upper   = true
}