variable "do_token" {}

variable "k3s_channel" {
  default = "stable"
}

variable "ssh_key_fingerprints" {
  type        = list(string)
  description = "List of SSH Keys"
}

variable "droplet" {
  type        = map(any)
  description = "Droplet configuration map"
  default = {
    image  = "ubuntu-20-04-x64"
    region = "fra1"
    size   = "s-1vcpu-2gb" # prod = s-2vcpu-4gb
  }
}