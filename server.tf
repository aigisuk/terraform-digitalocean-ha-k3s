resource "digitalocean_droplet" "k3s_server" {
  count = var.server_count - 1
  name  = "k3s-server-${var.region}-${random_id.server_node_id[count.index + 1].hex}-${count.index + 2}"

  image      = "ubuntu-20-04-x64"
  tags       = [local.server_droplet_tag]
  region     = var.region
  size       = var.server_size
  monitoring = true
  vpc_uuid   = digitalocean_vpc.k3s_vpc.id
  ssh_keys   = var.ssh_key_fingerprints
  user_data = templatefile("${path.module}/user_data/ks3_server.sh", {
    k3s_channel     = var.k3s_channel
    k3s_token       = random_password.k3s_token.result
    flannel_backend = var.flannel_backend
    k3s_lb_ip       = digitalocean_loadbalancer.k3s_lb.ip
    db_cluster_uri  = local.db_cluster_uri
    critical_taint  = local.taint_critical
  })
  depends_on = [
    digitalocean_droplet.k3s_server_init
  ]
}

resource "digitalocean_project_resources" "k3s_server_nodes" {
  count   = var.server_count - 1
  project = digitalocean_project.k3s_cluster.id
  resources = [
    digitalocean_droplet.k3s_server[count.index].urn,
  ]
}