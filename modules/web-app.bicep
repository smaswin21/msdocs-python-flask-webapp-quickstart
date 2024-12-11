param name string
param location string = resourceGroup().location
param appServicePlanId string
@secure()
param dockerRegistryServerUrl string
@secure()
param dockerRegistryServerUserName string
@secure()
param dockerRegistryServerPassword string
param siteConfig object

var dockerAppSettings = {
  DOCKER_REGISTRY_SERVER_URL: dockerRegistryServerUrl
  DOCKER_REGISTRY_SERVER_USERNAME: dockerRegistryServerUserName
  DOCKER_REGISTRY_SERVER_PASSWORD: dockerRegistryServerPassword
  WEBSITES_ENABLE_APP_SERVICE_STORAGE: 'false'
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
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
