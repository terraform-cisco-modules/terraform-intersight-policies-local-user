module "local_user" {
  source  = "terraform-cisco-modules/policies-local-user/intersight"
  version = ">= 1.0.1"

  description = "default Local User Policy."
  local_users = [{
    password = 1
    role     = "admin"
    user     = "admin"
  }]
  name         = "default"
  organization = "default"
}
