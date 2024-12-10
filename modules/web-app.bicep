@description('Required. Name of the site.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

param kind string = 'app'

@description('Required. The resource ID of the app service plan to use for the site.')
param appServicePlanId string 

param containerRegistryName string
param containerRegistryImageName string
param containerRegistryImageVersion string = 'latest'

@secure()
param dockerRegistryServerUserName string

@secure()
param dockerRegistryServerPassword string

@description('Optional. The site config object. Defaults: alwaysOn=true, minTlsVersion=1.2, ftpsState=FtpsOnly, linuxFxVersion=DOCKER.')
param siteConfig object = {
  alwaysOn: true
  minTlsVersion: '1.2'
  ftpsState: 'FtpsOnly'
  linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
  appCommandLine: ''
}

var dockerAppSettings = {
  DOCKER_REGISTRY_SERVER_URL: 'https://${containerRegistryName}.azurecr.io'
  DOCKER_REGISTRY_SERVER_USERNAME: dockerRegistryServerUserName
  DOCKER_REGISTRY_SERVER_PASSWORD: dockerRegistryServerPassword
  WEBSITES_ENABLE_APP_SERVICE_STORAGE: 'false'
}



resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  kind: kind
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: siteConfig
  }
}

resource appSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: webApp
  name: 'appsettings'
  properties: dockerAppSettings
}
