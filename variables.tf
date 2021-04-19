variable "do_token" {}

variable "ssh_key_fingerprints" {
  type        = list(string)
  description = "List of SSH Key fingerprints"
}

variable "region" {
  type        = string
  description = "Cluster region"
  default     = "fra1"
}

variable "k3s_channel" {
  type        = string
  description = "K3s release channel. stable, latest, testing or a specific channel e.g. v1.20"
  default     = "stable"
}

variable "database_user" {
  type        = string
  description = "Database User"
  default     = "k3s_default_user"
}

variable "database_version" {
  type        = string
  description = "Database engine version used by the cluster (ex. 13 for PostgreSQL 13)"
  default     = "13"
}

variable "database_size" {
  type        = string
  description = "Database Droplet size associated with the cluster (ex. db-s-1vcpu-1gb)"
  default     = "db-s-1vcpu-1gb"
}

variable "database_node_count" {
  type        = number
  description = "Number of nodes that comprise the database cluster"
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

variable "server_size" {
  type        = string
  description = "Server droplet size"
  default     = "s-1vcpu-2gb" # prod = s-1vcpu-2gb
}
variable "agent_size" {
  type        = string
  description = "Agent droplet size"
  default     = "s-1vcpu-2gb" # prod = s-2vcpu-4gb
}

variable "server_count" {
  type        = number
  description = "Number of server nodes to be provisioned"
  default     = 2
}
variable "agent_count" {
  type        = number
  description = "Number of agent nodes to be provisioned"
  default     = 2
}

variable "server_taint_criticalonly" {
  type        = bool
  description = "Allow only critical addons to be scheduled on servers? (thus preventing workloads from being launched on them)"
  default     = true
}