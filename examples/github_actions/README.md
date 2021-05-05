# GitHub Actions Deployment Example

This example is specifically for module tests via GitHub Actions.

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
