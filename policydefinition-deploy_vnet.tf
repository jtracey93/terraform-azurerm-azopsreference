# This file was auto generated
resource "azurerm_policy_definition" "deploy_vnet" {
  name         = "Deploy-vNet"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy spoke network with configuration to hub network based on ipam configuration object"
  description  = "Deploy spoke network with configuration to hub network based on ipam configuration object"

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
      "type": "Microsoft.Resources/resourceGroups",
      "deploymentScope": "Subscription",
      "existenceScope": "Subscription",
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7"
      ],
      "existenceCondition": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Resources/subscriptions/resourceGroups"
          },
          {
            "field": "name",
            "like": "[concat(subscription().displayName, '-network')]"
          }
        ]
      },
      "deployment": {
        "location": "northeurope",
        "properties": {
          "mode": "incremental",
          "parameters": {
            "ipam": {
              "value": "[parameters('ipam')]",
              "defaultValue": []
            }
          },
          "template": {
            "$schema": "http://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "ipam": {
                "defaultValue": [
                  {
                    "name": "bu1-weu-msx3-vNet1",
                    "location": "westeurope",
                    "virtualNetworks": {
                      "properties": {
                        "addressSpace": {
                          "addressPrefixes": [
                            "10.51.217.0/24"
                          ]
                        }
                      }
                    },
                    "networkSecurityGroups": {
                      "properties": {
                        "securityRules": []
                      }
                    },
                    "routeTables": {
                      "properties": {
                        "routes": []
                      }
                    },
                    "hubVirtualNetworkConnection": {
                      "vWanVhubResourceId": "/subscriptions/99c2838f-a548-4884-a6e2-38c1f8fb4c0b/resourceGroups/contoso-global-vwan/providers/Microsoft.Network/virtualHubs/contoso-vhub-weu",
                      "properties": {
                        "allowHubToRemoteVnetTransit": true,
                        "allowRemoteVnetToUseHubVnetGateways": false,
                        "enableInternetSecurity": true
                      }
                    }
                  }
                ],
                "type": "Array"
              }
            },
            "variables": {
              "vNetRgName": "[concat(subscription().displayName, '-network')]",
              "vNetName": "[concat(subscription().displayName, '-vNet')]",
              "vNetSubId": "[subscription().subscriptionId]"
            },
            "resources": [
              {
                "type": "Microsoft.Resources/deployments",
                "apiVersion": "2020-06-01",
                "name": "[concat('es-ipam-',subscription().displayName,'-RG-',copyIndex())]",
                "location": "[parameters('ipam')[copyIndex()].location]",
                "dependsOn": [],
                "properties": {
                  "mode": "Incremental",
                  "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {},
                    "variables": {},
                    "resources": [
                      {
                        "type": "Microsoft.Resources/resourceGroups",
                        "apiVersion": "2020-06-01",
                        "name": "[variables('vNetRgName')]",
                        "location": "[parameters('ipam')[copyIndex()].location]",
                        "properties": {}
                      },
                      {
                        "type": "Microsoft.Resources/resourceGroups",
                        "apiVersion": "2020-06-01",
                        "name": "NetworkWatcherRG",
                        "location": "[parameters('ipam')[copyIndex()].location]",
                        "properties": {}
                      }
                    ],
                    "outputs": {}
                  }
                },
                "copy": {
                  "name": "ipam-rg-loop",
                  "count": "[length(parameters('ipam'))]"
                },
                "condition": "[if(and(not(empty(parameters('ipam'))), equals(toLower(parameters('ipam')[copyIndex()].name),toLower(variables('vNetName')))),bool('true'),bool('false'))]"
              },
              {
                "type": "Microsoft.Resources/deployments",
                "apiVersion": "2020-06-01",
                "name": "[concat('es-ipam-',subscription().displayName,'-nsg-udr-vnet-hub-vwan-peering-',copyIndex())]",
                "dependsOn": [
                  "[concat('es-ipam-',subscription().displayName,'-RG-',copyIndex())]"
                ],
                "properties": {
                  "mode": "Incremental",
                  "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {},
                    "variables": {},
                    "resources": [
                      {
                        "condition": "[contains(parameters('ipam')[copyIndex()],'networkSecurityGroups')]",
                        "apiVersion": "2020-05-01",
                        "type": "Microsoft.Network/networkSecurityGroups",
                        "name": "[concat(subscription().displayName, '-nsg')]",
                        "location": "[parameters('ipam')[copyIndex()].location]",
                        "properties": "[if(contains(parameters('ipam')[copyIndex()],'networkSecurityGroups'),parameters('ipam')[copyIndex()].networkSecurityGroups.properties,json('null'))]"
                      },
                      {
                        "condition": "[contains(parameters('ipam')[copyIndex()],'routeTables')]",
                        "apiVersion": "2020-05-01",
                        "type": "Microsoft.Network/routeTables",
                        "name": "[concat(subscription().displayName, '-udr')]",
                        "location": "[parameters('ipam')[copyIndex()].location]",
                        "properties": "[if(contains(parameters('ipam')[copyIndex()],'routeTables'),parameters('ipam')[copyIndex()].routeTables.properties,json('null'))]"
                      },
                      {
                        "condition": "[contains(parameters('ipam')[copyIndex()],'virtualNetworks')]",
                        "type": "Microsoft.Network/virtualNetworks",
                        "apiVersion": "2020-05-01",
                        "name": "[concat(subscription().displayName, '-vnet')]",
                        "location": "[parameters('ipam')[copyIndex()].location]",
                        "dependsOn": [
                          "[concat(subscription().displayName, '-nsg')]",
                          "[concat(subscription().displayName, '-udr')]"
                        ],
                        "properties": "[if(contains(parameters('ipam')[copyIndex()],'virtualNetworks'),parameters('ipam')[copyIndex()].virtualNetworks.properties,json('null'))]"
                      },
                      {
                        "condition": "[contains(parameters('ipam')[copyIndex()],'virtualNetworkPeerings')]",
                        "type": "Microsoft.Network/virtualNetworks/virtualNetworkPeerings",
                        "apiVersion": "2020-05-01",
                        "name": "[concat(variables('vNetName'), '/peerToHub')]",
                        "dependsOn": [
                          "[concat(subscription().displayName, '-vnet')]"
                        ],
                        "properties": "[if(contains(parameters('ipam')[copyIndex()],'virtualNetworkPeerings'),parameters('ipam')[copyIndex()].virtualNetworkPeerings.properties,json('null'))]"
                      },
                      {
                        "condition": "[and(contains(parameters('ipam')[copyIndex()],'virtualNetworks'),contains(parameters('ipam')[copyIndex()],'hubVirtualNetworkConnection'),contains(parameters('ipam')[copyIndex()].hubVirtualNetworkConnection,'vWanVhubResourceId'))]",
                        "type": "Microsoft.Resources/deployments",
                        "apiVersion": "2020-06-01",
                        "name": "[concat('es-ipam-vWan-',subscription().displayName,'-peering-',copyIndex())]",
                        "subscriptionId": "[if(and(contains(parameters('ipam')[copyIndex()],'hubVirtualNetworkConnection'),contains(parameters('ipam')[copyIndex()].hubVirtualNetworkConnection,'vWanVhubResourceId')),split(parameters('ipam')[copyIndex()].hubVirtualNetworkConnection.vWanVhubResourceId,'/')[2],json('null'))]",
                        "resourceGroup": "[if(and(contains(parameters('ipam')[copyIndex()],'hubVirtualNetworkConnection'),contains(parameters('ipam')[copyIndex()].hubVirtualNetworkConnection,'vWanVhubResourceId')),split(parameters('ipam')[copyIndex()].hubVirtualNetworkConnection.vWanVhubResourceId,'/')[4],json('null'))]",
                        "dependsOn": [
                          "[concat(subscription().displayName, '-vnet')]"
                        ],
                        "properties": {
                          "mode": "Incremental",
                          "expressionEvaluationOptions": {
                            "scope": "inner"
                          },
                          "template": {
                            "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                            "contentVersion": "1.0.0.0",
                            "parameters": {
                              "remoteVirtualNetwork": {
                                "type": "string"
                              },
                              "vWanVhubName": {
                                "Type": "string",
                                "defaultValue": ""
                              },
                              "allowHubToRemoteVnetTransit": {
                                "Type": "bool",
                                "defaultValue": true
                              },
                              "allowRemoteVnetToUseHubVnetGateways": {
                                "Type": "bool",
                                "defaultValue": false
                              },
                              "enableInternetSecurity": {
                                "Type": "bool",
                                "defaultValue": true
                              }
                            },
                            "variables": {},
                            "resources": [
                              {
                                "type": "Microsoft.Network/virtualHubs/hubVirtualNetworkConnections",
                                "apiVersion": "2020-05-01",
                                "name": "[[concat(parameters('vWanVhubName'),'/',last(split(parameters('remoteVirtualNetwork'),'/')))]",
                                "properties": {
                                  "remoteVirtualNetwork": {
                                    "id": "[[parameters('remoteVirtualNetwork')]"
                                  },
                                  "allowHubToRemoteVnetTransit": "[[parameters('allowHubToRemoteVnetTransit')]",
                                  "allowRemoteVnetToUseHubVnetGateways": "[[parameters('allowRemoteVnetToUseHubVnetGateways')]",
                                  "enableInternetSecurity": "[[parameters('enableInternetSecurity')]"
                                }
                              }
                            ],
                            "outputs": {}
                          },
                          "parameters": {
                            "remoteVirtualNetwork": {
                              "value": "[concat(subscription().id,'/resourceGroups/',variables('vNetRgName'), '/providers/','Microsoft.Network/virtualNetworks/', concat(subscription().displayName, '-vnet'))]"
                            },
                            "vWanVhubName": {
                              "value": "[if(and(contains(parameters('ipam')[copyIndex()],'hubVirtualNetworkConnection'),contains(parameters('ipam')[copyIndex()].hubVirtualNetworkConnection,'vWanVhubResourceId')),split(parameters('ipam')[copyIndex()].hubVirtualNetworkConnection.vWanVhubResourceId,'/')[8],json('null'))]"
                            },
                            "allowHubToRemoteVnetTransit": {
                              "value": "[if(and(contains(parameters('ipam')[copyIndex()],'hubVirtualNetworkConnection'),contains(parameters('ipam')[copyIndex()].hubVirtualNetworkConnection,'vWanVhubResourceId')),parameters('ipam')[copyIndex()].hubVirtualNetworkConnection.properties.allowHubToRemoteVnetTransit,json('null'))]"
                            },
                            "allowRemoteVnetToUseHubVnetGateways": {
                              "value": "[if(and(contains(parameters('ipam')[copyIndex()],'hubVirtualNetworkConnection'),contains(parameters('ipam')[copyIndex()].hubVirtualNetworkConnection,'vWanVhubResourceId')),parameters('ipam')[copyIndex()].hubVirtualNetworkConnection.properties.allowRemoteVnetToUseHubVnetGateways,json('null'))]"
                            },
                            "enableInternetSecurity": {
                              "value": "[if(and(contains(parameters('ipam')[copyIndex()],'hubVirtualNetworkConnection'),contains(parameters('ipam')[copyIndex()].hubVirtualNetworkConnection,'vWanVhubResourceId')),parameters('ipam')[copyIndex()].hubVirtualNetworkConnection.properties.enableInternetSecurity,json('null'))]"
                            }
                          }
                        }
                      },
                      {
                        "condition": "[and(contains(parameters('ipam')[copyIndex()],'virtualNetworks'),contains(parameters('ipam')[copyIndex()],'virtualNetworkPeerings'),contains(parameters('ipam')[copyIndex()].virtualNetworkPeerings.properties.remoteVirtualNetwork,'id'))]",
                        "type": "Microsoft.Resources/deployments",
                        "apiVersion": "2020-06-01",
                        "name": "[concat('es-ipam-hub-',subscription().displayName,'-peering-',copyIndex())]",
                        "subscriptionId": "[if(and(contains(parameters('ipam')[copyIndex()],'virtualNetworkPeerings'),contains(parameters('ipam')[copyIndex()].virtualNetworkPeerings.properties.remoteVirtualNetwork,'id')),split(parameters('ipam')[copyIndex()].virtualNetworkPeerings.properties.remoteVirtualNetwork.id,'/')[2],json('null'))]",
                        "resourceGroup": "[if(and(contains(parameters('ipam')[copyIndex()],'virtualNetworkPeerings'),contains(parameters('ipam')[copyIndex()].virtualNetworkPeerings.properties.remoteVirtualNetwork,'id')),split(parameters('ipam')[copyIndex()].virtualNetworkPeerings.properties.remoteVirtualNetwork.id,'/')[4],json('null'))]",
                        "dependsOn": [
                          "[concat(subscription().displayName, '-vnet')]"
                        ],
                        "properties": {
                          "mode": "Incremental",
                          "expressionEvaluationOptions": {
                            "scope": "inner"
                          },
                          "template": {
                            "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                            "contentVersion": "1.0.0.0",
                            "parameters": {
                              "remoteVirtualNetwork": {
                                "Type": "string",
                                "defaultValue": false
                              },
                              "hubName": {
                                "Type": "string",
                                "defaultValue": false
                              }
                            },
                            "variables": {},
                            "resources": [
                              {
                                "type": "Microsoft.Network/virtualNetworks/virtualNetworkPeerings",
                                "name": "[[concat(parameters('hubName'),'/',last(split(parameters('remoteVirtualNetwork'),'/')))]",
                                "apiVersion": "2020-05-01",
                                "properties": {
                                  "allowVirtualNetworkAccess": true,
                                  "allowForwardedTraffic": true,
                                  "allowGatewayTransit": true,
                                  "useRemoteGateways": false,
                                  "remoteVirtualNetwork": {
                                    "id": "[[parameters('remoteVirtualNetwork')]"
                                  }
                                }
                              }
                            ],
                            "outputs": {}
                          },
                          "parameters": {
                            "remoteVirtualNetwork": {
                              "value": "[concat(subscription().id,'/resourceGroups/',variables('vNetRgName'), '/providers/','Microsoft.Network/virtualNetworks/', concat(subscription().displayName, '-vnet'))]"
                            },
                            "hubName": {
                              "value": "[if(and(contains(parameters('ipam')[copyIndex()],'virtualNetworkPeerings'),contains(parameters('ipam')[copyIndex()].virtualNetworkPeerings.properties.remoteVirtualNetwork,'id')),split(parameters('ipam')[copyIndex()].virtualNetworkPeerings.properties.remoteVirtualNetwork.id,'/')[8],json('null'))]"
                            }
                          }
                        }
                      }
                    ],
                    "outputs": {}
                  }
                },
                "resourceGroup": "[variables('vNetRgName')]",
                "copy": {
                  "name": "ipam-loop",
                  "count": "[length(parameters('ipam'))]"
                },
                "condition": "[if(and(not(empty(parameters('ipam'))), equals(toLower(parameters('ipam')[copyIndex()].name),toLower(variables('vNetName')))),bool('true'),bool('false'))]"
              }
            ],
            "outputs": {
              "ipam": {
                "condition": "[bool('true')]",
                "type": "Int",
                "value": "[length(parameters('ipam'))]"
              }
            }
          }
        }
      }
    }
  }
}
POLICYRULE

  parameters = <<PARAMETERS
{
  "ipam": {
    "type": "Array",
    "metadata": {
      "displayName": "ipam"
    },
    "defaultValue": []
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

output "policydefinition_deploy_vnet" {
  value = azurerm_policy_definition.deploy_vnet
}

