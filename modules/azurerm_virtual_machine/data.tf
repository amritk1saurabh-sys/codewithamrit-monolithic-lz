data "azurerm_subnet" "this"{
  for_each = var.vms

  name = each.value.nic_subnet_name
  virtual_network_name = each.value.nic_vnet_name
  resource_group_name = each.value.rg_name
}