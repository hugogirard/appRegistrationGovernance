targetScope = 'subscription'

@description('The location where the Azure resources will be created')
param location string

@description('The name of the Azure resource group')
param resourceGroupName string

@description('The Service Principal Client ID')
@secure()
param clientId string

@description('The Service Principal Client Secret')\
@secure()
param clientSecret string

var suffix = uniqueString(rg.id)

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module storage 'modules/storage/storage.bicep' = {
  name: 'storage'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    suffix: suffix
  }
}

module monitoring 'modules/monitoring/monitoring.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'monitoring'
  params: {
    location: location
    suffix: suffix
  }
}

module logicapp 'modules/logicapp/logicapp.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'logicapp'
  params: {
    location: location
    suffix: suffix
    insightName: monitoring.outputs.insightName
    storageName: storage.outputs.storageAccountName
    clientId: clientId
    clientSecret: clientSecret
  }
}

module cosmos 'modules/cosmos/cosmosdb.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'cosmos'
  params: {
    location: location
    suffix: suffix
  }
}
