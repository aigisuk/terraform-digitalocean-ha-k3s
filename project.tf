resource "digitalocean_project" "k3s_cluster" {
  name        = "k3s-cluster"
  description = "k3s Cluster"
  purpose     = "HA K3s (Kubernetes) Cluster"
  environment = "Development"
}