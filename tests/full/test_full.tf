module "main" {
  source                = "../.."
  description           = "${var.name} Local User Policy."
  name                  = var.name
  local_user_password_1 = var.local_user_password_1
  organization          = "terratest"
  users = [{
    password = 1
    role     = "admin"
    user     = "admin"
  }]
}

output "user" {
  value = module.main.users["admin"]
}

output "user_role" {
  value = module.main.user_roles["admin"]
}

variable "local_user_password_1" {
  sensitive = true
  type      = string
}