resource "azurerm_resource_group" "lab" {
  name     = "rg-terraform-first-lab"
  location = var.location

  tags = {
    Project     = "TerraformFirstLab"
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}