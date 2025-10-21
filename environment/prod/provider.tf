terraform{
    required_version = ">= 1.3.0"
    required_providers{
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">=4.0.0"

        }
    }

    backend "azurerm"   {
        resource_group_name  = "bappa-remotestate-rg"
        storage_account_name  = "bappastatefiles"
        container_name        = "statecfiles"
        key                   = "prod.tfstate"
    }
}

provider "azurerm" {
    features{}
    subscription_id = "8b10287d-12d6-41e3-b62c-33457c006e96"
  
}