terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.93.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  client_id       = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  client_secret   = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  tenant_id       = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  features {}
}


locals {
  resource_group="app-grp"
  location="North Europe"
}

resource "azurerm_virtual_machine" "main" {
  name                  = "name"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
resource "azurerm_managed_disk" "data_disk" {
  name                 = "disk-1"
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 80
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk-attach" {
  managed_disk_id    = azurerm_managed_disk.data_disk.id
  virtual_machine_id = azurerm_virtual_machine.main.id
  lun                = "10"
  caching            = "ReadWrite"
depends_on = [
    azurerm_windows_virtual_machine.main,
    azurerm_managed_disk.data_disk
  ]
}
}
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "xxxxxx"
  }
}
