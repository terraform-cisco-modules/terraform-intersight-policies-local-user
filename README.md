<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)
[![Tests](https://github.com/terraform-cisco-modules/terraform-intersight-policies-local-user/actions/workflows/terratest.yml/badge.svg)](https://github.com/terraform-cisco-modules/terraform-intersight-policies-local-user/actions/workflows/terratest.yml)

# Terraform Intersight Policies - Local User
Manages Intersight Local User Policies

Location in GUI:
`Policies` » `Create Policy` » `Local User`

## Easy IMM

[*Easy IMM - Comprehensive Example*](https://github.com/terraform-cisco-modules/easy-imm-comprehensive-example) - A comprehensive example for policies, pools, and profiles.

## Example

### main.tf
```hcl
module "local_user" {
  source  = "terraform-cisco-modules/policies-local-user/intersight"
  version = ">= 1.0.1"

  description  = "default Local User Policy."
  name         = "default"
  organization = "default"
  users = [{
    password = 1
    role     = "admin"
    user     = "admin"
  }]
}
```

### provider.tf
```hcl
terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
  required_version = ">=1.3.0"
}

provider "intersight" {
  apikey    = var.apikey
  endpoint  = var.endpoint
  secretkey = fileexists(var.secretkeyfile) ? file(var.secretkeyfile) : var.secretkey
}
```

### variables.tf
```hcl
variable "apikey" {
  description = "Intersight API Key."
  sensitive   = true
  type        = string
}

variable "endpoint" {
  default     = "https://intersight.com"
  description = "Intersight URL."
  type        = string
}

variable "secretkey" {
  default     = ""
  description = "Intersight Secret Key Content."
  sensitive   = true
  type        = string
}

variable "secretkeyfile" {
  default     = "blah.txt"
  description = "Intersight Secret Key File Location."
  sensitive   = true
  type        = string
}
```

## Environment Variables

### Terraform Cloud/Enterprise - Workspace Variables
- Add variable apikey with the value of [your-api-key]
- Add variable secretkey with the value of [your-secret-file-content]

### Linux and Windows
```bash
export TF_VAR_apikey="<your-api-key>"
export TF_VAR_secretkeyfile="<secret-key-file-location>"
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.32 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | >=1.0.32 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_always_send_user_password"></a> [always\_send\_user\_password](#input\_always\_send\_user\_password) | User password will always be sent to endpoint device. If the option is not selected, then user password will be sent to endpoint device for new users and if user password is changed for existing users. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Description for the Policy. | `string` | `""` | no |
| <a name="input_enable_password_expiry"></a> [enable\_password\_expiry](#input\_enable\_password\_expiry) | Enables password expiry on the endpoint. | `bool` | `false` | no |
| <a name="input_enforce_strong_password"></a> [enforce\_strong\_password](#input\_enforce\_strong\_password) | Enables a strong password policy. Strong password requirements: A. The password must have a minimum of 8 and a maximum of 20 characters. B. The password must not contain the User's Name. C. The password must contain characters from three of the following four categories. 1) English uppercase characters (A through Z). 2) English lowercase characters (a through z). 3) Base 10 digits (0 through 9). 4) Non-alphabetic characters (! , @, #, $, %, ^, &, *, -, \_, +, =). | `bool` | `true` | no |
| <a name="input_grace_period"></a> [grace\_period](#input\_grace\_period) | Time period until when you can use the existing password, after it expires. | `number` | `0` | no |
| <a name="input_local_user_password_1"></a> [local\_user\_password\_1](#input\_local\_user\_password\_1) | Password to assign to a local user.  Sensitive Variables cannot be added to a for\_each loop so these are added seperately. | `string` | `""` | no |
| <a name="input_local_user_password_2"></a> [local\_user\_password\_2](#input\_local\_user\_password\_2) | Password to assign to a local user.  Sensitive Variables cannot be added to a for\_each loop so these are added seperately. | `string` | `""` | no |
| <a name="input_local_user_password_3"></a> [local\_user\_password\_3](#input\_local\_user\_password\_3) | Password to assign to a local user.  Sensitive Variables cannot be added to a for\_each loop so these are added seperately. | `string` | `""` | no |
| <a name="input_local_user_password_4"></a> [local\_user\_password\_4](#input\_local\_user\_password\_4) | Password to assign to a local user.  Sensitive Variables cannot be added to a for\_each loop so these are added seperately. | `string` | `""` | no |
| <a name="input_local_user_password_5"></a> [local\_user\_password\_5](#input\_local\_user\_password\_5) | Password to assign to a local user.  Sensitive Variables cannot be added to a for\_each loop so these are added seperately. | `string` | `""` | no |
| <a name="input_users"></a> [users](#input\_users) | List of Users to add to the local user policy.<br>* enabled - Enables the user account on the endpoint.<br>* password - This is a key to signify the variable "local\_user\_password\_[key]" to be used.  i.e. 1 for variable "local\_user\_password\_1".<br>* role - The Role to Assign to the User.  Valid Options are {admin\|readonly\|user}.<br>* user - Username | <pre>list(object(<br>    {<br>      enabled  = optional(bool, true)<br>      password = optional(number, 1)<br>      role     = optional(string, "admin")<br>      user     = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the Policy. | `string` | `"default"` | no |
| <a name="input_notification_period"></a> [notification\_period](#input\_notification\_period) | The duration after which the password will expire. | `number` | `15` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/. | `string` | `"default"` | no |
| <a name="input_password_expiry_duration"></a> [password\_expiry\_duration](#input\_password\_expiry\_duration) | Set time period for password expiration. Value should be greater than notification period and grace period. | `number` | `90` | no |
| <a name="input_password_history"></a> [password\_history](#input\_password\_history) | Tracks password change history. Specifies in number of instances, that the new password was already used. | `number` | `5` | no |
| <a name="input_profiles"></a> [profiles](#input\_profiles) | List of Profiles to Assign to the Policy.<br>* name - Name of the Profile to Assign.<br>* object\_type - Object Type to Assign in the Profile Configuration.<br>  - server.Profile - For UCS Server Profiles.<br>  - server.ProfileTemplate - For UCS Server Profile Templates. | <pre>list(object(<br>    {<br>      name        = string<br>      object_type = optional(string, "server.Profile")<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of Tag Attributes to Assign to the Policy. | `list(map(string))` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_moid"></a> [moid](#output\_moid) | Local User Password Policy Managed Object ID (moid). |
| <a name="output_user_roles"></a> [user\_roles](#output\_user\_roles) | n/a |
| <a name="output_users"></a> [users](#output\_users) | n/a |
## Resources

| Name | Type |
|------|------|
| [intersight_iam_end_point_user.users](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_end_point_user) | resource |
| [intersight_iam_end_point_user_policy.local_user](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_end_point_user_policy) | resource |
| [intersight_iam_end_point_user_role.user_role](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/iam_end_point_user_role) | resource |
| [intersight_iam_end_point_role.user_roles](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/iam_end_point_role) | data source |
| [intersight_organization_organization.org_moid](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/organization_organization) | data source |
| [intersight_server_profile.profiles](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/server_profile) | data source |
| [intersight_server_profile_template.templates](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/server_profile_template) | data source |
<!-- END_TF_DOCS -->