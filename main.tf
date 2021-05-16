resource "azurerm_resource_group" "resource_group" {
  name                = "${var.application}-${var.environment}"
  location            = "${var.location}"
}

module "application-vnet" {
  source              = "./modules/vnet"
  vnet_name           = "${azurerm_resource_group.resource_group.name}-vnet"
  address_space       = "${var.address_space}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
}

module "application-subnets" {
  source               = "./modules/subnet"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  location             = "${var.location}"
  vnet_name            = "${module.application-vnet.vnet_name}"
  subnets              = [
    {
      name   = "${azurerm_resource_group.resource_group.name}-subnet"
      prefix = "${var.subnet}" 
    }
  ]
}

module "vmss" {
  source              = "./modules/vmss"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.location}"
  saname              = "${var.application}${var.environment}"
  capacity            = "${var.capacity}"
  subnet_id           = "${module.application-subnets.vnet_subnets}"
}
