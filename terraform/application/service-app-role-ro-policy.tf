resource "vault_policy" "application_ro" {
  name  = "${var.application_name}-application-ro"

  policy = <<EOT
# Login with AppRole
path "${vault_auth_backend.approle.path}/login" {
  capabilities = [ "create" ]
}

# Set the path for the data
path "applications/${var.application_name}/*" {
  capabilities = [ "read" ]
}
EOT
}
