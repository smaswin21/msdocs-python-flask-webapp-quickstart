using '../main.bicep'

param AppserviceplanName = 'aswinasp'
param contName = 'aswincontreg'
param webappName = 'aswinapp'
param contRegImage = 'aswinimage'

@description('Specifies the SKU for the App Service Plan.')
param sku  = {
  capacity: 1
  family: 'B'
  name: 'B1'
  size: 'B1'
  tier: 'Basic'
}

@description('The kind of App Service Plan (e.g., Linux).')
param kind  = 'Linux'

@description('Site configuration for the Web App.')
param siteConfig  = {
  alwaysOn: true
  minTlsVersion: '1.2'
  ftpsState: 'FtpsOnly'
  linuxFxVersion: 'DOCKER|aswincontreg.azurecr.io/aswinimage:latest'
  appCommandLine: ''
}
