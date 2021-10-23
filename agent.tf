resource "digitalocean_droplet" "k3s_agent" {
  count = var.agent_count
  name  = "k3s-agent-${var.region}-${random_id.agent_node_id[count.index].hex}-${count.index + 1}"

  image      = "ubuntu-20-04-x64"
  tags       = [local.agent_droplet_tag]
  region     = var.region
  size       = var.agent_size
  monitoring = true
  vpc_uuid   = digitalocean_vpc.k3s_vpc.id
  ssh_keys   = var.ssh_key_fingerprints
  user_data = templatefile("${path.module}/user_data/k3s_agent.sh", {
    k3s_channel = var.k3s_channel
    k3s_token   = random_password.k3s_token.result
    k3s_lb_ip   = digitalocean_loadbalancer.k3s_lb.ip
  })
}

resource "digitalocean_project_resources" "k3s_agent_nodes" {
  count   = var.agent_count
  project = digitalocean_project.k3s_cluster.id
  resources = [
    digitalocean_droplet.k3s_agent[count.index].urn,
  ]
}