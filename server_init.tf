resource "digitalocean_droplet" "k3s_server_init" {
  name = "k3s-server-${var.region}-1"

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
    db_host             = digitalocean_database_cluster.postgres.host
    db_port             = digitalocean_database_cluster.postgres.port
    db_user             = var.database_user
    db_pass             = digitalocean_database_user.dbuser.password
    db_name             = digitalocean_database_cluster.postgres.database
    critical_taint      = var.server_taint_criticalonly == true ? "--node-taint \"CriticalAddonsOnly=true:NoExecute\" \\" : ""
    ccm_manifest        = file("${path.module}/manifests/do-ccm.yaml")
    csi_crds_manifest   = file("${path.module}/manifests/do-csi/crds.yaml")
    csi_driver_manifest = file("${path.module}/manifests/do-csi/driver.yaml")
    csi_sc_manifest     = file("${path.module}/manifests/do-csi/snapshot-controller.yaml")
  })
}

resource "digitalocean_project_resources" "k3s_init_server_node" {
  project = digitalocean_project.k3s_cluster.id
  resources = [
    digitalocean_droplet.k3s_server_init.urn,
  ]
}