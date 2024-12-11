@description('Required. Name of the Key Vault.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable Azure Virtual Machines to retrieve certificates stored as secrets from the key vault.')
param enableVaultForDeployment bool = true

@description('Optional. Array of role assignment objects.')
param roleAssignments array = [
  {
    principalId: 'c52bb0cc-7f22-4c28-aee8-264d1cafbb06'
    roleDefinitionIdOrName: 'Key Vault Secrets User'
    principalType: 'ServicePrincipal'
  }
]

var builtInRoleNames = {
  'Key Vault Secrets User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: name
  location: location
  properties: {
    enabledForDeployment: enableVaultForDeployment
    enableRbacAuthorization: true
    enableSoftDelete: false
    enabledForTemplateDeployment: true
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
  }
}

resource keyVault_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in roleAssignments: {
  name: guid(keyVault.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    principalType: roleAssignment.principalType
  }
  scope: keyVault
}]

output keyVaultName string = keyVault.name
output keyVaultId string = keyVault.id
