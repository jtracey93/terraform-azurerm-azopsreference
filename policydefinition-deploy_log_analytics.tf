# This file was auto generated
resource "azurerm_policy_definition" "deploy_log_analytics" {
  name         = "Deploy-Log-Analytics"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy the Log Analytics in the subscription"
  description  = "Deploys Log Analytics and Automation account to the subscription where the policy is assigned."

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
      "type": "Microsoft.OperationalInsights/workspaces",
      "deploymentScope": "Subscription",
      "existenceScope": "Subscription",
      "roleDefinitionIds": [
        "/providers/microsoft.authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa",
        "/providers/microsoft.authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293"
      ],
      "existenceCondition": {
        "allOf": [
          {
            "field": "name",
            "like": "[parameters('workspaceName')]"
          }
        ]
      },
      "deployment": {
        "location": "northeurope",
        "properties": {
          "mode": "incremental",
          "parameters": {
            "rgName": {
              "value": "[parameters('rgName')]"
            },
            "retentionInDays": {
              "value": "[parameters('retentionInDays')]"
            },
            "workspaceName": {
              "value": "[parameters('workspaceName')]"
            },
            "workspaceRegion": {
              "value": "[parameters('workspaceRegion')]"
            },
            "automationAccountName": {
              "value": "[parameters('automationAccountName')]"
            },
            "automationRegion": {
              "value": "[parameters('automationRegion')]"
            }
          },
          "template": {
            "$schema": "http://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "rgName": {
                "type": "string"
              },
              "workspaceName": {
                "type": "string"
              },
              "workspaceRegion": {
                "type": "string"
              },
              "automationAccountName": {
                "type": "string"
              },
              "automationRegion": {
                "type": "string"
              },
              "retentionInDays": {
                "type": "string"
              }
            },
            "variables": {},
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
                "name": "log-analytics",
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
                        "apiversion": "2015-10-31",
                        "location": "[parameters('AutomationRegion')]",
                        "name": "[parameters('AutomationAccountName')]",
                        "type": "Microsoft.Automation/automationAccounts",
                        "comments": "Automation account for ",
                        "properties": {
                          "sku": {
                            "name": "OMS"
                          }
                        }
                      },
                      {
                        "apiVersion": "2017-03-15-preview",
                        "location": "[parameters('workspaceRegion')]",
                        "name": "[parameters('workspaceName')]",
                        "type": "Microsoft.OperationalInsights/workspaces",
                        "properties": {
                          "sku": {
                            "name": "pernode"
                          },
                          "enableLogAccessUsingOnlyResourcePermissions": true,
                          "retentionInDays": "[int(parameters('retentionInDays'))]"
                        },
                        "resources": [
                          {
                            "name": "Automation",
                            "type": "linkedServices",
                            "apiVersion": "2015-11-01-preview",
                            "dependsOn": [
                              "[resourceId('Microsoft.OperationalInsights/workspaces/', parameters('workspaceName'))]",
                              "[resourceId('Microsoft.Automation/automationAccounts/', parameters('AutomationAccountName'))]"
                            ],
                            "properties": {
                              "resourceId": "[concat(subscription().id, '/resourceGroups/', parameters('rgName'), '/providers/Microsoft.Automation/automationAccounts/', parameters('AutomationAccountName'))]"
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
  "workspaceName": {
    "type": "String",
    "metadata": {
      "displayName": "workspaceName",
      "description": "Provide name for log analytics workspace"
    }
  },
  "automationAccountName": {
    "type": "String",
    "metadata": {
      "displayName": "automationAccountName",
      "description": "Provide name for automation account"
    }
  },
  "workspaceRegion": {
    "type": "String",
    "metadata": {
      "displayName": "workspaceRegion",
      "description": "Select Azure region for Log Analytics"
    }
  },
  "automationRegion": {
    "type": "String",
    "metadata": {
      "displayName": "automationRegion",
      "description": "Select Azure region for Automation account"
    }
  },
  "retentionInDays": {
    "type": "String",
    "metadata": {
      "displayName": "Data retention",
      "description": "Select data retention (days) for Log Analytics."
    },
    "defaultValue": "30"
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

output "policydefinition_deploy_log_analytics" {
  value = azurerm_policy_definition.deploy_log_analytics
}

