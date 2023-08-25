include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/gcp-nats"
}

dependency "gke" {
  config_path = find_in_parent_folders("gcp-gke")
  mock_outputs = {
    cluster_endpoint      = "196.168.0.1"
    ca_certificate        = ""
    access_token          = ""
  }
}

inputs = {
  cluster_endpoint            = dependency.gke.outputs.cluster_endpoint
  ca_certificate              = dependency.gke.outputs.ca_certificate
  access_token                = dependency.gke.outputs.access_token
}
