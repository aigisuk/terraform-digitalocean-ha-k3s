variable "do_token" {}

variable "region" {
  type        = string
  description = "Cluster region"
  default     = "fra1"
}

variable "k3s_channel" {
  default = "stable"
}

variable "database_user" {
  type        = string
  description = "DB User"
  default     = "k3s_db_user"
}

variable "database_version" {
  type        = string
  description = "Engine version used by the cluster (ex. 13 for PostgreSQL 13)"
  default     = "13"
}

variable "database_size" {
  type        = string
  description = "Database Droplet size associated with the cluster (ex. db-s-1vcpu-1gb)"
  default     = "db-s-1vcpu-1gb"
}

variable "database_node_count" {
  type        = number
  description = "Number of nodes that will be included in the cluster"
  default     = 1
}

variable "flannel_backend" {
  type        = string
  description = "Flannel Backend Type"
  default     = "ipsec"
  validation {
    condition     = length(regexall("^ipsec|vxlan|host-gw|wireguard$", var.flannel_backend)) > 0
    error_message = "Invalid Flannel backend value. Valid backend types are vxlan, host-gw, ipsec & wireguard."
  }
}

variable "ssh_key_fingerprints" {
  type        = list(string)
  description = "List of SSH Keys"
}

variable "server_droplet" {
  type        = map(any)
  description = "Server Droplet configuration map"
  default = {
    image = "ubuntu-20-04-x64"
    size  = "s-1vcpu-2gb" # prod = s-1vcpu-2gb
  }
}

variable "agent_droplet" {
  type        = map(any)
  description = "Agent Droplet configuration map"
  default = {
    image = "ubuntu-20-04-x64"
    size  = "s-1vcpu-2gb" # prod = s-2vcpu-4gb
  }
}

variable "server_count" {
  type        = number
  description = "Number of server nodes to be deployed"
  default     = 2
}
variable "agent_count" {
  type        = number
  description = "Number of agent nodes to be deployed"
  default     = 2
}