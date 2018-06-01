/// Required
variable "cluster_name" {
  description = "Name of the cluster to be deployed."
  type        = "string"
}

variable "cluster_tag" {
  description = "Tag that will be applied to the cluster instances."
  type        = "string"
}

variable "prometheus_server_tag" {
  description = "Tag identifying the Prometheus server."
  type        = "string"
}

variable "region" {
  description = "Region to deploy the Vault cluster to."
  type        = "string"
}

variable "network" {
  description = "Network the instances will be attached to."
  type        = "string"
}

variable "subnet" {
  description = "The subnet the instances will be attached to."
  type        = "string"
}

variable "source_image" {
  description = "Image to use when deploying."
  type        = "string"
}

/// Optional
variable "client_tag" {
  description = "Tag that identifies clients of the cluster."
  type        = "string"
  default     = "vault-client"
}

variable "machine_type" {
  description = "The machine type to deploy the instances as."
  type        = "string"
  default     = "g1-small"
}

variable "cluster_size" {
  description = "Size of the cluster to deploy."
  default     = 3
}

variable "http_port" {
  description = "Port Vault will listen on for API requests."
  default     = "8200"
}

variable "cluster_port" {
  description = "Port Vault instances will communicate with each other over."
  default     = "8201"
}

variable "scopes" {
  description = "Permissions that the instances will have to different GCP services."
  type        = "list"
  default     = ["compute-ro", "logging-write", "storage-rw", "monitoring"]
}
