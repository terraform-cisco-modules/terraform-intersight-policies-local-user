#____________________________________________________________
#
# Collect the moid of the Local User Password Policy as an Output
#____________________________________________________________

output "moid" {
  description = "Local User Password Policy Managed Object ID (moid)."
  value       = intersight_iam_end_point_user_policy.user_policy.moid
}
#____________________________________________________________
#
# Collect the moid of the Local User as an Output
#____________________________________________________________

output "moid" {
  description = "Local User Managed Object ID (moid)."
  value       = intersight_iam_end_point_user.user.moid
}
