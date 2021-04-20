resource "digitalocean_droplet" "k3s_server_init" {
  count = 1
  name  = "k3s-server-${var.region}-${random_id.server_node_id[count.index].hex}-1"

  image              = "ubuntu-20-04-x64"
  tags               = ["k3s_server"]
  region             = var.region
  size               = var.server_size
  monitoring         = true
  private_networking = true
  vpc_uuid           = digitalocean_vpc.k3s_vpc.id
  ssh_keys           = var.ssh_key_fingerprints
  user_data = templatefile("${path.module}/user_data/ks3_server_init.yaml", {
    k3s_channel         = var.k3s_channel
    k3s_token           = random_password.k3s_token.result
    do_token            = var.do_token
    do_cluster_vpc_id   = digitalocean_vpc.k3s_vpc.id
    flannel_backend     = var.flannel_backend
    k3s_lb_ip           = digitalocean_loadbalancer.k3s_lb.ip
    db_cluster_uri      = local.db_cluster_uri
    critical_taint      = local.taint_critical
    ccm_manifest        = file("${path.module}/manifests/do-ccm.yaml")
    csi_crds_manifest   = file("${path.module}/manifests/do-csi/crds.yaml")
    csi_driver_manifest = file("${path.module}/manifests/do-csi/driver.yaml")
    csi_sc_manifest     = file("${path.module}/manifests/do-csi/snapshot-controller.yaml")
  })
}

resource "digitalocean_project_resources" "k3s_init_server_node" {
  count   = 1
  project = digitalocean_project.k3s_cluster.id
  resources = [
    digitalocean_droplet.k3s_server_init[count.index].urn,
  ]
}