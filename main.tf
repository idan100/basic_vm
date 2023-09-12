# provides configuration details for terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.39.0"
    }
  }
}

# provides configuration details for the azure terraform provider
provider "azurerm" {
  features {}
}

# define a network interface for the VM
resource "azurerm_network_interface" "VMNic" {
  name                = "GaiaVMNic"
  location            = "westeurope"
  resource_group_name = "raamses-gaia-playground"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "/subscriptions/91862d55-3657-403d-abb8-3ab2c82481bf/resourceGroups/raamses-gaia-playground/providers/Microsoft.Network/virtualNetworks/raamses-gaia-playground/subnets/default"
    private_ip_address_allocation = "Dynamic"
  }
}

# define the VM
resource "azurerm_linux_virtual_machine" "GaiaVM" {
  name                  = "GaiaWebsiteVM"
  location              = "westeurope"
  resource_group_name   = "raamses-gaia-playground"
  network_interface_ids = [azurerm_network_interface.VMNic.id]
  size                  = "Standard_B1s"
  disable_password_authentication = false
  admin_username = "devops"
  admin_password = "Bsmch@500K!"

  source_image_reference {
    publisher = "apps-4-rent"
    offer     = "apache-on-centos8"
    sku       = "apache-on-centos8"
    version   = "1.0.0"
  }

  plan {
    name = "apache-on-centos8"
    product = "apache-on-centos8"
    publisher = "apps-4-rent"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
 
}
