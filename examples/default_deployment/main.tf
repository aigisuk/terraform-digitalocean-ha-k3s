terraform {
  # Reconfigure the backend block to suit your needs
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "AIGISUK"

    workspaces {
      name = "gh-actions-terraform-digitalocean-ha-k3s"
    }
  }
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
  required_version = ">= 0.13"
}

provider "digitalocean" {
  token = var.do_token
}

module "ha-k3s" {
  source = "github.com/aigisuk/terraform-digitalocean-ha-k3s"

  do_token             = var.do_token
  ssh_key_fingerprints = var.ssh_key_fingerprints
}