resource "vault_auth_backend" "approle" {
  type = "approle"
  path    = "applications/${var.application_name}/approle"
  description = "Backend authentication providers for ${var.application_name} approle"
 # listing_visibility = "${var.listing_visibility}"
}
