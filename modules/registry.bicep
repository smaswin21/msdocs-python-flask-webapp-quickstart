metadata name = 'Azure Container Registries (ACR)'
metadata description = 'This module deploys an Azure Container Registry (ACR).'
metadata owner = 'Azure/module-maintainers'
param name string

@description('Optional. Enable admin user that have push / pull permission to the registry.')
param acrAdminUserEnabled bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Key Vault Resource ID where ACR credentials will be stored.')
param keyVaultResourceId string

@description('Key Vault secret name for the ACR admin username.')
param adminUsernameSecretName string = 'acrAdminUsername'

@description('Key Vault secret name for the ACR admin password.')
param adminPasswordSecretName string = 'acrAdminPassword'

resource registry 'Microsoft.ContainerRegistry/registries@2023-06-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: acrAdminUserEnabled
  }
}

// added these for the key vault


output id string = registry.id
output loginServer string = registry.properties.loginServer

resource adminCredentialsKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(keyVaultResourceId)) {
  name: last(split((!empty(keyVaultResourceId) ? keyVaultResourceId : 'dummyVault'), '/'))!
}

// create a secret to store the container registry admin username
resource secretAdminUserName 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(adminUsernameSecretName)) {
  name: adminUsernameSecretName
  parent: adminCredentialsKeyVault
  properties: {
    value: registry.listCredentials().username
}
}
// create a secret to store the container registry admin password 0
resource secretAdminUserPassword0 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(adminPasswordSecretName)) {
  name: adminPasswordSecretName
  parent: adminCredentialsKeyVault
  properties: {
    value: registry.listCredentials().passwords[0].value
}
}
