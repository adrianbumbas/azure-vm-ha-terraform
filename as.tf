variable subscription_id {}
variable tenant_id {}
variable client_id {}
variable client_secret {}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

resource "azurerm_resource_group" "myterraformgroup" {
  name     = "vmharg2"
  location = "eastus"
}

resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}

resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "myterraformnic" {
  count               = 3
  name                = "myNIC${count.index}"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration${count.index}"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_availability_set" "set" {
  count                        = 2
  name                         = "availabilitySet${count.index}"
  location                     = azurerm_resource_group.myterraformgroup.location
  resource_group_name          = azurerm_resource_group.myterraformgroup.name
  managed                      = true
  platform_update_domain_count = 20
  platform_fault_domain_count  = 3
}

resource "azurerm_virtual_machine" "vm" {
  count                 = 3
  name                  = "vm_az${count.index}"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.myterraformgroup.name
  network_interface_ids = ["${azurerm_network_interface.myterraformnic[count.index].id}"]
  vm_size               = "Standard_B1ls"
  availability_set_id   = count.index == 3 ? azurerm_availability_set.set[2].id : azurerm_availability_set.set[1].id

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myOsDisk${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}
