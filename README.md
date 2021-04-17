# Terraform DigitalOcean HA K3S Module
![Terraform, DigitalOcean, K3s illustration](https://res.cloudinary.com/qunux/image/upload/v1618680649/terraform-digitalocean-k3s-repo-logo_wb-01_ar5ds4.svg)
A Terraform module to provision a high availability [K3s](https://k3s.io/) cluster with external database on the DigitalOcean cloud platform.

![](https://res.cloudinary.com/qunux/image/upload/v1618680903/k3s-architecture-ha-server_border_rjwhll.png)

###### *K3s Architecture with a High-availability Servers - [Source](https://rancher.com/docs/k3s/latest/en/architecture/#high-availability-k3s-server-with-an-external-db)*

## Features
* [x] High Availability K3s Cluster provisioned on DigitalOcean platform
* [x] Managed Postgres database provisioned for use as the cluster external database (configurable version, size & node count)
* [x] The number of Servers (Masters) and Agents (Workers) deployed is configurable
* [x] Load Balanced Cluster API (HA)
* [x] Cluster Flannel backend is configurable. Choose from `vxlan`, `host-gw`, `ipsec` (default) or `wireguard`
* [x] DigitalOcean CCM ([Cloud Controller Manager](https://github.com/digitalocean/digitalocean-cloud-controller-manager)) and CSI ([Container Storage Interface](https://github.com/digitalocean/csi-digitalocean)) plugins are automatically installed. Allows the cluster to leverage load balancers and volumes on the DigitalOcean platform
* [ ] Choice of ingress controllers to install (optional) [Kong, Nginx, Traefik v2]

## Compatibility

This module requires [Terraform](https://www.terraform.io/downloads.html) 0.13 or higher.

## Tutorial

TBC