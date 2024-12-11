param AppserviceplanName string
param kind string
param location string = resourceGroup().location
param sku object
param contName string
param webappName string
param siteConfig object

module keyVault 'modules/key-vault.bicep' = {
  name: 'aswinkv'
  params: {
    name: 'aswinkv'
    location: location
    enableVaultForDeployment: true
    roleAssignments: [
      {
        principalId: 'c52bb0cc-7f22-4c28-aee8-264d1cafbb06'
        roleDefinitionIdOrName: 'Key Vault Secrets User'
        principalType: 'ServicePrincipal'
      }
    ]
  }
}

module registry 'modules/registry.bicep' = {
  name: contName
  params: {
    name: contName
    location: location
    adminCredentialsKeyVaultResourceId: keyVault.outputs.keyVaultId
    adminCredentialsKeyVaultSecretUserName: 'acr-username'
    adminCredentialsKeyVaultSecretUserPassword1: 'acr-password1'
    adminCredentialsKeyVaultSecretUserPassword2: 'acr-password2'
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

module webApp 'modules/web-app.bicep' = {
  name: webappName
  params: {
    name: webappName
    location: location
    appServicePlanId: appServicePlan.outputs.appServicePlanId
    siteConfig: siteConfig
    dockerRegistryServerUrl: 'https://${registry.outputs.loginServer}'
    dockerRegistryServerUserName: keyVault.getSecret('acr-username')
    dockerRegistryServerPassword: keyVault.getSecret('acr-password1')
  }
}
