https://learn.microsoft.com/en-us/graph/overview#bring-data-from-an-external-content-source-to-microsoft-graph

https://learn.microsoft.com/en-us/graph/overview

https://learn.microsoft.com/en-us/graph/use-the-api?context=graph%2Fapi%2F1.0&view=graph-rest-1.0

# appRegistrationGovernance
Logic App to automate your governance around Application Registration in Azure Active Directory


1.	Audit app registration owners 
2.	Audit ownerless applications or without at least two owners 
3.	Review app registration credentials expiration and freshness (rollover credentials).
4.	Scan app registration permissions 
5.	Audit application that are overprivileged (unused of reducible permissions) and ensure that the least privilege principle is used


# Query

https://graph.microsoft.com/v1.0/applications?$select=passwordCredentials,id&$top=1

https://graph.microsoft.com/v1.0/applications?$select=id,DisplayName,owners$expand=owners
https://graph.microsoft.com/v1.0/applications?$select=id,DisplayName&$expand=owners($select=mail)