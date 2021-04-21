output "api_load_balancer_ip" {
  description = "IP address of the API server load balancer"
  value       = digitalocean_loadbalancer.k3s_lb.ip
}

output "name" {
  description = "Droplet Name"
  value       = digitalocean_droplet.k3s_server.*.name
}

output "region" {
  description = "Droplet Region"
  value       = digitalocean_droplet.k3s_server.*.region
}

output "id" {
  description = "Droplet ID"
  value       = digitalocean_droplet.k3s_server.*.id
}

output "ipv4_address" {
  description = "Droplet Public IPv4 address"
  value       = digitalocean_droplet.k3s_server.*.ipv4_address
}

output "ipv4_address_private" {
  description = "Droplet Private IPv4 address"
  value       = digitalocean_droplet.k3s_server.*.ipv4_address_private
}

# Output should be the Total cost of the droplets provisioned
output "price_monthly" {
  description = "Droplet Monthly Price"
  value       = digitalocean_droplet.k3s_server.*.price_monthly
}