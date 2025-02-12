# This file was auto generated
resource "azurerm_policy_definition" "deploy_ddosprotection" {
  name         = "Deploy-DDoSProtection"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy an Azure DDoS Protection Standard plan"
  description  = "Deploys an Azure DDoS Protection Standard plan"

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
      "type": "Microsoft.Network/ddosProtectionPlans",
      "deploymentScope": "Subscription",
      "existenceScope": "ResourceGroup",
      "resourceGroupName": "[parameters('rgName')]",
      "name": "[parameters('ddosName')]",
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
            "ddosname": {
              "value": "[parameters('ddosname')]"
            },
            "ddosregion": {
              "value": "[parameters('ddosRegion')]"
            }
          },
          "template": {
            "$schema": "http://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "rgName": {
                "type": "string"
              },
              "ddosname": {
                "type": "string"
              },
              "ddosRegion": {
                "type": "string"
              }
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
                "name": "ddosprotection",
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
                        "type": "Microsoft.Network/ddosProtectionPlans",
                        "apiVersion": "2019-12-01",
                        "name": "[parameters('ddosName')]",
                        "location": "[parameters('ddosRegion')]",
                        "properties": {}
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
  "ddosName": {
    "type": "String",
    "metadata": {
      "displayName": "ddosName",
      "description": "Name of the Virtual WAN"
    }
  },
  "ddosRegion": {
    "type": "String",
    "metadata": {
      "displayName": "ddosRegion",
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

output "policydefinition_deploy_ddosprotection" {
  value = azurerm_policy_definition.deploy_ddosprotection
}

