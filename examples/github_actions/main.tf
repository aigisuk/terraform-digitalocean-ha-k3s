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
  required_version = ">= 0.15"
}

provider "digitalocean" {}

module "ha-k3s" {
  source = "git::https://github.com/aigisuk/terraform-digitalocean-ha-k3s.git?ref=develop"

  do_token             = var.do_token
  ssh_key_fingerprints = var.ssh_key_fingerprints
}