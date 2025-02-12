# This file was auto generated
resource "azurerm_policy_definition" "deploy_la_config" {
  name         = "Deploy-LA-Config"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy the configurations to the Log Analytics in the subscription"
  description  = "Deploy the configurations to the Log Analytics in the subscription. This includes a list of solutions like update, automation etc and enables the vminsight counters. "

  management_group_name = var.management_group_name
  policy_rule           = <<POLICYRULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.OperationalInsights/workspaces"
      }
    ]
  },
  "then": {
    "effect": "[parameters('effect')]",
    "details": {
      "type": "Microsoft.OperationalInsights/workspaces",
      "deploymentScope": "resourceGroup",
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
          },
          {
            "field": "location",
            "equals": "[parameters('workspaceRegion')]"
          }
        ]
      },
      "deployment": {
        "properties": {
          "mode": "incremental",
          "parameters": {
            "workspaceName": {
              "value": "[parameters('workspaceName')]"
            },
            "workspaceRegion": {
              "value": "[parameters('workspaceRegion')]"
            }
          },
          "template": {
            "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "workspaceName": {
                "type": "string"
              },
              "workspaceRegion": {
                "type": "string"
              }
            },
            "variables": {
              "vmInsightsPerfCounters": {
                "windowsArray": [
                  {
                    "armName": "counter1",
                    "objectName": "LogicalDisk",
                    "counterName": "% Free Space",
                    "instanceName": "*",
                    "intervalSeconds": 10
                  },
                  {
                    "armName": "counter2",
                    "objectName": "LogicalDisk",
                    "counterName": "Avg. Disk sec/Read",
                    "instanceName": "*",
                    "intervalSeconds": 10
                  },
                  {
                    "armName": "counter3",
                    "objectName": "LogicalDisk",
                    "counterName": "Avg. Disk sec/Transfer",
                    "instanceName": "*",
                    "intervalSeconds": 10
                  },
                  {
                    "armName": "counter4",
                    "objectName": "LogicalDisk",
                    "counterName": "Avg. Disk sec/Write",
                    "instanceName": "*",
                    "intervalSeconds": 10
                  },
                  {
                    "armName": "counter5",
                    "objectName": "LogicalDisk",
                    "counterName": "Disk Read Bytes/sec",
                    "instanceName": "*",
                    "intervalSeconds": 10
                  },
                  {
                    "armName": "counter6",
                    "objectName": "LogicalDisk",
                    "counterName": "Disk Reads/sec",
                    "instanceName": "*",
                    "intervalSeconds": 10
                  },
                  {
                    "armName": "counter7",
                    "objectName": "LogicalDisk",
                    "counterName": "Disk Transfers/sec",
                    "instanceName": "*",
                    "intervalSeconds": 10
                  },
                  {
                    "armName": "counter8",
                    "objectName": "LogicalDisk",
                    "counterName": "Disk Write Bytes/sec",
                    "instanceName": "*",
                    "intervalSeconds": 10
                  },
                  {
                    "armName": "counter9",
                    "objectName": "LogicalDisk",
                    "counterName": "Disk Writes/sec",
                    "instanceName": "*",
                    "intervalSeconds": 10
                  },
                  {
                    "armName": "counter10",
                    "objectName": "LogicalDisk",
                    "counterName": "Free Megabytes",
                    "instanceName": "*",
                    "intervalSeconds": 10
                  },
                  {
                    "armName": "counter11",
                    "objectName": "Memory",
                    "counterName": "Available MBytes",
                    "instanceName": "*",
                    "intervalSeconds": 10
                  },
                  {
                    "armName": "counter12",
                    "objectName": "Network Adapter",
                    "counterName": "Bytes Received/sec",
                    "instanceName": "*",
                    "intervalSeconds": 10
                  },
                  {
                    "armName": "counter13",
                    "objectName": "Network Adapter",
                    "counterName": "Bytes Sent/sec",
                    "instanceName": "*",
                    "intervalSeconds": 10
                  },
                  {
                    "armName": "counter14",
                    "objectName": "Processor",
                    "counterName": "% Processor Time",
                    "instanceName": "*",
                    "intervalSeconds": 10
                  }
                ],
                "linuxDiskArray": [
                  {
                    "counterName": "% Used Inodes"
                  },
                  {
                    "counterName": "Free Megabytes"
                  },
                  {
                    "counterName": "% Used Space"
                  },
                  {
                    "counterName": "Disk Transfers/sec"
                  },
                  {
                    "counterName": "Disk Reads/sec"
                  },
                  {
                    "counterName": "Disk writes/sec"
                  }
                ],
                "linuxDiskObject": {
                  "armResourceName": "Disk",
                  "objectName": "Logical Disk",
                  "instanceName": "*",
                  "intervalSeconds": 10
                },
                "linuxMemoryArray": [
                  {
                    "counterName": "Available MBytes Memory"
                  }
                ],
                "linuxMemoryObject": {
                  "armResourceName": "Memory",
                  "objectName": "Memory",
                  "instanceName": "*",
                  "intervalSeconds": 10
                },
                "linuxNetworkArray": [
                  {
                    "counterName": "Total Bytes Received"
                  },
                  {
                    "counterName": "Total Bytes Transmitted"
                  }
                ],
                "linuxNetworkObject": {
                  "armResourceName": "Network",
                  "objectName": "Network",
                  "instanceName": "*",
                  "intervalSeconds": 10
                },
                "linuxCpuArray": [
                  {
                    "counterName": "% Processor Time"
                  }
                ],
                "linuxCpuObject": {
                  "armResourceName": "Processor",
                  "objectName": "Processor",
                  "instanceName": "*",
                  "intervalSeconds": 10
                }
              },
              "batch1": {
                "solutions": [
                  {
                    "name": "[concat('Security', '(', parameters('workspaceName'), ')')]",
                    "marketplaceName": "Security"
                  },
                  {
                    "name": "[concat('AgentHealthAssessment', '(', parameters('workspaceName'), ')')]",
                    "marketplaceName": "AgentHealthAssessment"
                  },
                  {
                    "name": "[concat('ChangeTracking', '(', parameters('workspaceName'), ')')]",
                    "marketplaceName": "ChangeTracking"
                  },
                  {
                    "name": "[concat('Updates', '(', parameters('workspaceName'), ')')]",
                    "marketplaceName": "Updates"
                  },
                  {
                    "name": "[concat('AzureActivity', '(', parameters('workspaceName'), ')')]",
                    "marketplaceName": "AzureActivity"
                  },
                  {
                    "name": "[concat('AzureAutomation', '(', parameters('workspaceName'), ')')]",
                    "marketplaceName": "AzureAutomation"
                  },
                  {
                    "name": "[concat('ADAssessment', '(', parameters('workspaceName'), ')')]",
                    "marketplaceName": "ADAssessment"
                  },
                  {
                    "name": "[concat('SQLAssessment', '(', parameters('workspaceName'), ')')]",
                    "marketplaceName": "SQLAssessment"
                  },
                  {
                    "name": "[concat('VMInsights', '(', parameters('workspaceName'), ')')]",
                    "marketplaceName": "VMInsights"
                  },
                  {
                    "name": "[concat('ServiceMap', '(', parameters('workspaceName'), ')')]",
                    "marketplaceName": "ServiceMap"
                  },
                  {
                    "name": "[concat('SecurityInsights', '(', parameters('workspaceName'), ')')]",
                    "marketplaceName": "SecurityInsights"
                  }
                ]
              }
            },
            "resources": [
              {
                "apiVersion": "2015-11-01-preview",
                "type": "Microsoft.OperationalInsights/workspaces/datasources",
                "name": "[concat(parameters('workspaceName'), '/LinuxPerfCollection')]",
                "kind": "LinuxPerformanceCollection",
                "properties": {
                  "state": "Enabled"
                }
              },
              {
                "apiVersion": "2015-11-01-preview",
                "type": "Microsoft.OperationalInsights/workspaces/dataSources",
                "name": "[concat(parameters('workspaceName'), '/', variables('vmInsightsPerfCounters').linuxDiskObject.armResourceName)]",
                "kind": "LinuxPerformanceObject",
                "properties": {
                  "performanceCounters": "[variables('vmInsightsPerfCounters').linuxDiskArray]",
                  "objectName": "[variables('vmInsightsPerfCounters').linuxDiskObject.objectName]",
                  "instanceName": "[variables('vmInsightsPerfCounters').linuxDiskObject.instanceName]",
                  "intervalSeconds": "[variables('vmInsightsPerfCounters').linuxDiskObject.intervalSeconds]"
                }
              },
              {
                "apiVersion": "2015-11-01-preview",
                "type": "Microsoft.OperationalInsights/workspaces/dataSources",
                "name": "[concat(parameters('workspaceName'), '/', variables('vmInsightsPerfCounters').linuxMemoryObject.armResourceName)]",
                "kind": "LinuxPerformanceObject",
                "properties": {
                  "performanceCounters": "[variables('vmInsightsPerfCounters').linuxMemoryArray]",
                  "objectName": "[variables('vmInsightsPerfCounters').linuxMemoryObject.objectName]",
                  "instanceName": "[variables('vmInsightsPerfCounters').linuxMemoryObject.instanceName]",
                  "intervalSeconds": "[variables('vmInsightsPerfCounters').linuxMemoryObject.intervalSeconds]"
                }
              },
              {
                "apiVersion": "2015-11-01-preview",
                "type": "Microsoft.OperationalInsights/workspaces/dataSources",
                "name": "[concat(parameters('workspaceName'), '/', variables('vmInsightsPerfCounters').linuxCpuObject.armResourceName)]",
                "kind": "LinuxPerformanceObject",
                "properties": {
                  "performanceCounters": "[variables('vmInsightsPerfCounters').linuxCpuArray]",
                  "objectName": "[variables('vmInsightsPerfCounters').linuxCpuObject.objectName]",
                  "instanceName": "[variables('vmInsightsPerfCounters').linuxCpuObject.instanceName]",
                  "intervalSeconds": "[variables('vmInsightsPerfCounters').linuxCpuObject.intervalSeconds]"
                }
              },
              {
                "apiVersion": "2015-11-01-preview",
                "type": "Microsoft.OperationalInsights/workspaces/dataSources",
                "name": "[concat(parameters('workspaceName'), '/', variables('vmInsightsPerfCounters').linuxNetworkObject.armResourceName)]",
                "kind": "LinuxPerformanceObject",
                "properties": {
                  "performanceCounters": "[variables('vmInsightsPerfCounters').linuxNetworkArray]",
                  "objectName": "[variables('vmInsightsPerfCounters').linuxNetworkObject.objectName]",
                  "instanceName": "[variables('vmInsightsPerfCounters').linuxNetworkObject.instanceName]",
                  "intervalSeconds": "[variables('vmInsightsPerfCounters').linuxNetworkObject.intervalSeconds]"
                }
              },
              {
                "apiVersion": "2015-11-01-preview",
                "type": "Microsoft.OperationalInsights/workspaces/dataSources",
                "name": "[concat(parameters('workspaceName'), '/', variables('vmInsightsPerfCounters').windowsArray[copyIndex()].armName)]",
                "kind": "WindowsPerformanceCounter",
                "copy": {
                  "name": "counterCopy",
                  "count": "[length(variables('vmInsightsPerfCounters').windowsArray)]"
                },
                "properties": {
                  "objectName": "[variables('vmInsightsPerfCounters').windowsArray[copyIndex()].objectName]",
                  "instanceName": "[variables('vmInsightsPerfCounters').windowsArray[copyIndex()].instanceName]",
                  "intervalSeconds": "[variables('vmInsightsPerfCounters').windowsArray[copyIndex()].intervalSeconds]",
                  "counterName": "[variables('vmInsightsPerfCounters').windowsArray[copyIndex()].counterName]"
                }
              },
              {
                "apiVersion": "2015-11-01-preview",
                "type": "Microsoft.OperationsManagement/solutions",
                "name": "[concat(variables('batch1').solutions[copyIndex()].Name)]",
                "location": "[parameters('workspaceRegion')]",
                "copy": {
                  "name": "solutionCopy",
                  "count": "[length(variables('batch1').solutions)]"
                },
                "properties": {
                  "workspaceResourceId": "[resourceId('Microsoft.OperationalInsights/workspaces/', parameters('workspaceName'))]"
                },
                "plan": {
                  "name": "[variables('batch1').solutions[copyIndex()].name]",
                  "product": "[concat('OMSGallery/', variables('batch1').solutions[copyIndex()].marketplaceName)]",
                  "promotionCode": "",
                  "publisher": "Microsoft"
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
      "description": "Provide name of existing Log Analytics workspace"
    }
  },
  "workspaceRegion": {
    "type": "String",
    "metadata": {
      "displayName": "workspaceRegion",
      "description": "Select region of existing Log Analytics workspace"
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

output "policydefinition_deploy_la_config" {
  value = azurerm_policy_definition.deploy_la_config
}

