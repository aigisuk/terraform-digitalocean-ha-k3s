# Server tag
resource "digitalocean_tag" "server" {
  name = var.server_tag
}

# Agent tag
resource "digitalocean_tag" "agent" {
  name = var.agent_tag
}