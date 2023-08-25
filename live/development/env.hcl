locals {
  env                 = "development"
  region              = "europe-central2"


  domains             = ["dev2.toptierauthentics.com"]
  lab_domains         = ["lab2.toptierauthentics.com"]

  credentials_path    = "${get_terragrunt_dir()}/credentials.json"
  credentials         = jsondecode(file(local.credentials_path))

  service_account     = local.credentials.client_email
  project             = local.credentials.project_id
}
