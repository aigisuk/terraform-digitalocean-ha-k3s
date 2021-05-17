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
    # Allow ICMP communication on all ports to defined 'tags' via VPC Network
    protocol         = "icmp"
    source_addresses = [var.vpc_network_range]
  }

  inbound_rule {
    # Allow TCP communication on all ports to defined 'tags' via VPC Network
    protocol         = "tcp"
    port_range       = "1-65535"
    source_addresses = [var.vpc_network_range]
  }

  inbound_rule {
    # Allow UDP communication on all ports to defined 'tags' via VPC Network
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

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
