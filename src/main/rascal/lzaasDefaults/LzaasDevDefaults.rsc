module lzaasDefaults::LzaasDevDefaults

import genLib::Core;

// Probably not best place for this..
public str default_loc = "westeurope";

// Default map of value, these will be added to each resource.
// Lets generate most of these defaults
public map[str, map[str,value]] defaultMap = (
    "azurerm_storage_account":
    (
        "location"                 : default_loc,
        "account_tier"             : "Standard",
        "account_replication_type" : "GRS"
    ),
    "azurerm_virtual_network":
    (
        "location"                 : default_loc,
        "address_space"            : ["10.0.0.0/16"]
    ),
    "azurerm_subnet":
    (
        "service_endpoints"    : ["Microsoft.Storage"]
    )
);