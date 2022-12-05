param location string
param suffix string

var accountName = 'cosmos${suffix}'
var databaseName = 'reporting'
var containerName = 'reports'

resource account 'Microsoft.DocumentDB/databaseAccounts@2021-10-15' = {
  name: toLower(accountName)
  location: location
  kind: 'GlobalDocumentDB'
  properties: {    
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }    
    ]
    databaseAccountOfferType: 'Standard'    
  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-10-15' = {
  name: '${account.name}/${databaseName}'
  properties: {
    resource: {
      id: databaseName
    }
  }
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-10-15' = {
  name: '${database.name}/${containerName}'
  properties: {
    resource: {
      id: containerName
      partitionKey: {
        paths: [
          '/reportDate'
        ]
        kind: 'Hash'
      }
    }
    options: {
      throughput: 400
    }
  }
}

output cosmosDbAccountName string = account.name
