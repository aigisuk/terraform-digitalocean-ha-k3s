resource "digitalocean_vpc" "k3s_vpc" {
  name   = "k3s-vpc-01"
  region = var.region
}