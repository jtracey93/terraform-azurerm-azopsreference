# This file was auto generated
resource "azurerm_policy_definition" "deploy_vnet_hubspoke" {
  name         = "Deploy-VNET-HubSpoke"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploys virtual network with peering to hub"
  description  = "This policy deploys virtual network and peer to the hub"

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
    "effect": "deployIfNotExists",
    "details": {
      "type": "Microsoft.Network/virtualNetworks",
      "name": "[parameters('vNetName')]",
      "deploymentScope": "Subscription",
      "existenceScope": "ResourceGroup",
      "ResourceGroupName": "[parameters('vNetRgName')]",
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
      ],
      "existenceCondition": {
        "allOf": [
          {
            "field": "name",
            "like": "[parameters('vNetName')]"
          },
          {
            "field": "location",
            "equals": "[parameters('vNetLocation')]"
          }
        ]
      },
      "deployment": {
        "location": "northeurope",
        "properties": {
          "mode": "incremental",
          "parameters": {
            "vNetRgName": {
              "value": "[parameters('vNetRgName')]"
            },
            "vNetName": {
              "value": "[parameters('vNetName')]"
            },
            "vNetLocation": {
              "value": "[parameters('vNetLocation')]"
            },
            "vNetCidrRange": {
              "value": "[parameters('vNetCidrRange')]"
            },
            "hubResourceId": {
              "value": "[parameters('hubResourceId')]"
            }
          },
          "template": {
            "$schema": "http://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "vNetRgName": {
                "type": "string"
              },
              "vNetName": {
                "type": "string"
              },
              "vNetLocation": {
                "type": "string"
              },
              "vNetCidrRange": {
                "type": "string"
              },
              "vNetPeerUseRemoteGateway": {
                "type": "bool",
                "defaultValue": false
              },
              "hubResourceId": {
                "type": "string"
              }
            },
            "variables": {},
            "resources": [
              {
                "type": "Microsoft.Resources/deployments",
                "apiVersion": "2020-06-01",
                "name": "[concat('es-lz-vnet-',substring(uniqueString(subscription().id),0,6),'-rg')]",
                "location": "[parameters('vNetLocation')]",
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
                        "name": "[parameters('vNetRgName')]",
                        "location": "[parameters('vNetLocation')]",
                        "properties": {}
                      },
                      {
                        "type": "Microsoft.Resources/resourceGroups",
                        "apiVersion": "2020-06-01",
                        "name": "NetworkWatcherRG",
                        "location": "[parameters('vNetLocation')]",
                        "properties": {}
                      }
                    ],
                    "outputs": {}
                  }
                }
              },
              {
                "type": "Microsoft.Resources/deployments",
                "apiVersion": "2020-06-01",
                "name": "[concat('es-lz-vnet-',substring(uniqueString(subscription().id),0,6))]",
                "dependsOn": [
                  "[concat('es-lz-vnet-',substring(uniqueString(subscription().id),0,6),'-rg')]"
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
                        "type": "Microsoft.Network/virtualNetworks",
                        "apiVersion": "2020-06-01",
                        "name": "[parameters('vNetName')]",
                        "location": "[parameters('vNetLocation')]",
                        "dependsOn": [],
                        "properties": {
                          "addressSpace": {
                            "addressPrefixes": [
                              "[parameters('vNetCidrRange')]"
                            ]
                          }
                        }
                      },
                      {
                        "type": "Microsoft.Network/virtualNetworks/virtualNetworkPeerings",
                        "apiVersion": "2020-05-01",
                        "name": "[concat(parameters('vNetName'), '/peerToHub')]",
                        "dependsOn": [
                          "[parameters('vNetName')]"
                        ],
                        "properties": {
                          "remoteVirtualNetwork": {
                            "id": "[parameters('hubResourceId')]"
                          },
                          "allowVirtualNetworkAccess": true,
                          "allowForwardedTraffic": true,
                          "allowGatewayTransit": false,
                          "useRemoteGateways": "[parameters('vNetPeerUseRemoteGateway')]"
                        }
                      },
                      {
                        "type": "Microsoft.Resources/deployments",
                        "apiVersion": "2020-06-01",
                        "name": "[concat('es-lz-hub-',substring(uniqueString(subscription().id),0,6),'-peering')]",
                        "subscriptionId": "[split(parameters('hubResourceId'),'/')[2]]",
                        "resourceGroup": "[split(parameters('hubResourceId'),'/')[4]]",
                        "dependsOn": [
                          "[parameters('vNetName')]"
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
                              "value": "[concat(subscription().id,'/resourceGroups/',parameters('vNetRgName'), '/providers/','Microsoft.Network/virtualNetworks/', parameters('vNetName'))]"
                            },
                            "hubName": {
                              "value": "[split(parameters('hubResourceId'),'/')[8]]"
                            }
                          }
                        }
                      }
                    ],
                    "outputs": {}
                  }
                },
                "resourceGroup": "[parameters('vNetRgName')]"
              }
            ],
            "outputs": {}
          }
        }
      }
    }
  }
}
POLICYRULE

  parameters = <<PARAMETERS
{
  "vNetName": {
    "type": "String",
    "metadata": {
      "displayName": "vNetName",
      "description": "Name of the landing zone vNet"
    }
  },
  "vNetRgName": {
    "type": "String",
    "metadata": {
      "displayName": "vNetRgName",
      "description": "Name of the landing zone vNet RG"
    }
  },
  "vNetLocation": {
    "type": "String",
    "metadata": {
      "displayName": "vNetLocation",
      "description": "Location for the vNet"
    }
  },
  "vNetCidrRange": {
    "type": "String",
    "metadata": {
      "displayName": "vNetCidrRange",
      "description": "CIDR Range for the vNet"
    }
  },
  "hubResourceId": {
    "type": "String",
    "metadata": {
      "displayName": "hubResourceId",
      "description": "Resource ID for the HUB vNet"
    }
  }
}
PARAMETERS

}

output "policydefinition_deploy_vnet_hubspoke" {
  value = azurerm_policy_definition.deploy_vnet_hubspoke
}

