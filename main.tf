provider "azurerm" {
  features {}
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  resource_group_name = "raamses-gaia-playground"
  location            = "westeurope"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/479a31b3-522c-46e5-b9c7-548e80d1c69f/resourceGroups/raamses-gaia-playground/providers/Microsoft.Network/virtualNetworks/example-network/subnets/internal"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example" {
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
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  tags     = {application="gaia"}
}
