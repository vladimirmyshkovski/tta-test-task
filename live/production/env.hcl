locals {
  env    = "production"
  region = "us-central1"
  domains = ["prod.toptierauthentics.com"]

  credentials_path = "${get_terragrunt_dir()}/credentials.json"
  credentials      = jsondecode(file(local.credentials_path))

  service_account = local.credentials.client_email
  project         = local.credentials.project_id
}
