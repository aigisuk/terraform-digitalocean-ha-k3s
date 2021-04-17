resource "digitalocean_droplet" "k3s_server" {
  count = var.server_count - 1
  name  = "k3s-${var.region}-server-${count.index + 2}"

  image              = var.server_droplet.image
  tags               = ["k3s_server"]
  region             = var.region
  size               = var.server_droplet.size
  monitoring         = true
  private_networking = true
  vpc_uuid           = digitalocean_vpc.k3s_vpc.id
  ssh_keys           = var.ssh_key_fingerprints
  user_data = templatefile("${path.module}/user_data/ks3_server.yaml", {
    k3s_channel     = var.k3s_channel
    k3s_token       = random_string.k3s_token.result
    flannel_backend = var.flannel_backend
    k3s_lb_ip       = digitalocean_loadbalancer.k3s_lb.ip
    db_host         = digitalocean_database_cluster.postgres.host
    db_port         = digitalocean_database_cluster.postgres.port
    db_user         = var.database_user
    db_pass         = digitalocean_database_user.dbuser.password
    db_name         = digitalocean_database_cluster.postgres.database
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