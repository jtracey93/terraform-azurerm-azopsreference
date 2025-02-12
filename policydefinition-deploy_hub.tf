# This file was auto generated
resource "azurerm_policy_definition" "deploy_hub" {
  name         = "Deploy-HUB"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy Virtual Network to be used as hub virtual network in desired region"
  description  = "Deploys Virtual Network to be used as hub virtual network in desired region in the subscription where this policy is assigned."

  management_group_name = var.management_group_name
  policy_rule           = <<POLICYRULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Resources/subscriptions"
      }
    ]
  },
  "then": {
    "effect": "[parameters('effect')]",
    "details": {
      "type": "Microsoft.Network/virtualNetworks",
      "name": "[parameters('hubName')]",
      "deploymentScope": "Subscription",
      "existenceScope": "ResourceGroup",
      "ResourceGroupName": "[parameters('rgName')]",
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7"
      ],
      "deployment": {
        "location": "northeurope",
        "properties": {
          "mode": "incremental",
          "parameters": {
            "rgName": {
              "value": "[parameters('rgName')]"
            },
            "hubName": {
              "value": "[parameters('hubName')]"
            },
            "HUB": {
              "value": "[parameters('HUB')]"
            },
            "vpngw": {
              "value": "[parameters('vpngw')]"
            },
            "ergw": {
              "value": "[parameters('ergw')]"
            },
            "azfw": {
              "value": "[parameters('azfw')]"
            }
          },
          "template": {
            "$schema": "http://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "hubName": {
                "type": "string",
                "metadata": {
                  "description": "Name of the HUB"
                }
              },
              "HUB": {
                "type": "object",
                "metadata": {
                  "description": "Object describing HUB"
                }
              },
              "vpngw": {
                "type": "object",
                "defaultValue": {},
                "metadata": {
                  "description": "Object describing VPN gateway"
                }
              },
              "ergw": {
                "type": "object",
                "defaultValue": {},
                "metadata": {
                  "description": "Object describing ExpressRoute gateway"
                }
              },
              "azfw": {
                "type": "object",
                "defaultValue": {},
                "metadata": {
                  "description": "Object describing the Azure Firewall"
                }
              },
              "rgName": {
                "type": "String",
                "metadata": {
                  "displayName": "rgName",
                  "description": "Provide name for resource group."
                }
              }
            },
            "variables": {},
            "resources": [
              {
                "type": "Microsoft.Resources/resourceGroups",
                "apiVersion": "2020-06-01",
                "name": "[parameters('rgName')]",
                "location": "[deployment().location]",
                "properties": {}
              },
              {
                "type": "Microsoft.Resources/deployments",
                "apiVersion": "2020-06-01",
                "name": "[concat(parameters('hubName'),'-', parameters('HUB').location)]",
                "resourceGroup": "[parameters('rgName')]",
                "dependsOn": [
                  "[resourceId('Microsoft.Resources/resourceGroups/', parameters('rgName'))]"
                ],
                "properties": {
                  "mode": "Incremental",
                  "template": {
                    "$schema": "https: //schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {},
                    "variables": {},
                    "resources": [
                      {
                        "name": "[parameters('hubName')]",
                        "type": "Microsoft.Network/virtualNetworks",
                        "apiVersion": "2020-04-01",
                        "location": "[parameters('HUB').location]",
                        "properties": {
                          "addressSpace": {
                            "addressPrefixes": [
                              "[parameters('HUB').addressPrefix]"
                            ]
                          },
                          "subnets": [
                            {
                              "name": "Infrastructure",
                              "properties": {
                                "addressPrefix": "[if(not(empty(parameters('HUB').subnets.infra)),parameters('HUB').subnets.infra, json('null'))]"
                              }
                            },
                            {
                              "name": "AzureFirewallSubnet",
                              "properties": {
                                "addressPrefix": "[if(not(empty(parameters('HUB').subnets.azfw)),parameters('HUB').subnets.azfw, json('null'))]"
                              }
                            },
                            {
                              "name": "GatewaySubnet",
                              "properties": {
                                "addressPrefix": "[if(not(empty(parameters('HUB').subnets.gw)),parameters('HUB').subnets.gw, json('null'))]"
                              }
                            }
                          ]
                        }
                      }
                    ]
                  }
                }
              },
              {
                "type": "Microsoft.Resources/deployments",
                "apiVersion": "2020-06-01",
                "condition": "[greater(length(parameters('vpngw')),0)]",
                "resourceGroup": "[parameters('rgName')]",
                "dependsOn": [
                  "[concat(parameters('hubName'),'-', parameters('HUB').location)]"
                ],
                "name": "[concat(parameters('hubName'),'-vpngw')]",
                "properties": {
                  "mode": "Incremental",
                  "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {},
                    "variables": {},
                    "resources": [
                      {
                        "apiVersion": "2020-05-01",
                        "type": "Microsoft.Network/publicIpAddresses",
                        "location": "[parameters('HUB').location]",
                        "name": "[concat(parameters('vpngw').name,'-pip')]",
                        "properties": {
                          "publicIPAllocationMethod": "Dynamic"
                        },
                        "tags": {}
                      },
                      {
                        "apiVersion": "2020-05-01",
                        "name": "[parameters('vpngw').name]",
                        "type": "Microsoft.Network/virtualNetworkGateways",
                        "location": "[parameters('HUB').location]",
                        "dependsOn": [
                          "[concat('Microsoft.Network/publicIPAddresses/', parameters('vpngw').name,'-pip')]"
                        ],
                        "tags": {},
                        "properties": {
                          "gatewayType": "Vpn",
                          "vpnType": "[parameters('vpngw').vpnType]",
                          "ipConfigurations": [
                            {
                              "name": "default",
                              "properties": {
                                "privateIPAllocationMethod": "Dynamic",
                                "subnet": {
                                  "id": "[concat(subscription().id,'/resourceGroups/',parameters('rgName'), '/providers','/Microsoft.Network/virtualNetworks/', parameters('hubName'),'/subnets/GatewaySubnet')]"
                                },
                                "publicIpAddress": {
                                  "id": "[concat(subscription().id,'/resourceGroups/',parameters('rgName'), '/providers','/Microsoft.Network/publicIPAddresses/', parameters('vpngw').name,'-pip')]"
                                }
                              }
                            }
                          ],
                          "sku": {
                            "name": "[parameters('vpngw').sku]",
                            "tier": "[parameters('vpngw').sku]"
                          }
                        }
                      }
                    ]
                  }
                }
              },
              {
                "type": "Microsoft.Resources/deployments",
                "apiVersion": "2020-06-01",
                "condition": "[greater(length(parameters('ergw')),0)]",
                "resourceGroup": "[parameters('rgName')]",
                "dependsOn": [
                  "[concat(parameters('hubName'),'-', parameters('HUB').location)]"
                ],
                "name": "[concat(parameters('hubName'),'-ergw')]",
                "properties": {
                  "mode": "Incremental",
                  "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {},
                    "variables": {},
                    "resources": [
                      {
                        "apiVersion": "2020-05-01",
                        "type": "Microsoft.Network/publicIpAddresses",
                        "location": "[parameters('HUB').location]",
                        "name": "[concat(parameters('ergw').name,'-pip')]",
                        "properties": {
                          "publicIPAllocationMethod": "Dynamic"
                        },
                        "tags": {}
                      },
                      {
                        "apiVersion": "2020-05-01",
                        "name": "[parameters('ergw').name]",
                        "type": "Microsoft.Network/virtualNetworkGateways",
                        "location": "[parameters('HUB').location]",
                        "dependsOn": [
                          "[concat('Microsoft.Network/publicIPAddresses/', parameters('ergw').name,'-pip')]"
                        ],
                        "tags": {},
                        "properties": {
                          "gatewayType": "ExpressRoute",
                          "ipConfigurations": [
                            {
                              "name": "default",
                              "properties": {
                                "privateIPAllocationMethod": "Dynamic",
                                "subnet": {
                                  "id": "[concat(subscription().id,'/resourceGroups/',parameters('rgName'), '/providers','/Microsoft.Network/virtualNetworks/', parameters('hubName'),'/subnets/GatewaySubnet')]"
                                },
                                "publicIpAddress": {
                                  "id": "[concat(subscription().id,'/resourceGroups/',parameters('rgName'), '/providers','/Microsoft.Network/publicIPAddresses/', parameters('ergw').name,'-pip')]"
                                }
                              }
                            }
                          ],
                          "sku": {
                            "name": "[parameters('ergw').sku]",
                            "tier": "[parameters('ergw').sku]"
                          }
                        }
                      }
                    ]
                  }
                }
              },
              {
                "type": "Microsoft.Resources/deployments",
                "apiVersion": "2020-06-01",
                "condition": "[greater(length(parameters('azfw')),0)]",
                "name": "[concat(parameters('hubName'),'-azfw')]",
                "resourceGroup": "[parameters('rgName')]",
                "dependsOn": [
                  "[concat(parameters('hubName'),'-', parameters('HUB').location)]"
                ],
                "properties": {
                  "mode": "Incremental",
                  "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {},
                    "variables": {},
                    "resources": [
                      {
                        "apiVersion": "2020-05-01",
                        "type": "Microsoft.Network/publicIpAddresses",
                        "name": "[concat(parameters('azfw').name,'-pip')]",
                        "location": "[parameters('azfw').location]",
                        "sku": {
                          "name": "Standard"
                        },
                        "zones": "[if(contains(parameters('azfw'),'pipZones'),parameters('azfw').pipZones,json('null'))]",
                        "properties": {
                          "publicIPAllocationMethod": "Static"
                        },
                        "tags": {}
                      },
                      {
                        "apiVersion": "2020-05-01",
                        "type": "Microsoft.Network/azureFirewalls",
                        "name": "[parameters('azfw').name]",
                        "location": "[parameters('azfw').location]",
                        "zones": "[if(contains(parameters('azfw'),'fwZones'),parameters('azfw').fwZones,json('null'))]",
                        "dependsOn": [
                          "[concat(parameters('azfw').name,'-pip')]"
                        ],
                        "properties": {
                          "threatIntelMode": "[parameters('azfw').threatIntelMode]",
                          "additionalProperties": "[if(contains(parameters('azfw'),'additionalProperties'),parameters('azfw').additionalProperties,json('null'))]",
                          "sku": "[if(contains(parameters('azfw'),'sku'),parameters('azfw').sku,json('null'))]",
                          "ipConfigurations": [
                            {
                              "name": "[concat(parameters('azfw').name,'-pip')]",
                              "properties": {
                                "subnet": {
                                  "id": "[concat(subscription().id,'/resourceGroups/',parameters('rgName'), '/providers','/Microsoft.Network/virtualNetworks/', parameters('hubName'),'/subnets/AzureFirewallSubnet')]"
                                },
                                "publicIPAddress": {
                                  "id": "[concat(subscription().id,'/resourceGroups/',parameters('rgName'), '/providers','/Microsoft.Network/publicIPAddresses/', parameters('azfw').name,'-pip')]"
                                }
                              }
                            }
                          ],
                          "firewallPolicy": "[if(contains(parameters('azfw'),'firewallPolicy'),parameters('azfw').firewallPolicy,json('null'))]"
                        },
                        "tags": {}
                      }
                    ]
                  }
                }
              }
            ]
          }
        }
      }
    }
  }
}
POLICYRULE

  parameters = <<PARAMETERS
{
  "hubName": {
    "type": "String",
    "metadata": {
      "displayName": "hubName",
      "description": "Name of the Hub"
    }
  },
  "HUB": {
    "type": "Object",
    "metadata": {
      "displayName": "HUB",
      "description": "Object describing HUB"
    }
  },
  "vpngw": {
    "type": "Object",
    "metadata": {
      "displayName": "vpngw",
      "description": "Object describing VPN gateway"
    },
    "defaultValue": {}
  },
  "ergw": {
    "type": "Object",
    "metadata": {
      "displayName": "ergw",
      "description": "Object describing ExpressRoute gateway"
    },
    "defaultValue": {}
  },
  "azfw": {
    "type": "Object",
    "metadata": {
      "displayName": "ergw",
      "description": "Object describing ExpressRoute gateway"
    },
    "defaultValue": {}
  },
  "rgName": {
    "type": "String",
    "metadata": {
      "displayName": "rgName",
      "description": "Provide name for resource group."
    }
  },
  "effect": {
    "type": "String",
    "metadata": {
      "displayName": "Effect",
      "description": "Enable or disable the execution of the policy"
    },
    "allowedValues": [
      "DeployIfNotExists",
      "Disabled"
    ],
    "defaultValue": "DeployIfNotExists"
  }
}
PARAMETERS

}

output "policydefinition_deploy_hub" {
  value = azurerm_policy_definition.deploy_hub
}

