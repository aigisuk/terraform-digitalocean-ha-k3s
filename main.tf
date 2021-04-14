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

resource "digitalocean_project" "k3s_cluster" {
  name        = "k3s-cluster-dev"
  description = "k3s development Cluster"
  purpose     = "Kubernetes Cluster"
  environment = "Development"
}

resource "digitalocean_loadbalancer" "k3s_lb" {
  name     = "k3s-loadbalancer"
  region   = var.droplet.region
  vpc_uuid = digitalocean_vpc.k3s_vpc.id

  forwarding_rule {
    tls_passthrough = true
    entry_port      = 6443
    entry_protocol  = "https"

    target_port     = 6443
    target_protocol = "https"
  }

  healthcheck {
    port     = 6443
    protocol = "tcp"
  }

  droplet_tag = "k3s_server"
}

resource "digitalocean_vpc" "k3s_vpc" {
  name   = "k3s-vpc-01"
  region = var.droplet.region
}

resource "random_string" "k3s_token" {
  length  = 48
  upper   = false
  special = false
}

resource "digitalocean_droplet" "k3s_server" {
  image              = var.droplet.image
  name               = "k3s-server-01"
  tags               = ["k3s_server", "dev"]
  region             = var.droplet.region
  size               = var.droplet.size
  monitoring         = true
  private_networking = true
  vpc_uuid           = digitalocean_vpc.k3s_vpc.id
  ssh_keys           = var.ssh_key_fingerprints
  user_data = templatefile("${path.module}/user_data/ks3_server.yaml", {
    k3s_channel         = var.k3s_channel
    k3s_token           = random_string.k3s_token.result
    do_token            = var.do_token
    k3s_lb_ip           = digitalocean_loadbalancer.k3s_lb.ip
    ccm_manifest        = file("${path.module}/manifests/do-ccm.yaml")
    csi_crds_manifest   = file("${path.module}/manifests/do-csi/crds.yaml")
    csi_driver_manifest = file("${path.module}/manifests/do-csi/driver.yaml")
    csi_sc_manifest     = file("${path.module}/manifests/do-csi/snapshot-controller.yaml")
  })
}

resource "digitalocean_droplet" "k3s_agent" {
  image              = var.droplet.image
  name               = "k3s-agent-01"
  tags               = ["k3s_agent", "dev"]
  region             = var.droplet.region
  size               = var.droplet.size
  monitoring         = true
  private_networking = true
  vpc_uuid           = digitalocean_vpc.k3s_vpc.id
  ssh_keys           = var.ssh_key_fingerprints
  user_data = templatefile("${path.module}/user_data/k3s_agent.yaml", {
    k3s_channel = var.k3s_channel
    k3s_token   = random_string.k3s_token.result
    k3s_lb_ip   = digitalocean_loadbalancer.k3s_lb.ip
    #k3s_server_private_ip = digitalocean_droplet.k3s_server.ipv4_address_private
  })
}

resource "digitalocean_project_resources" "k3s_cluster" {
  project = digitalocean_project.k3s_cluster.id
  resources = [
    digitalocean_droplet.k3s_server.urn,
    digitalocean_droplet.k3s_agent.urn,
    digitalocean_loadbalancer.k3s_lb.urn
  ]
}