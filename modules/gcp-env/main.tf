provider "kubernetes" {
  token                       = var.access_token
  host                        = "https://${var.cluster_endpoint}/"
  cluster_ca_certificate      = base64decode(var.ca_certificate)
}

provider "random" {}

# Generate a random access_token secret
resource "random_password" "access_token" {
  length  = 32
  special = false
}

# Generate a random refresh_token secret
resource "random_password" "refresh_token" {
  length  = 32
  special = false
}

# Generate a random lab_token secret
resource "random_password" "lab_token" {
  length  = 32
  special = false
}

locals {
  service_account_name    = "${var.cluster_name}-gke-sql-service-account"
  env                     = "${var.cluster_name}-gke-env"
}

resource "kubernetes_config_map" "default" {
  metadata {
    name = local.env
  }

  data = {}
}

resource "kubernetes_service_account" "default" {
  metadata {
    annotations = {
      "iam.gke.io/gcp-service-account" = var.gcp_service_account
    }
    name = local.service_account_name
  }
}
