variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "australiaeast"
}

variable "app_name" {
  description = "Application name used in resource naming. Must include 'superspecials'."
  type        = string
  default     = "superspecials"

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.app_name)) && can(regex("superspecials", var.app_name))
    error_message = "app_name must be lowercase letters/digits and include 'superspecials'."
  }
}

variable "name_suffix" {
  description = "Lowercase letters/digits only; short suffix to keep Storage Account names <= 24 chars."
  type        = string
  default     = "01"

  validation {
    condition     = can(regex("^[a-z0-9]{0,4}$", var.name_suffix))
    error_message = "name_suffix must be 0-4 chars of lowercase letters or digits."
  }
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    challenge = "coles-devops"
    managedBy = "terraform"
  }
}
