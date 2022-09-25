#____________________________________________________________
#
# Collect the moid of the Local User Password Policy as an Output
#____________________________________________________________

output "moid" {
  description = "Local User Password Policy Managed Object ID (moid)."
  value       = intersight_iam_end_point_user_policy.local_user.moid
}
