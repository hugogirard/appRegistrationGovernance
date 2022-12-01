param location string
//param storageName string
// param insightName string
param suffix string

// resource storage 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
//   name: storageName
// }

// resource insight 'Microsoft.Insights/components@2020-02-02' existing = {
//   name: insightName
// }

resource webFarm 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'asp-${suffix}'
  location: location
  sku: {
    tier: 'WorkflowStandard'
    name: 'WS1'
  }
  kind: 'windows'
}


