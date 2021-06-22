locals {
  db_host = digitalocean_database_cluster.k3s.private_host
  db_port = digitalocean_database_cluster.k3s.port
  db_user = var.database_user
  db_pass = digitalocean_database_user.dbuser.password
  db_name = digitalocean_database_cluster.k3s.database

  postgres_uri = "postgres://${local.db_user}:${local.db_pass}@${local.db_host}:${local.db_port}/${local.db_name}"
  mysql_uri    = "mysql://${local.db_user}:${local.db_pass}@tcp(${local.db_host}:${local.db_port})/${local.db_name}"

  db_cluster_uri = var.database_engine == "postgres" ? local.postgres_uri : local.mysql_uri

  server_droplet_tag = "k3s_server"
  agent_droplet_tag  = "k3s_agent"
  ccm_fw_tags        = var.server_taint_criticalonly == false ? join(",", [local.server_droplet_tag, local.agent_droplet_tag]) : local.agent_droplet_tag

  critical_addons_only_true = "--node-taint \"CriticalAddonsOnly=true:NoExecute\" \\"

  taint_critical = var.server_taint_criticalonly == true ? local.critical_addons_only_true : "\\"

  install_cert_manager = "wget --quiet -P /var/lib/rancher/k3s/server/manifests/ https://github.com/jetstack/cert-manager/releases/download/v${var.cert_manager_version}/cert-manager.yaml"

  servers_init = [
    for key, server in digitalocean_droplet.k3s_server_init :
    {
      name       = server.name
      ip_public  = server.ipv4_address
      ip_private = server.ipv4_address_private
      price      = server.price_monthly
      id         = server.id
    }
  ]

  servers = [
    for key, server in digitalocean_droplet.k3s_server :
    {
      name       = server.name
      ip_public  = server.ipv4_address
      ip_private = server.ipv4_address_private
      price      = server.price_monthly
      id         = server.id
    }
  ]

  merged_servers = concat(
    local.servers_init,
    local.servers,
  )
}