# This file was auto generated
resource "azurerm_policy_definition" "deploy_budget" {
  name         = "Deploy-Budget"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy budet"
  description  = "Depoloys a default budget on all subscriptions under the assigned scope."

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
    "effect": "DeployIfNotExists",
    "details": {
      "type": "Microsoft.Consumption/budgets",
      "deploymentScope": "Subscription",
      "existenceScope": "Subscription",
      "existenceCondition": {
        "allOf": [
          {
            "field": "Microsoft.Consumption/budgets/amount",
            "equals": "[parameters('amount')]"
          },
          {
            "field": "Microsoft.Consumption/budgets/timeGrain",
            "equals": "[parameters('timeGrain')]"
          },
          {
            "field": "Microsoft.Consumption/budgets/category",
            "equals": "Cost"
          }
        ]
      },
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
      ],
      "deployment": {
        "location": "northeurope",
        "properties": {
          "mode": "incremental",
          "parameters": {
            "amount": {
              "value": "[parameters('amount')]"
            },
            "timeGrain": {
              "value": "[parameters('timeGrain')]"
            },
            "firstThreshold": {
              "value": "[parameters('firstThreshold')]"
            },
            "secondThreshold": {
              "value": "[parameters('secondThreshold')]"
            },
            "contactEmails": {
              "value": "[parameters('contactEmails')]"
            },
            "contactRoles": {
              "value": "[parameters('contactRoles')]"
            },
            "contactGroups": {
              "value": "[parameters('contactGroups')]"
            }
          },
          "template": {
            "$schema": "http://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "amount": {
                "type": "string"
              },
              "timeGrain": {
                "type": "string"
              },
              "firstThreshold": {
                "type": "string"
              },
              "secondThreshold": {
                "type": "string"
              },
              "contactEmails": {
                "type": "array"
              },
              "contactRoles": {
                "type": "array"
              },
              "contactGroups": {
                "type": "array"
              },
              "startDate": {
                "type": "string",
                "defaultValue": "[concat(utcNow('MM'), '/01/', utcNow('yyyy'))]"
              }
            },
            "resources": [
              {
                "type": "Microsoft.Consumption/budgets",
                "apiVersion": "2019-10-01",
                "name": "default-sandbox-budget",
                "properties": {
                  "timePeriod": {
                    "startDate": "[parameters('startDate')]"
                  },
                  "timeGrain": "[parameters('timeGrain')]",
                  "amount": "[parameters('amount')]",
                  "category": "Cost",
                  "notifications": {
                    "NotificationForExceededBudget1": {
                      "enabled": true,
                      "operator": "GreaterThan",
                      "threshold": "[parameters('firstThreshold')]",
                      "contactEmails": "[parameters('contactEmails')]",
                      "contactRoles": "[parameters('contactRoles')]",
                      "contactGroups": "[parameters('contactGroups')]"
                    },
                    "NotificationForExceededBudget2": {
                      "enabled": true,
                      "operator": "GreaterThan",
                      "threshold": "[parameters('secondThreshold')]",
                      "contactEmails": "[parameters('contactEmails')]",
                      "contactRoles": "[parameters('contactRoles')]",
                      "contactGroups": "[parameters('contactGroups')]"
                    }
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
  "amount": {
    "type": "String",
    "metadata": {
      "description": "The total amount of cost or usage to track with the budget"
    },
    "defaultValue": "1000"
  },
  "timeGrain": {
    "type": "String",
    "metadata": {
      "description": "The time covered by a budget. Tracking of the amount will be reset based on the time grain."
    },
    "allowedValues": [
      "Monthly",
      "Quarterly",
      "Annually",
      "BillingMonth",
      "BillingQuarter",
      "BillingAnnual"
    ],
    "defaultValue": "Monthly"
  },
  "firstThreshold": {
    "type": "String",
    "metadata": {
      "description": "Threshold value associated with a notification. Notification is sent when the cost exceeded the threshold. It is always percent and has to be between 0 and 1000."
    },
    "defaultValue": "90"
  },
  "secondThreshold": {
    "type": "String",
    "metadata": {
      "description": "Threshold value associated with a notification. Notification is sent when the cost exceeded the threshold. It is always percent and has to be between 0 and 1000."
    },
    "defaultValue": "100"
  },
  "contactRoles": {
    "type": "Array",
    "metadata": {
      "description": "The list of contact RBAC roles, in an array, to send the budget notification to when the threshold is exceeded."
    },
    "defaultValue": [
      "Owner",
      "Contributor"
    ]
  },
  "contactEmails": {
    "type": "Array",
    "metadata": {
      "description": "The list of email addresses, in an array, to send the budget notification to when the threshold is exceeded."
    },
    "defaultValue": []
  },
  "contactGroups": {
    "type": "Array",
    "metadata": {
      "description": "The list of action groups, in an array, to send the budget notification to when the threshold is exceeded. It accepts array of strings."
    },
    "defaultValue": []
  }
}
PARAMETERS

}

output "policydefinition_deploy_budget" {
  value = azurerm_policy_definition.deploy_budget
}

