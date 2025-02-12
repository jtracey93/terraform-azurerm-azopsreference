# This file was auto generated
resource "azurerm_policy_set_definition" "deny_publicendpoints" {
  name                  = "Deny-PublicEndpoints"
  policy_type           = "Custom"
  display_name          = "Public network access should be disabled for PAAS services"
  description           = "This policy denies creation of Azure PAAS services with exposed public endpoints. This policy set includes the policy for the following services KeyVault, Storage accounts, AKS, Cosmos, SQL Servers, MariaDB, MySQL and Postgress. "
  management_group_name = var.management_group_name
  depends_on = [
    azurerm_policy_definition.deny_publicendpoint_aks,
    azurerm_policy_definition.deny_publicendpoint_cosmosdb,
    azurerm_policy_definition.deny_publicendpoint_keyvault,
    azurerm_policy_definition.deny_publicendpoint_mariadb,
    azurerm_policy_definition.deny_publicendpoint_mysql,
    azurerm_policy_definition.deny_publicendpoint_postgresql,
    azurerm_policy_definition.deny_publicendpoint_sql,
    azurerm_policy_definition.deny_publicendpoint_storage,
  ]

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.management_group_name}/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicEndpoint-CosmosDB"
    reference_id         = "DenyPublicEndpointCosmosDB"
    parameter_values     = <<VALUES
{
  "effect": {
    "value": "[parameters('CosmosPublicIpDenyEffect')]"
  }
}
VALUES
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.management_group_name}/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicEndpoint-MariaDB"
    reference_id         = "DenyPublicEndpointMariaDB"
    parameter_values     = <<VALUES
{
  "effect": {
    "value": "[parameters('MariaDBPublicIpDenyEffect')]"
  }
}
VALUES
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.management_group_name}/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicEndpoint-MySQL"
    reference_id         = "DenyPublicEndpointMySQL"
    parameter_values     = <<VALUES
{
  "effect": {
    "value": "[parameters('MySQLPublicIpDenyEffect')]"
  }
}
VALUES
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.management_group_name}/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicEndpoint-PostgreSql"
    reference_id         = "DenyPublicEndpointPostgreSql"
    parameter_values     = <<VALUES
{
  "effect": {
    "value": "[parameters('PostgreSQLPublicIpDenyEffect')]"
  }
}
VALUES
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.management_group_name}/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicEndpoint-KeyVault"
    reference_id         = "DenyPublicEndpointKeyVault"
    parameter_values     = <<VALUES
{
  "effect": {
    "value": "[parameters('KeyVaultPublicIpDenyEffect')]"
  }
}
VALUES
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.management_group_name}/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicEndpoint-Sql"
    reference_id         = "DenyPublicEndpointSql"
    parameter_values     = <<VALUES
{
  "effect": {
    "value": "[parameters('SqlServerPublicIpDenyEffect')]"
  }
}
VALUES
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.management_group_name}/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicEndpoint-Storage"
    reference_id         = "DenyPublicEndpointStorage"
    parameter_values     = <<VALUES
{
  "effect": {
    "value": "[parameters('StoragePublicIpDenyEffect')]"
  }
}
VALUES
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Management/managementGroups/${var.management_group_name}/providers/Microsoft.Authorization/policyDefinitions/Deny-PublicEndpoint-Aks"
    reference_id         = "DenyPublicEndpointAks"
    parameter_values     = <<VALUES
{
  "effect": {
    "value": "[parameters('AKSPublicIpDenyEffect')]"
  }
}
VALUES
  }

  parameters = <<PARAMETERS
{
  "AKSPublicIpDenyEffect": {
    "allowedValues": [
      "Audit",
      "Deny",
      "Disabled"
    ],
    "defaultValue": "Deny",
    "metadata": {
      "description": "This policy denies the creation of Azure Kubernetes Service non-private clusters",
      "displayName": "Public network access on AKS API should be disabled"
    },
    "type": "String"
  },
  "CosmosPublicIpDenyEffect": {
    "allowedValues": [
      "Audit",
      "Deny",
      "Disabled"
    ],
    "defaultValue": "Deny",
    "metadata": {
      "description": "This policy denies that Cosmos database accounts are created with out public network access is disabled.",
      "displayName": "Public network access should be disabled for CosmosDB"
    },
    "type": "String"
  },
  "KeyVaultPublicIpDenyEffect": {
    "allowedValues": [
      "Audit",
      "Deny",
      "Disabled"
    ],
    "defaultValue": "Deny",
    "metadata": {
      "description": "This policy denies creation of Key Vaults with IP Firewall exposed to all public endpoints",
      "displayName": "Public network access should be disabled for KeyVault"
    },
    "type": "String"
  },
  "MariaDBPublicIpDenyEffect": {
    "allowedValues": [
      "Audit",
      "Deny",
      "Disabled"
    ],
    "defaultValue": "Deny",
    "metadata": {
      "description": "This policy denies the creation of Maria DB accounts with exposed public endpoints",
      "displayName": "Public network access should be disabled for MariaDB"
    },
    "type": "String"
  },
  "MySQLPublicIpDenyEffect": {
    "allowedValues": [
      "Audit",
      "Deny",
      "Disabled"
    ],
    "defaultValue": "Deny",
    "metadata": {
      "description": "This policy denies creation of MySql DB accounts with exposed public endpoints",
      "displayName": "Public network access should be disabled for MySQL"
    },
    "type": "String"
  },
  "PostgreSQLPublicIpDenyEffect": {
    "allowedValues": [
      "Audit",
      "Deny",
      "Disabled"
    ],
    "defaultValue": "Deny",
    "metadata": {
      "description": "This policy denies creation of Postgre SQL DB accounts with exposed public endpoints",
      "displayName": "Public network access should be disabled for PostgreSql"
    },
    "type": "String"
  },
  "SqlServerPublicIpDenyEffect": {
    "allowedValues": [
      "Audit",
      "Deny",
      "Disabled"
    ],
    "defaultValue": "Deny",
    "metadata": {
      "description": "This policy denies creation of Sql servers with exposed public endpoints",
      "displayName": "Public network access on Azure SQL Database should be disabled"
    },
    "type": "String"
  },
  "StoragePublicIpDenyEffect": {
    "allowedValues": [
      "Audit",
      "Deny",
      "Disabled"
    ],
    "defaultValue": "Deny",
    "metadata": {
      "description": "This policy denies creation of storage accounts with IP Firewall exposed to all public endpoints",
      "displayName": "Public network access onStorage accounts should be disabled"
    },
    "type": "String"
  }
}
PARAMETERS
}

output "policysetdefinition_deny_publicendpoints" {
  value = azurerm_policy_set_definition.deny_publicendpoints
}

output "policysetdefinition_deny_publicendpoints_definitions" {
  value = [
    azurerm_policy_definition.deny_publicendpoint_aks,
    azurerm_policy_definition.deny_publicendpoint_cosmosdb,
    azurerm_policy_definition.deny_publicendpoint_keyvault,
    azurerm_policy_definition.deny_publicendpoint_mariadb,
    azurerm_policy_definition.deny_publicendpoint_mysql,
    azurerm_policy_definition.deny_publicendpoint_postgresql,
    azurerm_policy_definition.deny_publicendpoint_sql,
    azurerm_policy_definition.deny_publicendpoint_storage,
  ]
}

