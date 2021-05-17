resource "digitalocean_firewall" "ccm_firewall" {
  name = "ccm-firewall"

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "k3s_firewall" {
  name = "k3s-firewall"

  tags = [local.server_droplet_tag, local.agent_droplet_tag]

  inbound_rule {
    protocol         = "icmp"
    source_addresses = [var.vpc_network_range]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    source_addresses = [var.vpc_network_range]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "1-65535"
    source_addresses = [var.vpc_network_range]
  }

  inbound_rule {
    # Allow SSH access from all hosts
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }


  # inbound_rule {
  #   protocol                  = "tcp"
  #   port_range                = "6443"
  #   source_tags               = [local.server_droplet_tag, local.agent_droplet_tag]
  #   source_load_balancer_uids = [digitalocean_loadbalancer.k3s_lb.id]
  # }

  # inbound_rule {
  #   protocol    = "tcp"
  #   port_range  = "10250"
  #   source_tags = [local.server_droplet_tag, local.agent_droplet_tag]
  # }

  # inbound_rule {
  #   protocol    = "udp"
  #   port_range  = "51820"
  #   source_tags = var.flannel_backend == "wireguard" ? [local.server_droplet_tag, local.agent_droplet_tag] : []
  # }

  # inbound_rule {
  #   protocol    = "udp"
  #   port_range  = "4500"
  #   source_tags = var.flannel_backend == "ipsec" ? [local.server_droplet_tag, local.agent_droplet_tag] : []
  # }

  # inbound_rule {
  #   protocol    = "udp"
  #   port_range  = "500"
  #   source_tags = var.flannel_backend == "ipsec" ? [local.server_droplet_tag, local.agent_droplet_tag] : []
  # }

  # inbound_rule {
  #   protocol    = "udp"
  #   port_range  = "8472"
  #   source_tags = var.flannel_backend == "vxlan" ? [local.server_droplet_tag, local.agent_droplet_tag] : []
  # }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # outbound_rule {
  #   protocol         = "udp"
  #   port_range       = "51820"
  #   destination_tags = var.flannel_backend == "wireguard" ? [local.server_droplet_tag, local.agent_droplet_tag] : []
  # }

  # outbound_rule {
  #   protocol         = "udp"
  #   port_range       = "4500"
  #   destination_tags = var.flannel_backend == "ipsec" ? [local.server_droplet_tag, local.agent_droplet_tag] : []
  # }

  # outbound_rule {
  #   protocol         = "udp"
  #   port_range       = "500"
  #   destination_tags = var.flannel_backend == "ipsec" ? [local.server_droplet_tag, local.agent_droplet_tag] : []
  # }

  # outbound_rule {
  #   protocol         = "udp"
  #   port_range       = "8472"
  #   destination_tags = var.flannel_backend == "vxlan" ? [local.server_droplet_tag, local.agent_droplet_tag] : []
  # }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
