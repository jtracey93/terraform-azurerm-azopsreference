# This file was auto generated
resource "azurerm_policy_definition" "deploy_asc_standard" {
  name         = "Deploy-ASC-Standard"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy Azure Defender settings in Azure Security Center."
  description  = "Deploys the Azure Defender settings in Azure Security Center for the specific services."

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
      "type": "Microsoft.Security/pricings",
      "deploymentScope": "subscription",
      "existenceScope": "subscription",
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
      ],
      "existenceCondition": {
        "allOf": [
          {
            "field": "Microsoft.Security/pricings/pricingTier",
            "equals": "Standard"
          },
          {
            "field": "type",
            "equals": "Microsoft.Security/pricings"
          }
        ]
      },
      "deployment": {
        "location": "northeurope",
        "properties": {
          "mode": "incremental",
          "parameters": {
            "pricingTierVMs": {
              "value": "[parameters('pricingTierVMs')]"
            },
            "pricingTierSqlServers": {
              "value": "[parameters('pricingTierSqlServers')]"
            },
            "pricingTierAppServices": {
              "value": "[parameters('pricingTierAppServices')]"
            },
            "pricingTierStorageAccounts": {
              "value": "[parameters('pricingTierStorageAccounts')]"
            },
            "pricingTierContainerRegistry": {
              "value": "[parameters('pricingTierContainerRegistry')]"
            },
            "pricingTierKeyVaults": {
              "value": "[parameters('pricingTierKeyVaults')]"
            },
            "pricingTierKubernetesService": {
              "value": "[parameters('pricingTierKubernetesService')]"
            }
          },
          "template": {
            "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "pricingTierVMs": {
                "type": "string",
                "metadata": {
                  "description": "pricingTierVMs"
                }
              },
              "pricingTierSqlServers": {
                "type": "string",
                "metadata": {
                  "description": "pricingTierSqlServers"
                }
              },
              "pricingTierAppServices": {
                "type": "string",
                "metadata": {
                  "description": "pricingTierAppServices"
                }
              },
              "pricingTierStorageAccounts": {
                "type": "string",
                "metadata": {
                  "description": "pricingTierStorageAccounts"
                }
              },
              "pricingTierContainerRegistry": {
                "type": "string",
                "metadata": {
                  "description": "ContainerRegistry"
                }
              },
              "pricingTierKeyVaults": {
                "type": "string",
                "metadata": {
                  "description": "KeyVaults"
                }
              },
              "pricingTierKubernetesService": {
                "type": "string",
                "metadata": {
                  "description": "KubernetesService"
                }
              }
            },
            "variables": {},
            "resources": [
              {
                "type": "Microsoft.Security/pricings",
                "apiVersion": "2018-06-01",
                "name": "VirtualMachines",
                "properties": {
                  "pricingTier": "[parameters('pricingTierVMs')]"
                }
              },
              {
                "type": "Microsoft.Security/pricings",
                "apiVersion": "2018-06-01",
                "name": "StorageAccounts",
                "dependsOn": [
                  "[concat('Microsoft.Security/pricings/VirtualMachines')]"
                ],
                "properties": {
                  "pricingTier": "[parameters('pricingTierStorageAccounts')]"
                }
              },
              {
                "type": "Microsoft.Security/pricings",
                "apiVersion": "2018-06-01",
                "name": "AppServices",
                "dependsOn": [
                  "[concat('Microsoft.Security/pricings/StorageAccounts')]"
                ],
                "properties": {
                  "pricingTier": "[parameters('pricingTierAppServices')]"
                }
              },
              {
                "type": "Microsoft.Security/pricings",
                "apiVersion": "2018-06-01",
                "name": "SqlServers",
                "dependsOn": [
                  "[concat('Microsoft.Security/pricings/AppServices')]"
                ],
                "properties": {
                  "pricingTier": "[parameters('pricingTierSqlServers')]"
                }
              },
              {
                "type": "Microsoft.Security/pricings",
                "apiVersion": "2018-06-01",
                "name": "KeyVaults",
                "dependsOn": [
                  "[concat('Microsoft.Security/pricings/SqlServers')]"
                ],
                "properties": {
                  "pricingTier": "[parameters('pricingTierKeyVaults')]"
                }
              },
              {
                "type": "Microsoft.Security/pricings",
                "apiVersion": "2018-06-01",
                "name": "KubernetesService",
                "dependsOn": [
                  "[concat('Microsoft.Security/pricings/KeyVaults')]"
                ],
                "properties": {
                  "pricingTier": "[parameters('pricingTierKubernetesService')]"
                }
              },
              {
                "type": "Microsoft.Security/pricings",
                "apiVersion": "2018-06-01",
                "name": "ContainerRegistry",
                "dependsOn": [
                  "[concat('Microsoft.Security/pricings/KubernetesService')]"
                ],
                "properties": {
                  "pricingTier": "[parameters('pricingTierContainerRegistry')]"
                }
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
  "pricingTierVMs": {
    "type": "String",
    "metadata": {
      "displayName": "pricingTierVMs"
    },
    "allowedValues": [
      "Standard",
      "Free"
    ],
    "defaultValue": "Standard"
  },
  "pricingTierSqlServers": {
    "type": "String",
    "metadata": {
      "displayName": "pricingTierSqlServers"
    },
    "allowedValues": [
      "Standard",
      "Free"
    ],
    "defaultValue": "Standard"
  },
  "pricingTierAppServices": {
    "type": "String",
    "metadata": {
      "displayName": "pricingTierAppServices"
    },
    "allowedValues": [
      "Standard",
      "Free"
    ],
    "defaultValue": "Standard"
  },
  "pricingTierStorageAccounts": {
    "type": "String",
    "metadata": {
      "displayName": "pricingTierStorageAccounts"
    },
    "allowedValues": [
      "Standard",
      "Free"
    ],
    "defaultValue": "Standard"
  },
  "pricingTierContainerRegistry": {
    "type": "String",
    "metadata": {
      "displayName": "pricingTierContainerRegistry"
    },
    "allowedValues": [
      "Standard",
      "Free"
    ],
    "defaultValue": "Standard"
  },
  "pricingTierKeyVaults": {
    "type": "String",
    "metadata": {
      "displayName": "pricingTierKeyVaults"
    },
    "allowedValues": [
      "Standard",
      "Free"
    ],
    "defaultValue": "Standard"
  },
  "pricingTierKubernetesService": {
    "type": "String",
    "metadata": {
      "displayName": "pricingTierKubernetesService"
    },
    "allowedValues": [
      "Standard",
      "Free"
    ],
    "defaultValue": "Standard"
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

output "policydefinition_deploy_asc_standard" {
  value = azurerm_policy_definition.deploy_asc_standard
}

