metadata name = 'App Service Plan'
metadata description = 'This module deploys an App Service Plan.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the app service plan.')
@minLength(1)
@maxLength(60)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

param kind string = 'App'

@description('Conditional. Defaults to false when creating Windows/app App Service Plan. Required if creating a Linux App Service Plan and must be set to true.')
param reserved bool = true

param sku object = {
  capacity: 1
  family: 'B'
  name: 'B1'
  size: 'B1'
  tier: 'Basic'
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: name
  kind: kind
  location: location
  sku: sku
  properties: {
    reserved: reserved
  }
}

output appServicePlanId string = appServicePlan.id
