include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/gcp-gke-deployment"
}

dependency "gke" {
  config_path = find_in_parent_folders("gcp-gke")
  mock_outputs = {
    cluster_endpoint      = "196.168.0.1"
    cluster_name          = ""
    ca_certificate        = ""
    access_token          = ""
    service_account_name  = ""
    env                   = ""
  }
}

dependency "db" {
  config_path = find_in_parent_folders("gcp-postgresql")
  mock_outputs = {
    name: ""
    psql_user_name: ""
    psql_user_pass: ""
    public_ip_address: "",
    connection_name: ""
  }
}

dependency "env" {
  config_path = find_in_parent_folders("gcp-env")
  mock_outputs = {
    service_account_name    = ""
    config_map_key_ref_name = ""
  }

}

inputs = {
  cluster_endpoint            = dependency.gke.outputs.cluster_endpoint
  cluster_name                = dependency.gke.outputs.cluster_name
  ca_certificate              = dependency.gke.outputs.ca_certificate
  access_token                = dependency.gke.outputs.access_token
  service_account_name        = dependency.env.outputs.service_account_name
  env_name                    = dependency.env.outputs.config_map_key_ref_name

  name                        = "notify"
  port                        = 3004

  startup_probe_enabled        = true
  readiness_probe_enabled      = true
  liveness_probe_enabled       = true

  enable_postgresql            = false
  postgresql_connection_port   = 5432
  postgresql_connection_name   = dependency.db.outputs.connection_name
  postgresql_database_user     = dependency.db.outputs.psql_user_name
  postgresql_database_password = dependency.db.outputs.psql_user_pass
}
