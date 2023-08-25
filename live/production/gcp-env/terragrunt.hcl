include {
  path = find_in_parent_folders()
}

locals {
  env           = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "../../../modules/gcp-env"
}

dependency "gke" {
  config_path = find_in_parent_folders("gcp-gke")
  mock_outputs = {
    cluster_endpoint      = "196.168.0.1"
    cluster_name          = ""
    ca_certificate        = ""
    access_token          = ""
    service_account       = ""
  }
}

inputs = {
  cluster_endpoint            = dependency.gke.outputs.cluster_endpoint
  cluster_name                = dependency.gke.outputs.cluster_name
  ca_certificate              = dependency.gke.outputs.ca_certificate
  access_token                = dependency.gke.outputs.access_token

  env                         = local.env.env
  domains                     = local.env.domains
}
