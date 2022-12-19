# Disclaimer

Notice: Any links, references, or attachments that contain sample scripts, code, or commands comes with the following notification.

This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.

We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code,
provided that You agree:

(i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded;
(ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and
(iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits,
including attorneys’ fees, that arise or result from the use or distribution of the Sample Code.

Please note: None of the conditions outlined in the disclaimer above will superseded the terms and conditions contained within the Premier Customer Services Description.

**DEMO POC - "AS IS"**

# Introduction

This GitHub provide an example how to generate reports related to your App Registration in Azure Active Directory.  When your applications stacks growth in Azure Active Directory it can be difficult to keep track (inventory) of what you have there with the permissions of those applications.

This GitHub propose one solution (proof of concept) that you can leverage using Serverless technologies.  The goal was to writte the less code possible, to do so, Logic App where used here.

The list of reports generated by this PoC are the following:

<ul>
    <li>Applications registration with their owners</li>
    <li>Applications registration with less than two owners</li>
    <li>Applications registration with credentials that will expired in the next 3 months</li>
    <li>Applications registration with their permission</li>
</ul>

**Important**, the logic app use the built-in connector for **CosmosDB** that is currently in **preview**.  This connector was used for better DevOps and this PoC come **"AS IS"** without any **warranty**.  If you create the same concept for production workload and the connector is still in preview is recommended to use the **Azure managed connector**.

# Architecture

![Architecture](https://github.com/hugogirard/appRegistrationGovernance/blob/main/diagram/logicapp.drawio.png?raw=true)

The architecture diagram is quite simple, all the logic is encapsulated inside the Logic App (two workflows).  CosmosDB is used to manipulate the data and save the results.  From there, we generate a report in **CSV** file and save it into an Azure Storage.  Because all data are saved in CosmosDB it will be easy after to use Power BI to generate a more user friendly report (or any other report tool).  THis example provides only a simple CSV file for report purpose.

# Prerequisites

First step is to Fork this repository.

Next you will need to create a service principal to run the GitHub action.  This service principal need to have **contributor** right on the subscription you will install the Azure resources.  To do this, follow this [link](https://github.com/marketplace/actions/azure-login#configure-a-service-principal-with-a-secret). Be sure to take note of the credential returned when creating the **service principal** you will need it for the next step.

Now create an application registration, this will be used to query **MSGraph** to extract the information from your **Azure Active Directory**.

The application needs the API permissions called **Directory.Read.All** from application permissions. Take note of the **Application (client) id** and create a new secrets for this application, both information will be needed for the logic app.

# Create GitHub secrets

Now create the following [GitHub actions secrets](https://docs.github.com/en/rest/actions/secrets?apiVersion=2022-11-28).

| Name | Value
| ----- | -----
| AZURE_CREDENTIALS | The value from the step before when creating the service principal.
| SUBSCRIPTION_ID | The ID of the subscription where all the resources will be created.
| CLIENT_ID | The client ID associated to the created application.
| CLIENT_SECRET | The secret created from the application.
| PA_TOKEN | A personnal access token needed to write secret, to know the proper permission to give follow this [link](https://github.com/marketplace/actions/create-github-secret-action).

# Create the Azure resources

Now, execute the GitHub action called **Create Azure Resources**, this will create all necessary resources in Azure in a resource group called **rg-logic-app-governance**.  Once the GitHub action finished it will trigger the GitHub action called **Deploy Logic App**.

# Execute the workflow

The logic app contains two workflows, **GetListAppRegistration** and another called **GetAppPermission**.  The **order** the workflow run here are **important**.  You need to run first the **GetListAppRegistration**, once this workflow finished, you can run **GetAppPermission**.

Here those logic app use the HTTP Trigger, in a real production workflow you will probably have an orchestrator function based on a timer trigger that will execute sequentially the two logic app.  HTTP Trigger were used here for simplicity purpose.

# What is not implemented here

Here the continuation token were not implemented in the CosmosDB connector.  If you run this demo on an Active Directory that contains a lot of application registration you will probably need to implement this.

For more information about this you can follow this [link](https://techcommunity.microsoft.com/t5/integrations-on-azure-blog/paging-using-continuation-token-to-return-large-list-of-items-in/ba-p/2522802)