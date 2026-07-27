
module "public_ip"{
    source = "../azurerm_public_ip"
    for_each = var.vms

    name = each.value.nic_pip_name
    location = each.value.location
    resource_group_name = each.value.rg_name
    allocation_method = "Dynamic"
  
}
resource "azurerm_network_interface" "this" {

    for_each = var.vms

    name = each.value.nic_name
  location = each.value.location
  resource_group_name = each.value.rg_name

  ip_configuration {
    name = "internal"
    subnet_id = data.azurerm_subnet.this[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = module.public_ip[each.key].id
  }
}
resource "azurerm_linux_virtual_machine" "this"{
 for_each = var.vms

  name                = each.value.vm_name
  resource_group_name = each.value.rg_name
  location            = each.value.location
  size                = each.value.vm_size
  admin_username      = each.value.admin_username
  admin_password = each.value.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.this[each.key].id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}