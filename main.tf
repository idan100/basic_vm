provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
  tags     = {application="gaia"}
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = "raamses-gaia-playground"
  location            = "westeurope"
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name = "raamses-gaia-playground"
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  resource_group_name = "raamses-gaia-playground"
  location            = "westeurope"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = "raamses-gaia-playground"
  location            = "westeurope"
  size                = "DS1_v2"
  admin_username      = "adminIdan"
  admin_password      = "Idantheking123!"
  priority            = "Spot"
  eviction_policy     = "Deallocate"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  tags     = {application="gaia"}
}
