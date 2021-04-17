terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "AIGISUK"

    workspaces {
      name = "ks3-cluster-dev"
    }
  }
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}
provider "digitalocean" {
  token = var.do_token
}
resource "random_string" "k3s_token" {
  length  = 48
  upper   = false
  special = false
}