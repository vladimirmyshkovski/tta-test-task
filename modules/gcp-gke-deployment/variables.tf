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

variable "name" {
  description = "The name of the deployment"
  type        = string
}

variable "namespace" {
  description = "The namespace"
  type        = string
  default     = "default"
}

variable "replicas" {
  description = "The number of replicas"
  type        = number
  default     = 1
}

variable "port" {
  description = "The port to expose the application on"
  type        = number
}

######################
# Database variables #
######################

variable "enable_postgresql" {
  description = "Enables PostgreSQL support via a Cloud Proxy Sidecar"
  type        = bool
  default     = false
}

variable "postgresql_connection_name" {
  description = "The Cloud SQL connection name for a PostgreSQL database"
  type        = string
  default     = null
}

variable "postgresql_connection_port" {
  description = "The Cloud SQL connection port for a PostgreSQL database"
  type        = number
  default     = 5432
}

variable "postgresql_database_user" {
  description = "The user for a PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "postgresql_database_password" {
  description = "The password for a PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "restart_policy" {
 type         = string
 default      = "Always"
}

variable "image_pull_policy" {
  type        = string
  default     = "Always"
}

variable "resources_limits_cpu" {
  type        = string
  default     = "400m"
}

variable "resources_limits_memory" {
  type        = string
  default     = "512Mi"
}

variable "resources_requests_cpu" {
  type        = string
  default     = "200m"
}

variable "resources_requests_memory" {
  type        = string
  default     = "256Mi"
}

variable "min_replicas" {
  type        = number
  default     = 1
}

variable "max_replicas" {
  type        = number
  default     = 1
}

variable "health_check_path" {
  description = ""
  type        = string
  default     = "/health"
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

variable "target_cpu_utilization_percentage" {
  type    = number
  default = 75
}

variable "liveness_probe_http_get_path" {
  type    = string
  default = "/health"
}

variable "liveness_probe_initial_delay_seconds" {
  type    = number
  default = 60
}

variable "liveness_probe_period_seconds" {
  type    = number
  default = 60
}

variable "liveness_probe_failure_threshold" {
  type    = number
  default = 1
}

variable "liveness_probe_success_threshold" {
  type    = number
  default = 1
}

variable "liveness_probe_timeout_seconds" {
  type    = number
  default = 60
}

variable "liveness_probe_enabled" {
  type = bool
  default = false
}

variable "readiness_probe_http_get_path" {
  type    = string
  default = "/health"
}

variable "readiness_probe_initial_delay_seconds" {
  type    = number
  default = 60
}

variable "readiness_probe_period_seconds" {
  type    = number
  default = 60
}

variable "readiness_probe_failure_threshold" {
  type    = number
  default = 1
}

variable "readiness_probe_success_threshold" {
  type    = number
  default = 1
}

variable "readiness_probe_timeout_seconds" {
  type    = number
  default = 60
}

variable "readiness_probe_enabled" {
  type = bool
  default = false
}

variable "startup_probe_http_get_path" {
  type    = string
  default = "/health"
}

variable "startup_probe_initial_delay_seconds" {
  type    = number
  default = 60
}

variable "startup_probe_period_seconds" {
  type    = number
  default = 60
}

variable "startup_probe_failure_threshold" {
  type    = number
  default = 1
}

variable "startup_probe_success_threshold" {
  type    = number
  default = 1
}

variable "startup_probe_timeout_seconds" {
  type    = number
  default = 60
}

variable "startup_probe_enabled" {
  type = bool
  default = false
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "image_path" {
  type = string
  default = "us-central1-docker.pkg.dev/toptierauthentics/cloud-run-source-deploy"
}
