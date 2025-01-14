# This file was auto generated
resource "azurerm_policy_definition" "deploy_vwan" {
  name         = "Deploy-vWAN"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy the Virtual WAN in the specific region"
  description  = "Deploy the Virtual WAN in the specific region."

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
      "type": "Microsoft.Network/virtualWans",
      "deploymentScope": "Subscription",
      "existenceScope": "ResourceGroup",
      "name": "[parameters('vwanname')]",
      "resourceGroupName": "[parameters('rgName')]",
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
            "vwanname": {
              "value": "[parameters('vwanname')]"
            },
            "vwanRegion": {
              "value": "[parameters('vwanRegion')]"
            }
          },
          "template": {
            "$schema": "http://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "rgName": {
                "type": "string"
              },
              "vwanname": {
                "type": "string"
              },
              "vwanRegion": {
                "type": "string"
              }
            },
            "variables": {
              "vwansku": "Standard"
            },
            "resources": [
              {
                "type": "Microsoft.Resources/resourceGroups",
                "apiVersion": "2018-05-01",
                "name": "[parameters('rgName')]",
                "location": "[deployment().location]",
                "properties": {}
              },
              {
                "type": "Microsoft.Resources/deployments",
                "apiVersion": "2018-05-01",
                "name": "vwan",
                "resourceGroup": "[parameters('rgName')]",
                "dependsOn": [
                  "[resourceId('Microsoft.Resources/resourceGroups/', parameters('rgName'))]"
                ],
                "properties": {
                  "mode": "Incremental",
                  "template": {
                    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json",
                    "contentVersion": "1.0.0.0",
                    "parameters": {},
                    "resources": [
                      {
                        "type": "Microsoft.Network/virtualWans",
                        "apiVersion": "2020-05-01",
                        "location": "[parameters('vwanRegion')]",
                        "name": "[parameters('vwanname')]",
                        "properties": {
                          "virtualHubs": [],
                          "vpnSites": [],
                          "type": "[variables('vwansku')]"
                        }
                      }
                    ],
                    "outputs": {}
                  }
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
  "vwanname": {
    "type": "String",
    "metadata": {
      "displayName": "vwanname",
      "description": "Name of the Virtual WAN"
    }
  },
  "vwanRegion": {
    "type": "String",
    "metadata": {
      "displayName": "vwanRegion",
      "description": "Select Azure region for Virtual WAN",
      "strongType": "location"
    }
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

output "policydefinition_deploy_vwan" {
  value = azurerm_policy_definition.deploy_vwan
}

