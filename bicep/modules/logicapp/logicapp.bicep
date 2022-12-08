//
// Notice: Any links, references, or attachments that contain sample scripts, code, or commands comes with the following notification.
//
// This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.
// THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
//
// We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code,
// provided that You agree:
//
// (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded;
// (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and
// (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits,
// including attorneys’ fees, that arise or result from the use or distribution of the Sample Code.
//
// Please note: None of the conditions outlined in the disclaimer above will superseded the terms and conditions contained within the Premier Customer Services Description.
//
// DEMO POC - "AS IS"

param location string
param storageName string
param insightName string
param suffix string
param cosmosDbAccountName string

@secure()
param clientId string
@secure()
param clientSecret string


resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2021-10-15' existing = {
  name: cosmosDbAccountName
}

resource storage 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageName
}

resource insight 'Microsoft.Insights/components@2020-02-02' existing = {
  name: insightName
}

var strCnxString = 'DefaultEndpointsProtocol=https;AccountName=${storage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storage.listKeys().keys[0].value}'

resource webFarm 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'asp-${suffix}'
  location: location
  sku: {
    tier: 'WorkflowStandard'
    name: 'WS1'
  }
  kind: 'windows'
}


var cosmosDbCnxString = 'AccountEndpoint=https://${cosmos.name}.documents.azure.com:443/;AccountKey=${cosmos.listKeys().primaryMasterKey};'

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
          name: 'WORKFLOWS_TENANT_ID'
          value: subscription().tenantId
        }
        {
          name: 'CLIENT_ID'
          value: clientId
        }
        {
          name: 'CLIENT_SECRET'
          value: clientSecret
        }
        {
          name: 'WORKFLOWS_LOCATION_NAME'
          value: location
        }
        {
          name: 'COSMOS_CNXSTRING'
          value: cosmosDbCnxString
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

output logiappName string = logiapp.name
