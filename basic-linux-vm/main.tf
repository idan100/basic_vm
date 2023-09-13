provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "linux_example" {
  name                = "example-network"
  address_space       = ["10.66.0.0/16"]
  resource_group_name = "raamses-gaia-playground"
  location            = "westeurope"
}

resource "azurerm_subnet" "linux_example" {
  name                 = "internal"
  resource_group_name = "raamses-gaia-playground"
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.66.2.0/24"]
}

resource "azurerm_network_interface" "linux_example" {
  name                = "example-nic"
  resource_group_name = "raamses-gaia-playground"
  location            = "westeurope"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "linux_example" {
  name                = "example-machine"
  resource_group_name = "raamses-gaia-playground"
  location            = "westeurope"
  size                = "Standard_DS1_v2"
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
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  tags     = {application="gaia"}
}
