resource "digitalocean_database_firewall" "k3s" {

  cluster_id = digitalocean_database_cluster.k3s.id

  rule {
    type  = "tag"
    value = local.server_droplet_tag
  }
}
