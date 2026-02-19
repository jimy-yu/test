terraform {
  # Backend config is supplied via `terraform init -backend-config=...` to keep
  # secrets out of the repo and allow simple overrides per environment.
  backend "azurerm" {}
}
