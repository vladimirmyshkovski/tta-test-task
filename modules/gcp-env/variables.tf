variable "cluster_endpoint" {
  description = "The Kubernetes cluster endpoint"
  type        = string
}

variable "cluster_name" {
  description = "The Kubernetes cluster name"
  type        = string
}

variable "access_token" {
  description = "The access token to authenticate with the Kubernetes cluster"
  type        = string
}

variable "ca_certificate" {
  description = "The cluster's certificate for authentication"
  type        = string
}

variable "domains" {
  type = list
  default = ["dev2.toptierauthentics.com"]
}

variable "gcp_service_account" {
  type    = string
  default = "terraform@toptierauthentics.iam.gserviceaccount.com"
}

variable "env" {
  type    = string
  default = "development"
}

variable "service_subdomain" {
  type    = string
  default = "dev"
}
