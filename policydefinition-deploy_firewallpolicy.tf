# This file was auto generated
resource "azurerm_policy_definition" "deploy_firewallpolicy" {
  name         = "Deploy-FirewallPolicy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy Azure Firewall Manager policy in the subscription"
  description  = "Deploys Azure Firewall Manager policy in subscription where the policy is assigned."

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
      "type": "Microsoft.Network/firewallPolicies",
      "deploymentScope": "Subscription",
      "existenceScope": "ResourceGroup",
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
            "fwPolicy": {
              "value": "[parameters('fwPolicy')]"
            },
            "fwPolicyRegion": {
              "value": "[parameters('fwPolicyRegion')]"
            }
          },
          "template": {
            "$schema": "http://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "rgName": {
                "type": "string"
              },
              "fwPolicy": {
                "type": "object"
              },
              "fwPolicyRegion": {
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
                "name": "fwpolicies",
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
                    "variables": {},
                    "resources": [
                      {
                        "type": "Microsoft.Network/firewallPolicies",
                        "apiVersion": "2019-09-01",
                        "name": "[parameters('fwpolicy').firewallPolicyName]",
                        "location": "[parameters('fwpolicy').location]",
                        "dependsOn": [],
                        "tags": {},
                        "properties": {},
                        "resources": [
                          {
                            "type": "ruleGroups",
                            "apiVersion": "2019-09-01",
                            "name": "[parameters('fwpolicy').ruleGroups.name]",
                            "dependsOn": [
                              "[resourceId('Microsoft.Network/firewallPolicies',parameters('fwpolicy').firewallPolicyName)]"
                            ],
                            "properties": {
                              "priority": "[parameters('fwpolicy').ruleGroups.properties.priority]",
                              "rules": "[parameters('fwpolicy').ruleGroups.properties.rules]"
                            }
                          }
                        ]
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
  "fwpolicy": {
    "type": "Object",
    "metadata": {
      "displayName": "fwpolicy",
      "description": "Object describing Azure Firewall Policy"
    },
    "defaultValue": {}
  },
  "fwPolicyRegion": {
    "type": "String",
    "metadata": {
      "displayName": "fwPolicyRegion",
      "description": "Select Azure region for Azure Firewall Policy",
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

output "policydefinition_deploy_firewallpolicy" {
  value = azurerm_policy_definition.deploy_firewallpolicy
}

