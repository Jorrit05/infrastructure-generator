module genLib::Types

import genLib::Data;

// All of these should be generated
public Resources storage_account = resourceType("azurerm_storage_account");
public Resources virtual_network = resourceType("azurerm_virtual_network");
public Resources subnet = resourceType("azurerm_subnet");
public Resources resource_group = resourceType("azurerm_resource_group");
public Resources storage_account_met_privatelink = resourceType("storage_account_met_privatelink");
