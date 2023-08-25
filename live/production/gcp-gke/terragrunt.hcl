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
  project_id    = local.env.project

  cluster_name  = join("-", [local.common.org, local.env.env])
  region        = local.env.region
  zones         = [
    "us-central1-a",
    "us-central1-b",
    "us-central1-c",
  ]

  machine_type  = "n1-standard-1"

  node_count    = 3
  max_nodes     = 5

  disk_size     = 100

  preemptible   = true

  domains       = local.env.domains
}
