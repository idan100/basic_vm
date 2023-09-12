resource "azurerm_virtual_machine" "main" {
  name                  = "super-basic-vm"
  location              = "westeurope"
  resource_group_name   = "raamses-gaia-playground"
  network_interface_ids = [azurerm_network_interface.nic1.id]
  vm_size               = "Standard_DS1_v2"
}
