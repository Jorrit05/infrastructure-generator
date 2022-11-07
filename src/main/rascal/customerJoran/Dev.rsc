module customerJoran::Dev

import genLib::Core;
import genLib::Types;
import genLib::Data;
import IO;
import generator::Generator;

public str def_name = "jorrit";
public str def_env = "dev";

// List of maps, use this map to define your entire terraform config
// Works together with a map of default values defined somewhere else.
//
// At the moment of writing each map entry has three required values:
// - "type" azurerm_... type, shorthand is defined as a custom type in module TerraformTypes
// - "name" should be unique
// - resource_group_name
//
// All other (required) values should be defaulted for every resource in module dataDevDefaults.
// every extra entry made here will overwrite those defaults
//
// Create different maps and generate these separately to create different folders. (some more work needed on this)
list[map[str, value]] infrastructure = [
    (
    "type" : storage_account,
    "name" : "st<def_name><def_env>",
    "resource_group_name"      : "rg-<def_name>-<def_env>",
    "account_tier" :  "Premium",
    "network_rules" : (
        "block_name" : "network_rules",
        "default_action" : "Deny",
        "ip_rules" : ["100.0.0.1"],
        "virtual_network_subnet_ids" : dependencyList(["azurerm_subnet.subnetname.id"])
    )
    ),
    (
        "type" : storage_account_met_privatelink,
        "resource_group_name"      : "rg-<def_name>-<def_env>",
        "name" : "st<def_name>2<def_env>"
    ),
    (
        "type" : virtual_network,
        "name" : "vnet-<def_name>-<def_env>",
        "resource_group_name"  : "rg-<def_name>-<def_env>"
    ),
    (
        "type"                 : subnet,
        "name"                 : "subnetname",
        "resource_group_name"  : "rg-<def_name>-<def_env>",
        "virtual_network_name" : dependency("azurerm_virtual_network.vnet-<def_name>-<def_env>.id"),
        "address_prefixes"     : ["10.0.2.0/24"]
    ),
    (
        "type"     : resource_group,
        "name"     : "rg-example-resources",
        "location" : "West Europe"
    )
];

map[Resources, set[str]] multiples = (
    storage_account : {"piet", "pietje"},
    virtual_network : {"vnet1", "vnet2"}
);

void main(){
    loc target_folder = |file:///Users/jorrit/Documents/infrastructure-generator/src/main/rascal/output|;

    // init TF files and empty them
    init(target_folder, infrastructure);
    generate(target_folder, transformMultipleResources(multiples, "rg-defaults-goed-genoeg"));
    // Generate config
    generate(target_folder, infrastructure);
}
