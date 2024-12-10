param AppserviceplanName string 
param kind string 
param location string= resourceGroup().location
param sku object 
param contName string
param webappName string
param contRegImage string

module registry 'modules/contreg.bicep' = {
  name: contName
  params: {
    name: contName
    location: location
  }
}

module appServicePlan 'modules/asp.bicep' = {
  name: AppserviceplanName
  params: {
    name: AppserviceplanName
    kind: kind
    location: location
    sku: sku
  }
}
param siteConfig object 

module appSettings 'modules/web-app.bicep' = {
  name: webappName
  params: {
    location: location 
    appServicePlanId : appServicePlan.outputs.appServicePlanId  
    siteConfig: siteConfig
    dockerRegistryServerUserName: registry.outputs.adminUsername
    dockerRegistryServerPassword: registry.outputs.adminPassword
    containerRegistryImageName: contRegImage
    containerRegistryName: contName
    name: webappName
    
  }
}
