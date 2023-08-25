variable "cluster_endpoint" {
  description = "The Kubernetes endpoint"
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

variable "min_replicas" {
  type        = number
  default     = 1
}

variable "max_replicas" {
  type        = number
  default     = 1
}
