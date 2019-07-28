variable "application_name" {
  default = "test"
  type    = "string"
}

variable "listing_visibility" {
  default = "false"
  description = "Speficies whether to show this mount in the UI-specific listing endpoint."
}