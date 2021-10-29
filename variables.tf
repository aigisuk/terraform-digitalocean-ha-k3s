variable "do_token" {
  type        = string
  description = "DigitalOcean Personal Access Token"
}

variable "ssh_key_fingerprints" {
  type        = list(string)
  description = "List of SSH Key fingerprints"
}

variable "region" {
  type        = string
  description = "Region in which to deploy the cluster. Default is fra1 (Frankfurt, Germany)"
  default     = "fra1"
  validation {
    condition     = length(regexall("^nyc1|sfo1|nyc2|ams2|sgp1|lon1|nyc3|ams3|fra1|tor1|sfo2|blr1|sfo3$", var.region)) > 0
    error_message = "Invalid region. Valid regions are nyc1, sfo1, nyc2, ams2, sgp1, lon1, nyc3, ams3, fra1, tor1, sfo2, blr1 or sfo3."
  }
}

variable "vpc_network_range" {
  type        = string
  description = "Range of IP addresses for the VPC in CIDR notation. Cannot be larger than /16 or smaller than /24. Default is 10.10.10.0/24"
  default     = "10.10.10.0/24"
}

variable "k3s_channel" {
  type        = string
  description = "K3s release channel. 'stable', 'latest', 'testing' or a specific channel or version e.g. 'v1.20', 'v1.21.0+k3s1'"
  default     = "stable"
}

variable "database_user" {
  type        = string
  description = "Database Username"
  default     = "k3s_default_user"
}

variable "database_engine" {
  type        = string
  description = "Database engine. PostgreSQL (13) or MySQL (8)"
  default     = "postgres"
  validation {
    condition     = length(regexall("^postgres|mysql$", var.database_engine)) > 0
    error_message = "Invalid database engine. Valid types are postgres or mysql."
  }
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
  description = "Flannel Backend Type. Valid options include vxlan (default), ipsec or wireguard"
  default     = "vxlan"
  validation {
    condition     = length(regexall("^ipsec|vxlan|wireguard$", var.flannel_backend)) > 0
    error_message = "Invalid Flannel backend value. Valid backend types are vxlan, ipsec & wireguard."
  }
}

variable "server_size" {
  type        = string
  description = "Server droplet size. e.g. s-1vcpu-2gb"
  default     = "s-1vcpu-2gb" # prod = s-1vcpu-2gb
}
variable "agent_size" {
  type        = string
  description = "Agent droplet size. e.g. s-1vcpu-2gb"
  default     = "s-1vcpu-2gb" # prod = s-2vcpu-4gb
}

variable "server_count" {
  type        = number
  description = "Number of server (master) nodes to provision"
  default     = 2
}
variable "agent_count" {
  type        = number
  description = "Number of agent (worker) nodes to provision"
  default     = 1
}

variable "server_taint_criticalonly" {
  type        = bool
  description = "Allow only critical addons to be scheduled on servers? (thus preventing workloads from being launched on them)"
  default     = true
}

variable "k8s_dashboard" {
  type        = bool
  description = "Pre-install the Kubernetes Dashboard? (Default is false)"
  default     = false
}

variable "k8s_dashboard_version" {
  type        = string
  description = "Kubernetes Dashboard version"
  default     = "2.4.0" # https://github.com/kubernetes/dashboard/releases
}

variable "cert_manager" {
  type        = bool
  description = "Pre-install cert-manager? (Default is false)"
  default     = false
}

variable "cert_manager_version" {
  type        = string
  description = "cert-manager version"
  default     = "1.6.0" # https://github.com/jetstack/cert-manager/releases

}

variable "sys_upgrade_ctrl" {
  type        = bool
  description = "Pre-install the System Upgrade Controller?"
  default     = false
}

variable "ingress" {
  type        = string
  description = "Ingress controller to install"
  default     = "none"
  validation {
    condition     = length(regexall("^kong|kong_pg|nginx|traefik|none$", var.ingress)) > 0
    error_message = "Invalid ingress type. Valid ingress types are kong, kong_pg, traefik or nginx."
  }
}