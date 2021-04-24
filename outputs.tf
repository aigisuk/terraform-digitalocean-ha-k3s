output "cluster_summary" {
  description = "Cluster Summary."
  value = {
    #cluster_version : local.k3s_version
    cluster_region : var.region
    api_server_ip : digitalocean_loadbalancer.k3s_lb.ip
    servers : local.merged_servers
    agents : [
      for key, agent in digitalocean_droplet.k3s_agent :
      {
        name       = agent.name
        ip_public  = agent.ipv4_address
        ip_private = agent.ipv4_address_private
        price      = agent.price_monthly
        id         = agent.id
      }
    ]
  }
}