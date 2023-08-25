provider "random" {
  # version = "~> 3.5.1"
}

# Enable required account services
module "gcp_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.3.0"

  project_id = var.project_id

  disable_services_on_destroy = false
  disable_dependent_services  = false

  activate_apis = [
    "sqladmin.googleapis.com",
  ]
}

# Generate a random user name
resource "random_password" "user_name" {
  length  = 16
  special = false
}

# Create the Postgres instance
module "db" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~> 14.0.0"

  project_id = module.gcp_services.project_id

  name             = var.name
  user_name        = random_password.user_name.result
  database_version = "POSTGRES_14"

  zone      = var.zone
  region    = var.region
  disk_size = var.disk_size
  tier      = var.tier

  deletion_protection = var.deletion_protection

  backup_configuration = {
    point_in_time_recovery_enabled = var.enable_backups
    retained_backups               = 1
    retention_unit                 = "COUNT"
    transaction_log_retention_days = "1"
    enabled                        = var.enable_backups
    start_time                     = "04:00"
    location                       = var.region
  }

  ip_configuration = {
    allocated_ip_range                            = "" # var.authorized_networks
    enable_private_path_for_google_cloud_services = false
    ipv4_enabled                                  = true
    private_network                               = "projects/${var.project_id}/global/networks/default"
    require_ssl                                   = false
    authorized_networks                           = var.authorized_networks
  }

  database_flags = [
    {
      "name": "max_connections"
      "value": 150
    },
    {
      "name": "shared_buffers"
      "value": 78643
    }
  ]
}
