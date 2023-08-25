variable "project_id" {
  default = "toptierauthentics"
}

variable "region" {
 default = "us-central1"
}

variable "cluster_name" {
  default = "tta-cluster"
}

variable "node_count" {
  default = 1
}

variable "max_nodes" {
  default = 3
}

variable "min_nodes" {
  default = 1
}

variable "admin_username" {
  default = "admin"
}

variable "admin_password" {
  default = "00000000000000000"
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "disk_size" {
  default = "100"
}

variable "disk_type" {
  default = "pd-standard"
}

variable "master_zone" {
  default = "us-central1"
}

variable "zones" {
  type    = list
  default = [
    "us-central1-a",
    "us-central1-b",
    "us-central1-c",
    "us-central1-d",
    "us-central1-f",
  ]
}

variable "domains" {
  type    = list
}

variable "min_master_version" {
  default = "1.9.4-gke.1"
}

variable "initial_default_pool_name" {
  default = "unused-default-pool"
}

variable "default_pool_name" {
  default = "default-pool"
}

variable "daily_maintenance_window_start_time" {
  default = "00:00"
}

variable "project" {
  default = "toptierauthentics"
}

variable "env" {
  default = "development"
}

variable "kubernetes_network_name" {
  default = "kubernetes-network"
}

variable "preemptible" {
  description = "Whether nodes are premptible or not"
  type        = bool
  default     = false
}
