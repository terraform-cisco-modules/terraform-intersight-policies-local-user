#____________________________________________________________
#
# Local User Policy Variables Section.
#____________________________________________________________

variable "always_send_user_password" {
  default     = false
  description = "User password will always be sent to endpoint device. If the option is not selected, then user password will be sent to endpoint device for new users and if user password is changed for existing users."
  type        = bool
}

variable "description" {
  default     = ""
  description = "Description for the Policy."
  type        = string
}

variable "enable_password_expiry" {
  default     = false
  description = "Enables password expiry on the endpoint."
  type        = bool
}

variable "enforce_strong_password" {
  default     = true
  description = "Enables a strong password policy. Strong password requirements: A. The password must have a minimum of 8 and a maximum of 20 characters. B. The password must not contain the User's Name. C. The password must contain characters from three of the following four categories. 1) English uppercase characters (A through Z). 2) English lowercase characters (a through z). 3) Base 10 digits (0 through 9). 4) Non-alphabetic characters (! , @, #, $, %, ^, &, *, -, _, +, =)."
  type        = bool
}

variable "grace_period" {
  default     = 0
  description = "Time period until when you can use the existing password, after it expires."
  type        = number
}

variable "local_user_password_1" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

variable "local_user_password_2" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

variable "local_user_password_3" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

variable "local_user_password_4" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

variable "local_user_password_5" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

variable "local_users" {
  default     = []
  description = <<-EOT
    List of Users to add to the local user policy.
    * enabled - Enables the user account on the endpoint.
    * password - This is a key to signify the variable "local_user_password_[key]" to be used.  i.e. 1 for variable "local_user_password_1".
    * role - The Role to Assign to the User.  Valid Options are {admin|readonly|user}.
    * user - Username
  EOT
  type = list(object(
    {
      enabled  = optional(bool, true)
      password = optional(number, 1)
      role     = optional(string, "admin")
      user     = string
    }
  ))
}

variable "name" {
  default     = "default"
  description = "Name for the Policy."
  type        = string
}

variable "notification_period" {
  default     = 15
  description = "The duration after which the password will expire."
  type        = number
}

variable "organization" {
  default     = "default"
  description = "Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/."
  type        = string
}

variable "password_expiry_duration" {
  default     = 90
  description = "Set time period for password expiration. Value should be greater than notification period and grace period."
  type        = number
}

variable "password_history" {
  default     = 5
  description = "Tracks password change history. Specifies in number of instances, that the new password was already used."
  type        = number
}

variable "profiles" {
  default     = []
  description = <<-EOT
    List of Profiles to Assign to the Policy.
    * name - Name of the Profile to Assign.
    * object_type - Object Type to Assign in the Profile Configuration.
      - server.Profile - For UCS Server Profiles.
      - server.ProfileTemplate - For UCS Server Profile Templates.
  EOT
  type = list(object(
    {
      name        = string
      object_type = optional(string, "server.Profile")
    }
  ))
}

variable "tags" {
  default     = []
  description = "List of Tag Attributes to Assign to the Policy."
  type        = list(map(string))
}
