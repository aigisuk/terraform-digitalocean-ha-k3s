resource "digitalocean_database_user" "dbuser" {
  cluster_id = digitalocean_database_cluster.k3s.id
  name       = var.database_user
}

resource "digitalocean_database_cluster" "k3s" {
  name                 = "k3s-ext-datastore"
  engine               = var.database_engine == "postgres" ? "pg" : "mysql"
  version              = var.database_engine == "postgres" ? "11" : "8"
  size                 = var.database_size
  region               = var.region
  private_network_uuid = digitalocean_vpc.k3s_vpc.id
  node_count           = var.database_node_count
}

resource "digitalocean_project_resources" "k3s_ext_datastore" {
  project = digitalocean_project.k3s_cluster.id
  resources = [
    digitalocean_database_cluster.k3s.urn
  ]
}