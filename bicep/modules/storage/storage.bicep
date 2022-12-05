param location string
param suffix string

resource strApp 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: 'str${suffix}'
  location: location
  tags: {
    description: 'Storage for Logic App'
  }
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  identity: {
    type: 'SystemAssigned'    
  }
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${strApp.name}/default/reports'
}

output storageAccountName string = strApp.name
