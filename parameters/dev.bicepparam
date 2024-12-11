using '../main.bicep'

param appServicePlanName = 'aswinasp'
param containerRegistryName = 'aswincont'
param webAppName = 'aswinapp'
param containerRegistryImageName = 'aswinimage'
param keyVaultName = 'aswinkv'


param adminUsernameSecretName = 'adminUsernameSecretName'
param adminPasswordSecretName = 'adminPasswordSecretName0'


@description('Specifies the SKU for the App Service Plan.')
param sku = {
  capacity: 1
  family: 'B'
  name: 'B1'
  size: 'B1'
  tier: 'Basic'
}

@description('The kind of App Service Plan (e.g., Linux).')
param kind = 'Linux'
