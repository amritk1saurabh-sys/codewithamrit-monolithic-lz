module "resource_group" {
  source = "../../modules/azurerm_resource_group"
  rgs    = var.rgs
}

module "virtual_network" {
  source = "../../modules/azurerm_virtual_network"
  vnets  = var.vnets

  depends_on = [module.resource_group]

}
module "subnet" {
  source  = "../../modules/azurerm_subnet"
  subnets = var.subnets

  depends_on = [module.virtual_network]

}

module "vm" {
  source = "../../modules/azurerm_virtual_machine"
  vms    = var.vms

  depends_on = [module.subnet]
}