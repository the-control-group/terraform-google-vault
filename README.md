# Vault on GCP Terraform Module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client_tag | Tag that identifies clients of the cluster. | string | `vault-client` | no |
| cluster_name | Name of the cluster to be deployed. | string | - | yes |
| cluster_size | Size of the cluster to deploy. | string | `3` | no |
| cluster_tag | Tag that will be applied to the cluster instances. | string | - | yes |
| machine_type | The machine type to deploy the instances as. | string | `g1-small` | no |
| network | Network the instances will be attached to. | string | - | yes |
| prometheus_server_tag | Tag identifying the Prometheus server. | string | - | yes |
| scopes | Permissions that the instances will have to different GCP services. | list | `<list>` | no |
| source_image | Image to use when deploying. | string | - | yes |
| subnet | The subnet the instances will be attached to. | string | - | yes |
