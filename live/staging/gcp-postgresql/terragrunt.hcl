include {
  path = find_in_parent_folders()
}

locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

terraform {
  source = "../../../modules/gcp-postgresql"
}

dependency "gke" {
  config_path = "../gcp-gke"
  mock_outputs = {
    cluster_endpoint      = "196.168.0.1"
    ca_certificate        = ""
    access_token          = ""
  }
}

inputs = {
  project_id = local.env.project

  name   = join("-", [local.common.org, local.env.env])
  region = local.env.region
  zone   = "${local.env.region}-a"

  tier = "db-f1-micro"

  enable_backups = false
}
