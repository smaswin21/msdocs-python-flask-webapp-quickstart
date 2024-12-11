param name string
param location string = resourceGroup().location
param adminCredentialsKeyVaultResourceId string
@secure()
param adminCredentialsKeyVaultSecretUserName string
@secure()
param adminCredentialsKeyVaultSecretUserPassword1 string
@secure()
param adminCredentialsKeyVaultSecretUserPassword2 string

resource adminCredentialsKeyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: last(split(adminCredentialsKeyVaultResourceId, '/'))
}

resource registry 'Microsoft.ContainerRegistry/registries@2023-06-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource secretUserName 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: adminCredentialsKeyVault
  name: adminCredentialsKeyVaultSecretUserName
  properties: {
    value: registry.listCredentials().username
  }
}

resource secretPassword1 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: adminCredentialsKeyVault
  name: adminCredentialsKeyVaultSecretUserPassword1
  properties: {
    value: registry.listCredentials().passwords[0].value
  }
}

output loginServer string = registry.properties.loginServer
