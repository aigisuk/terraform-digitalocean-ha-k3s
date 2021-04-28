# Default Deployment Example

This example illustrates how to use the `terraform-digitalocean-ha-k3s` module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| do_token | DigitalOcean Personal Access Token | string | N/A | yes |
| ssh_key_fingerprints | List of SSH Key fingerprints | list(string) | N/A | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster_summary | A summary of the cluster's provisioned resources. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, replace the values in the `terraform.tfvars` file with your own and run the following commands from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
