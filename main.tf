#____________________________________________________________
#
# Intersight Organization Data Source
# GUI Location: Settings > Settings > Organizations > {Name}
#____________________________________________________________

data "intersight_organization_organization" "org_moid" {
  for_each = {
    for v in [var.organization] : v => v if length(
      regexall("[[:xdigit:]]{24}", var.organization)
    ) == 0
  }
  name     = each.value
}

#____________________________________________________________
#
# Intersight UCS Server Profile(s) Data Source
# GUI Location: Profiles > UCS Server Profiles > {Name}
#____________________________________________________________

data "intersight_server_profile" "profiles" {
  for_each = { for v in var.profiles : v.name => v if v.object_type == "server.Profile" }
  name     = each.value.name
}

#__________________________________________________________________
#
# Intersight UCS Server Profile Template(s) Data Source
# GUI Location: Templates > UCS Server Profile Templates > {Name}
#__________________________________________________________________

data "intersight_server_profile_template" "templates" {
  for_each = { for v in var.profiles : v.name => v if v.object_type == "server.ProfileTemplate" }
  name     = each.value.name
}

#__________________________________________________________________
#
# Intersight Local User Policy
# GUI Location: Policies > Create Policy > Local User
#__________________________________________________________________

resource "intersight_iam_end_point_user_policy" "local_user" {
  depends_on = [
    data.intersight_server_profile.profiles,
    data.intersight_server_profile_template.templates,
    data.intersight_organization_organization.org_moid
  ]
  description = var.description != "" ? var.description : "${var.name} Local User Policy."
  name        = var.name
  password_properties {
    enable_password_expiry   = var.enable_password_expiry
    enforce_strong_password  = var.enforce_strong_password
    force_send_password      = var.always_send_user_password
    grace_period             = var.grace_period
    notification_period      = var.notification_period
    password_expiry_duration = var.password_expiry_duration
    password_history         = var.password_history
  }
  organization {
    moid = length(
      regexall("[[:xdigit:]]{24}", var.organization)
      ) > 0 ? var.organization : data.intersight_organization_organization.org_moid[
      var.organization].results[0
    ].moid
    object_type = "organization.Organization"
  }
  dynamic "profiles" {
    for_each = { for v in var.profiles : v.name => v }
    content {
      moid = length(regexall("server.ProfileTemplate", profiles.value.object_type)
        ) > 0 ? data.intersight_server_profile_template.templates[profiles.value.name].results[0
      ].moid : data.intersight_server_profile.profiles[profiles.value.name].results[0].moid
      object_type = profiles.value.object_type
    }
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
#____________________________________________________________________
#
# Intersight Local User - Add New User
# GUI Location: Policies > Create Policy > Local User > Add New User
#____________________________________________________________________

data "intersight_iam_end_point_role" "user_roles" {
  for_each = { for v in var.users : v.role => v }
  name = each.value.role
  type = "IMC"
}

resource "intersight_iam_end_point_user" "users" {
  for_each = { for v in var.local_users : v.user => v }
  name = var.username
  organization {
    moid = length(
      regexall("[[:xdigit:]]{24}", var.organization)
      ) > 0 ? var.organization : data.intersight_organization_organization.org_moid[
      var.organization].results[0
    ].moid
    object_type = "organization.Organization"
  }
}

resource "intersight_iam_end_point_user_role" "user_role" {
  depends_on = [
    data.intersight_iam_end_point_role.user_roles,
    intersight_iam_end_point_user.user
  ]
  for_each = { for v in var.local.users : v.user => v }
  enabled  = each.value.enabled
  password = length(
    regexall("^1$", each.value.password)
    ) > 0 ? var.local_user_password_1 : length(
    regexall("^2$", each.value.password)
    ) > 0 ? var.local_user_password_2 : length(
    regexall("^3$", each.value.password)
    ) > 0 ? var.local_user_password_3 : length(
    regexall("^4$", each.value.password)
  ) > 0 ? var.local_user_password_4 : var.local_user_password_5
  end_point_role {
    moid        = data.intersight_iam_end_point_role.user_roles[each.value.role].results[0].moid
    object_type = "iam.EndPointRole"
  }
  end_point_user {
    moid        = intersight_iam_end_point_user.users[each.key].moid
    object_type = "iam.EndPointUser"
  }
  end_point_user_policy {
    moid        = intersight_iam_end_point_user_policy.local_user
    object_type = "iam.EndPointUserPolicy"
  }
}
