param location string
param storageName string
param insightName string
param suffix string

resource storage 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageName
}

resource insight 'Microsoft.Insights/components@2020-02-02' existing = {
  name: insightName
}

var strCnxString = 'DefaultEndpointsProtocol=https;AccountName=${storage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storage.listKeys().keys[0].value}'

resource webFarm 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'plan-${suffix}'
  location: location
  sku: {
    tier: 'WorkflowStandard'
    name: 'WS1'
  }
  kind: 'windows'
}

resource logiapp 'Microsoft.Web/sites@2021-02-01' = {
  name: 'logicapp-${suffix}'
  location: location
  kind: 'workflowapp,functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {    
    siteConfig: {
      netFrameworkVersion: 'v4.6'
      appSettings: [
        {
          name: 'APP_KIND'
          value: 'workflowApp'
        }       
        {
          name: 'AzureFunctionsJobHost__extensionBundle__id'
          value: 'Microsoft.Azure.Functions.ExtensionBundle.Workflows'
        }
        {
          name: 'AzureFunctionsJobHost__extensionBundle__version'
          value: '[1.*, 2.0.0)'
        }         
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'FUNCTIONS_V2_COMPATIBILITY_MODE'
          value: 'true'
        }     
        {
          name: 'WORKFLOWS_SUBSCRIPTION_ID'
          value: subscription().subscriptionId
        }
        {
          name: 'WORKFLOWS_LOCATION_NAME'
          value: location
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~14'
        }      
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: insight.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: insight.properties.ConnectionString
        }
        {
          name: 'AzureWebJobsStorage'
          value: strCnxString
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: strCnxString
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: 'logicapp98'
        }
      ]
      use32BitWorkerProcess: true
    }
    serverFarmId: webFarm.id
    clientAffinityEnabled: false    
  }
}


resource webFarm 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'asp-${suffix}'
  location: location
  sku: {
    tier: 'WorkflowStandard'
    name: 'WS1'
  }
  kind: 'windows'
}

resource logiapp 'Microsoft.Web/sites@2021-02-01' = {
  name: 'logicapp-${suffix}'
  location: location
  kind: 'workflowapp,functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {    
    siteConfig: {
      netFrameworkVersion: 'v4.6'
      appSettings: [
        {
          name: 'APP_KIND'
          value: 'workflowApp'
        }       
        {
          name: 'AzureFunctionsJobHost__extensionBundle__id'
          value: 'Microsoft.Azure.Functions.ExtensionBundle.Workflows'
        }
        {
          name: 'AzureFunctionsJobHost__extensionBundle__version'
          value: '[1.*, 2.0.0)'
        }         
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'FUNCTIONS_V2_COMPATIBILITY_MODE'
          value: 'true'
        }     
        {
          name: 'WORKFLOWS_SUBSCRIPTION_ID'
          value: subscription().subscriptionId
        }
        {
          name: 'WORKFLOWS_LOCATION_NAME'
          value: location
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~12'
        }      
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: insight.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: insight.properties.ConnectionString
        }
        {
          name: 'AzureWebJobsStorage'
          value: strCnxString
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: strCnxString
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: 'logicapp98'
        }
      ]
      use32BitWorkerProcess: true
    }
    serverFarmId: webFarm.id
    clientAffinityEnabled: false    
  }
}
