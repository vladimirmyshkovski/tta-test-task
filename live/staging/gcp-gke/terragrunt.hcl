include {
  path = find_in_parent_folders()
}

locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
}

terraform {
  source = "../../../modules/gcp-gke"
}

inputs = {
  project_id   = local.env.project

  cluster_name = join("-", [local.common.org, local.env.env])
  region       = local.env.region
  zones        = ["us-central1-a", "us-central1-b"]

  machine_type = "n1-standard-1"

  node_count   = 2
  max_nodes    = 3

  disk_size    = 30

  preemptible  = true

  domains      = local.env.domains
}
