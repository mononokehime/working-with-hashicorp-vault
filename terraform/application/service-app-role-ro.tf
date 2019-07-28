resource "vault_approle_auth_backend_role" "approle_application_role_ro" {
  backend    = "${vault_auth_backend.approle.path}"
  role_name  = "${var.application_name}-ro"
  policies   = ["${vault_policy.application_ro.name}"]
  depends_on = ["vault_auth_backend.approle"]
}
