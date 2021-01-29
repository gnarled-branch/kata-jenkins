terraform {
  backend "remote" {
    organization = "code-liberation-front"

    workspaces {
      name = "terraform-kata"
    }
  }
}

provider "azurerm" {
   client_id = var.deployment_client_id
   client_secret = var.deployment_client_secret
   subscription_id= var.deployment_subscription_id
   tenant_id= var.deployment_tenant_id
   skip_provider_registration = "true"
   features {}
}

resource "azurerm_resource_group" "example" {
  name     = "${var.app}-resources"
  location = var.location
}

resource "azurerm_app_service_plan" "example" {
  name                = "${var.app}-asp"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "${var.app}-appservice"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    app_command_line = ""
    linux_fx_version = "DOCKER|${var.docker-image}"
    always_on        = "true"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = false
    "DOCKER_REGISTRY_SERVER_URL"          = "https://index.docker.io"
    "DOCKER_ENABLE_CI"                    = true
   
  }
}
