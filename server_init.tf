resource "digitalocean_droplet" "k3s_server_init" {
  count = 1
  name  = "k3s-server-${var.region}-${random_id.server_node_id[count.index].hex}-1"

  image      = "ubuntu-20-04-x64"
  tags       = [local.server_droplet_tag]
  region     = var.region
  size       = var.server_size
  monitoring = true
  vpc_uuid   = digitalocean_vpc.k3s_vpc.id
  ssh_keys   = var.ssh_key_fingerprints
  user_data = templatefile("${path.module}/user_data/ks3_server_init.sh", {
    k3s_channel           = var.k3s_channel
    k3s_token             = random_password.k3s_token.result
    do_token              = var.do_token
    do_cluster_vpc_id     = digitalocean_vpc.k3s_vpc.id
    do_ccm_fw_name        = digitalocean_firewall.ccm_firewall.name
    do_ccm_fw_tags        = local.ccm_fw_tags
    flannel_backend       = var.flannel_backend
    k3s_lb_ip             = digitalocean_loadbalancer.k3s_lb.ip
    db_cluster_uri        = local.db_cluster_uri
    critical_taint        = local.taint_critical
    ccm_manifest          = base64gzip(file("${path.module}/manifests/do-ccm.yaml"))
    csi_crds_manifest     = base64gzip(file("${path.module}/manifests/do-csi/crds.yaml"))
    csi_driver_manifest   = base64gzip(file("${path.module}/manifests/do-csi/driver.yaml"))
    csi_sc_manifest       = base64gzip(file("${path.module}/manifests/do-csi/snapshot-controller.yaml"))
    traefik_ingress       = var.ingress == "traefik" ? base64gzip(file("${path.module}/manifests/traefik-custom.yaml")) : ""
    nginx_ingress         = var.ingress == "nginx" ? base64gzip(file("${path.module}/manifests/ingress-nginx.yaml")) : ""
    kong_ingress_postgres = var.ingress == "kong_pg" ? base64gzip(file("${path.module}/manifests/kong-all-in-one-postgres.yaml")) : ""
    kong_ingress_dbless   = var.ingress == "kong" ? base64gzip(file("${path.module}/manifests/kong-all-in-one-dbless.yaml")) : ""
    k8s_dashboard = var.k8s_dashboard == true ? base64gzip(templatefile("${path.module}/manifests/k8s-dashboard.yaml", {
      k8s_dash_ver = var.k8s_dashboard_version
    })) : ""
    cert_manager     = var.cert_manager == true ? local.install_cert_manager : ""
    sys_upgrade_ctrl = var.sys_upgrade_ctrl == true ? base64gzip(file("${path.module}/manifests/system-upgrade-controller.yaml")) : ""
  })
}

resource "digitalocean_project_resources" "k3s_init_server_node" {
  count   = 1
  project = digitalocean_project.k3s_cluster.id
  resources = [
    digitalocean_droplet.k3s_server_init[count.index].urn,
  ]
}