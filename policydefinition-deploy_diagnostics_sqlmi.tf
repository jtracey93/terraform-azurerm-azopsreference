# This file was auto generated
resource "azurerm_policy_definition" "deploy_diagnostics_sqlmi" {
  name         = "Deploy-Diagnostics-SQLMI"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy Diagnostic Settings for SQL Managed Instances to Log Analytics workspace"
  description  = "Deploys the diagnostic settings for SQL Managed Instances to stream to a Log Analytics workspace when any SQL Managed Instances which is missing this diagnostic settings is created or updated. The policy wil set the diagnostic with all metrics and category enabled"

  management_group_name = var.management_group_name
  policy_rule           = <<POLICYRULE
{
  "if": {
    "field": "type",
    "equals": "Microsoft.Sql/managedInstances"
  },
  "then": {
    "effect": "[parameters('effect')]",
    "details": {
      "type": "Microsoft.Insights/diagnosticSettings",
      "name": "setByPolicy",
      "existenceCondition": {
        "allOf": [
          {
            "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
            "equals": "true"
          },
          {
            "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
            "equals": "[parameters('logAnalytics')]"
          }
        ]
      },
      "roleDefinitionIds": [
        "/providers/microsoft.authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa",
        "/providers/microsoft.authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293"
      ],
      "deployment": {
        "properties": {
          "mode": "incremental",
          "template": {
            "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "resourceName": {
                "type": "string"
              },
              "logAnalytics": {
                "type": "string"
              },
              "location": {
                "type": "string"
              },
              "profileName": {
                "type": "string"
              },
              "logsEnabled": {
                "type": "string"
              }
            },
            "variables": {},
            "resources": [
              {
                "type": "Microsoft.Sql/managedInstances/providers/diagnosticSettings",
                "apiVersion": "2017-05-01-preview",
                "name": "[concat(parameters('resourceName'), '/', 'Microsoft.Insights/', parameters('profileName'))]",
                "location": "[parameters('location')]",
                "dependsOn": [],
                "properties": {
                  "workspaceId": "[parameters('logAnalytics')]",
                  "logs": [
                    {
                      "category": "ResourceUsageStats",
                      "enabled": "[parameters('logsEnabled')]"
                    },
                    {
                      "category": "SQLSecurityAuditEvents",
                      "enabled": "[parameters('logsEnabled')]"
                    },
                    {
                      "category": "DevOpsOperationsAudit",
                      "enabled": "[parameters('logsEnabled')]"
                    }
                  ]
                }
              }
            ],
            "outputs": {}
          },
          "parameters": {
            "logAnalytics": {
              "value": "[parameters('logAnalytics')]"
            },
            "location": {
              "value": "[field('location')]"
            },
            "resourceName": {
              "value": "[field('name')]"
            },
            "profileName": {
              "value": "[parameters('profileName')]"
            },
            "logsEnabled": {
              "value": "[parameters('logsEnabled')]"
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
  "logAnalytics": {
    "type": "String",
    "metadata": {
      "displayName": "Log Analytics workspace",
      "description": "Select Log Analytics workspace from dropdown list. If this workspace is outside of the scope of the assignment you must manually grant 'Log Analytics Contributor' permissions (or similar) to the policy assignment's principal ID.",
      "strongType": "omsWorkspace"
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
  },
  "profileName": {
    "type": "String",
    "metadata": {
      "displayName": "Profile name",
      "description": "The diagnostic settings profile name"
    },
    "defaultValue": "setbypolicy"
  },
  "logsEnabled": {
    "type": "String",
    "metadata": {
      "displayName": "Enable logs",
      "description": "Whether to enable logs stream to the Log Analytics workspace - True or False"
    },
    "allowedValues": [
      "True",
      "False"
    ],
    "defaultValue": "True"
  }
}
PARAMETERS

}

output "policydefinition_deploy_diagnostics_sqlmi" {
  value = azurerm_policy_definition.deploy_diagnostics_sqlmi
}

