targetScope = 'subscription'

@description('The location where the Azure resources will be created')
param location string

@description('The name of the Azure resource group')
param resourceGroupName string

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
