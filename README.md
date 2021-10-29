# Terraform DigitalOcean HA K3S Module
An opinionated Terraform module to provision a high availability [K3s](https://k3s.io/) cluster with external database on the DigitalOcean cloud platform. Perfect for development or testing.

![2021-10-24 05_45_35-k3s-cluster_project_DigitalOcean](https://user-images.githubusercontent.com/12916656/138615757-c73b90bc-9fe7-4214-90c7-acfad2f49222.png)

<!-- ![k3s_on_digitalocean_term_demo](examples/ha-k3s-do-demo.svg) -->

## Features
* [x] High Availability K3s Cluster provisioned on the DigitalOcean platform
* [x] Managed **PostgreSQL**/**MySQL** database provisioned. Serves as the datastore for the cluster's state (configurable options: size & node count)
* [x] Dedicated VPC provisioned for cluster use (IP Range: `10.10.10.0/24`)
* [x] Number of provisioned Servers (Masters) and Agents (Workers) is configurable
* [x] Cluster API/Server(s) are behind a provisioned load balancer for high availability
* [x] All resources assigned to a dedicated DigitalOcean project (expect Load Balancers provisioned by app deployments)
* [x] Flannel backend is configurable. Choose from `vxlan` (default), `ipsec` or `wireguard`
* [x] DigitalOcean's CCM ([Cloud Controller Manager](https://github.com/digitalocean/digitalocean-cloud-controller-manager)) and CSI ([Container Storage Interface](https://github.com/digitalocean/csi-digitalocean)) plugins are pre-installed. Enables the cluster to leverage DigitalOcean's load balancer and volume resources
* [x] Option to make Servers (Masters) schedulable. Default is `false` i.e. `CriticalAddonsOnly=true:NoExecute`
* [x] Cluster database engine is configurable. Choose between **PostgreSQL** (v11, default) or **MySQL** (v8)
* [x] Deploy [System Upgrade Controller](https://github.com/rancher/system-upgrade-controller) to manage [automated upgrades](https://rancher.com/docs/k3s/latest/en/upgrades/automated/) of the cluster [default: `false`]
* [x] Deploy the [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) [default: `false`]
* [x] Deploy Jetstack's [cert-manager](https://github.com/jetstack/cert-manager) [default: `false`]
* [x] Firewalled Nodes & Database
* [x] Deploy an ingress controller from **Kong** (Postgres or [DB-less mode](https://docs.konghq.com/gateway-oss/2.6.x/db-less-and-declarative-config/)), **Nginx** or **Traefik v2** [default: `none`]
* [ ] Generate custom `kubeconfig` file (optional)

## Compatibility/Requirements

* Requires [Terraform](https://www.terraform.io/downloads.html) 0.15 or higher.
* A DigitalOcean account and [personal access token](https://docs.digitalocean.com/reference/api/create-personal-access-token/) for accessing the DigitalOcean API - [Use this referral link for $100 free credit](https://m.do.co/c/6b3bf6d79f7d)

## Tutorial

[Deploy a HA K3s Cluster on DigitalOcean in 10 minutes using Terraform](https://colinwilson.uk/2021/04/04/deploy-a-ha-k3s-cluster-on-digitalocean-in-10-minutes-using-terraform/)

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
Example output:
```
cluster_summary = {
  "agents" = [
    {
      "id" = "246685594"
      "ip_private" = "10.10.10.4"
      "ip_public" = "203.0.113.10"
      "name" = "k3s-agent-fra1-1a9f-1"
      "price" = 10
    },
  ]
  "api_server_ip" = "198.51.100.10"
  "cluster_region" = "fra1"
  "servers" = [
    {
      "id" = "246685751"
      "ip_private" = "10.10.10.5"
      "ip_public" = "203.0.113.11"
      "name" = "k3s-server-fra1-55b4-1"
      "price" = 10
    },
    {
      "id" = "246685808"
      "ip_private" = "10.10.10.6"
      "ip_public" = "203.0.113.12"
      "name" = "k3s-server-fra1-d6e7-2"
      "price" = 10
    },
  ]
}
```

To manage K3s from outside the cluster, SSH into any Server node and copy the contents of `/etc/rancher/k3s/k3s.yaml` to `~/.kube/config` on an external machine where you have installed `kubectl`.
```
sudo scp -i .ssh/your_private_key root@203.0.113.11:/etc/rancher/k3s/k3s.yaml ~/.kube/config
```

Then replace `127.0.0.1` with the API Load Balancer IP address of your K3s Cluster (value for the `api_server_ip` key from the Terraform `cluster_summary` output).
```
sudo sed -i -e "s/127.0.0.1/198.51.100.10/g" ~/.kube/config
```

Functional examples are included in the
[examples](./examples/) directory.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| do_token | DigitalOcean Personal Access Token | string | N/A | yes |
| ssh_key_fingerprints | List of SSH Key fingerprints | list(string) | N/A | yes |
| region | Region in which to deploy cluster | string | `fra1` | no |
| vpc_network_range | Range of IP addresses for the VPC in CIDR notation | string | `10.10.10.0/24` | no |
| k3s_channel | K3s release channel. `stable`, `latest`, `testing` or a specific channel or version e.g. `v1.22`, `v1.19.8+k3s1` | string | `"stable"` | no |
| database_user | Database username | string | `"k3s_default_user"` | no |
| database_engine | Database engine. `postgres` (v13) or `mysql` (v8) | string | `"postgres"` | no |
| database_size | Database Droplet size associated with the cluster e.g. `db-s-1vcpu-1gb` | string |`"db-s-1vcpu-1gb"` | no |
| database_node_count | Number of nodes that comprise the database cluster | number | `1`| no |
| flannel_backend | Flannel Backend Type. Valid options include `vxlan`, `ipsec` or `wireguard` | string | `vxlan`| no |
| server_size | Server droplet size. e.g. `s-1vcpu-2gb` | string | `s-1vcpu-2gb`| no |
| agent_size | Agent droplet size. e.g. `s-1vcpu-2gb` | string | `s-1vcpu-2gb`| no |
| server_count | Number of server (master) nodes to provision | number | `2`| no |
| agent_count | Number of agent (worker) nodes to provision | number | `1`| no |
| server_taint_criticalonly | Allow only critical addons to be scheduled on server nodes? (thus preventing workloads from being launched on them) | bool | `true`| no |
| sys_upgrade_ctrl | Deploy the [System Upgrade Controller](https://github.com/rancher/system-upgrade-controller) | bool | `false`| no |
| ingress | Deploy an ingress controller. `none`, `traefik`, `kong`, `kong_pg` | string | `"none"`| no |
| k8s_dashboard | Deploy [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) | bool | `false`| no |
| k8s_dashboard_version | [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) version | string | `2.4.0`| no |
| cert_manager | Deploy [cert-manager](https://cert-manager.io/) | bool | `false`| no |
| cert_manager_version | [cert-manager](https://cert-manager.io/) version | string | `1.6.0`| no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_summary | A summary of the cluster's provisioned resources. |

## Deploy the Kubernetes Dashboard

The [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) can be deployed by setting the `k8s_dashboard` input variable to `true`.

This auto-creates a Service Account named `admin-user` with admin privileges granted. The following `kubectl` command outputs the Bearer Token for the `admin-user`:

```
kubectl -n kubernetes-dashboard describe secret admin-user-token | awk '$1=="token:"{print $2}'
```
Output:
```
eyJhbGciOiJSUzI1NiI....JmL-nP-x1SPjOCNfZkg
```

Use `kubectl port-forward` to forward a local port to the dashboard:

```
kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8080:443
```

To access the Kubernetes Dashboard go to:
```
https://localhost:8080
```
Select the `Token` option, enter the `admin-user` Bearer Token obtained earlier and click `Sign in`:

![Kubernetes-Dashboard-Login](https://user-images.githubusercontent.com/12916656/117087905-c3d99800-ad48-11eb-9245-6a73578c5e3a.png)

## Traefik Ingress

[Traefik Proxy](https://doc.traefik.io/traefik/) ingress can be deployed by setting the `ingress` input variable to `traefik`. The Traefik dashboard is enabled by default.

Use `kubectl port-forward` to forward a local port to the dashboard:

```
kubectl port-forward -n traefik $(kubectl get pods -n traefik --selector=app=traefik --output=name) 9000:9000
```

To access the Traefik Dashboard go:
```
http://localhost:9000/dashboard/
```
> Don't forget the trailing slash

## Cost

A default deployment of this module provisions the following resources:

| Quantity | Resource | Description | Price/mo ($USD)* | Total/mo ($USD) | Total/hr ($USD) |
|------|-------------|:----:|:-----:|:-----:|:-----:|
| **2x** | Server (Master) Node | 1 VPCU, 2GB RAM, 2TB Transfer | 10 | **20** | **0.030** |
| **1x** | Agent (Worker) Node | 1 VPCU, 2GB RAM, 2TB Transfer | 10 | **10** | **0.015** |
| **1x** | Load Balancer | Small  | 10 | **10** | **0.01488** |
| **1x** | Postgres DB Cluster | Single Basic Node | 15 | **15** | **0.022** |
|  |  |  | **Total** | **55** | ≈ **0.082** |
##### * Prices correct at time of latest commit. Check [digitalocean.com/pricing](https://www.digitalocean.com/pricing/) for current pricing.
##### **N.B.** Additional costs may be incurred through the provisioning of volumes and/or load balancers required by any applications deployed to the cluster.

## Credits

* [Set up Your K3s Cluster for High Availability on DigitalOcean](https://rancher.com/blog/2020/k3s-high-availability) - Blog post by [Alex Ellis](https://github.com/alexellis) on rancher.com