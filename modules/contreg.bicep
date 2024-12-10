metadata name = 'Azure Container Registries (ACR)'
metadata description = 'This module deploys an Azure Container Registry (ACR).'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of your Azure Container Registry.')
@minLength(5)
@maxLength(50)
param name string

@description('Optional. Enable admin user that have push / pull permission to the registry.')
param acrAdminUserEnabled bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location


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

#disable-next-line outputs-should-not-contain-secrets
var credentials = registry.listCredentials()
#disable-next-line outputs-should-not-contain-secrets
output adminUsername string = credentials.username
#disable-next-line outputs-should-not-contain-secrets
output adminPassword string = credentials.passwords[0].value
