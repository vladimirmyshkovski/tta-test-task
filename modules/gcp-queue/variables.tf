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

variable "replicas" {
  type        = number
  default     = 1
}

variable "min_replicas" {
  type        = number
  default     = 1
}

variable "max_replicas" {
  type        = number
  default     = 1
}


variable "service_account_name" {
  description = "Name of the accont service"
  type        = string
}

variable "env_name" {
  description = "Name of the configmap created from .env file"
  default     = "env"
  type        = string
}
