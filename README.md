# Terraform DigitalOcean HA K3S Module
An opinionated Terraform module to provision a high availability [K3s](https://k3s.io/) cluster with external database on the DigitalOcean cloud platform. Perfect for development or testing.

![Terraform, DigitalOcean, K3s illustration](https://res.cloudinary.com/qunux/image/upload/v1618967113/terraform-digitalocean-k3s-repo-logo_f2zyoz.svg)

## Features
* [x] High Availability K3s Cluster provisioned on the DigitalOcean platform
* [x] Managed **PostgreSQL**/**MySQL** database provisioned. Serves as the datastore for the cluster's state (configurable options: size & node count)
* [x] The number of provisioned Servers (Masters) and Agents (Workers) is configurable
* [x] Cluster API/Servers are behind a provisioned load balancer for high availability
* [x] Flannel backend is configurable. Choose from `vxlan`, `host-gw`, `ipsec` (default) or `wireguard`
* [x] DigitalOcean's CCM ([Cloud Controller Manager](https://github.com/digitalocean/digitalocean-cloud-controller-manager)) and CSI ([Container Storage Interface](https://github.com/digitalocean/csi-digitalocean)) plugins are pre-installed. Enables the cluster to leverage DigitalOcean's load balancer and volume resources
* [x] Option to make Servers (Masters) schedulable. Default is `false` i.e. `CriticalAddonsOnly=true:NoExecute`
* [x] Cluster database engine is configurable. Choose from **PostgreSQL** (v11) or **MySQL** (v8)
* [x] Pre-install the Kubernetes Dashboard (optional)
* [x] Pre-install Jetstack's [cert-manager](https://github.com/jetstack/cert-manager) (optional)
* [ ] Pre-install an ingress controller from **Kong**, **Nginx** or **Traefik v2** (optional)
* [ ] Generate custom `kubeconfig` file (optional)

## Compatibility/Requirements

* Requires [Terraform](https://www.terraform.io/downloads.html) 0.13 or higher.
* A DigitalOcean account and [personal access token](https://docs.digitalocean.com/reference/api/create-personal-access-token/) for accessing the DigitalOcean API - [Use this referral link for $100 free credit](https://m.do.co/c/6b3bf6d79f7d)

## Tutorial

TBC

## Architecture

A default deployment of this module provisions an architecture similar to that illustrated below (minus the external traffic Load Balancer). **2x** Servers, **1x** Agent and a load balancer in front of the servers providing a fixed registration address for the Kubernetes API. Additional Servers or Agents can be provisioned via the `server_count` and `agent_count` variables respectively.

![](https://res.cloudinary.com/qunux/image/upload/v1618680903/k3s-architecture-ha-server_border_rjwhll.png)

###### *K3s Architecture with a High-availability Servers - [Source](https://rancher.com/docs/k3s/latest/en/architecture/#high-availability-k3s-server-with-an-external-db)*

## Usage
Basic usage of this module is as follows:
```
module "do-ha-k3s" {
  source = "github.com/aigisuk/terraform-digitalocean-ha-k3s"

  do_token                  = "7f5ef8eb151e3c81cd893c6...."
  ssh_key_fingerprints      = ["00:11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff"]
}
```

Functional examples are included in the
[examples](./examples/) directory.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| do_token | DigitalOcean Personal Access Token | string | N/A | yes |
| ssh_key_fingerprints | List of SSH Key fingerprints | list(string) | N/A | yes |
| region | Region in which to deploy cluster | string | `fra1` | no |
| k3s_channel | K3s release channel. `stable`, `latest`, `testing` or a specific channel or version e.g. `v1.20`, `v1.19.8+k3s1` | string | `"stable"` | no |
| database_user | Database username | string | `"k3s_default_user"` | no |
| database_engine | Database engine. PostgreSQL (13) or MySQL (8) | string | `"postgres"` | no |
| database_size | Database Droplet size associated with the cluster e.g. `db-s-1vcpu-1gb` | string |`"db-s-1vcpu-1gb"` | no |
| database_node_count | Number of nodes that comprise the database cluster | number | `1`| no |
| flannel_backend | Flannel Backend Type. Valid options include `vxlan`, `host-gw`, `ipsec` (default) or `wireguard` | string | `ipsec`| no |
| server_size | Server droplet size. e.g. `s-1vcpu-2gb` | string | `s-1vcpu-2gb`| no |
| agent_size | Agent droplet size. e.g. `s-1vcpu-2gb` | string | `s-1vcpu-2gb`| no |
| server_count | Number of server (master) nodes to provision | number | `2`| no |
| agent_count | Number of agent (worker) nodes to provision | number | `1`| no |
| server_taint_criticalonly | Allow only critical addons to be scheduled on servers? (thus preventing workloads from being launched on them) | bool | `true`| no |
| k8s_dashboard | Pre-Install [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) | bool| `false`| no |
| cert_manager | Pre-Install [cert-manager](https://cert-manager.io/) | bool| `false`| no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_summary | A summary of the cluster's provisioned resources. |

## Pre-Install the Kubernetes Dashboard

The [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) can pre pre-installed by setting input variable `k8s_dashboard` to `true`.

A Service Account with the name `admin-user` is auto created and granted admin privileges. Use the following `kubectl` command to obtain the Bearer Token for the `admin-user`:

```
kubectl -n kubernetes-dashboard describe secret admin-user-token | awk '$1=="token:"{print $2}'
```
Output:
```
eyJhbGciOiJSUzI1NiI....JmL-nP-x1SPjOCNfZkg
```

Use `kubectl port-forward` to access the dashboard:

```
kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8080:443
```

To access the Kubernetes Dashboard go to:
```
https://localhost:8080
```
Select the `Token` option, enter the `admin-user` Bearer Token obtained earlier and click `Sign in`:

![Kubernetes-Dashboard-Login](https://user-images.githubusercontent.com/12916656/117087905-c3d99800-ad48-11eb-9245-6a73578c5e3a.png)

## Cost

A default deployment of this module provisions the following resources:

| Quantity | Resource | Description | Price/mo ($USD)* | Total/mo ($USD) | Total/hr ($USD) |
|------|-------------|:----:|:-----:|:-----:|:-----:|
| **2x** | Server (Master) Node | 1 VPCU, 2GB RAM, 2TB Transfer | 10 | **20** | **0.030** |
| **1x** | Agent (Worker) Node | 1 VPCU, 2GB RAM, 2TB Transfer | 10 | **10** | **0.015** |
| **1x** | Load Balancer | Small  | 10 | **10** | **0.01488** |
| **1x** | Postgres DB Cluster | Single Basic Node | 15 | **15** | **0.022** |
|  |  |  | **Total** | **55** | ≈ **0.082** |
##### * Prices correct at time of latest commit (check [digitalocean.com/pricing](https://www.digitalocean.com/pricing/) for current pricing)
##### **N.B.** Keep in mind, additional costs may be incurred through the provisioning of volumes and/or load balancers required by any applications deployed on the cluster.

## Credits

* [Set up Your K3s Cluster for High Availability on DigitalOcean](https://rancher.com/blog/2020/k3s-high-availability) - Blog post by [Alex Ellis](https://github.com/alexellis) on rancher.com