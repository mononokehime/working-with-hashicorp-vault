output "application_ro_name" {
  value = "${vault_approle_auth_backend_role.approle_application_role_ro.role_name}"
}

output "application_ro_role_id" {
  value = "${vault_approle_auth_backend_role.approle_application_role_ro.role_id}"
}

output "application_ro_backend" {
  value = "${vault_approle_auth_backend_role.approle_application_role_ro.backend}"
}
