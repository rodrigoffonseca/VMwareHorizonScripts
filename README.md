# VMwareHorizonScripts
Repo with some Azure scripts to prepare your Azure environment to VMware Horizon deployment. All steps, commands and scripts present here were created to address the requirement of [VMWare Horizon Cloud on Azure Checklist](https://docs.vmware.com/en/VMware-Horizon-Cloud-Service/services/hzncloudmsazure.getstarted15/GUID-5F69086E-E061-48F3-93D9-9705B8B5FD8A.html)

> Note: Run the following commands on [Azure Cloud Shell ](https://shell.azure.com/), PowerShell Mode.

## Get Azure Subscription ID

Get you Azure Subscription ID with the following command:

> Get-AzSubscription

Take note of the output and copy your Subscription ID:
![SubscriptionID](/subscription-id.PNG)

## Create Service Principal
Create Azure Service Principal with **Contributor Role** at the Subscription Level for VMWare Horizon Cloud connection:

> az ad sp create-for-rbac -n "VmwareHorizon" --role Contributor --scopes /subscriptions/{Your_SubscriptionID}

Take note of the output, you will need the following information to add you Azure Subscription to Horizon Cloud:

>   **"appId": "YOUR-APPLICATION-ID",**

>   "displayName": "VmwareHorizon",

>   "name": "hexadecimal-name-code-wont-be-used",

>   **"password": "YOUR-APPLICATION-SECRET",**

>   **"tenant": "YOUR-AZURE-AD-TENANT-ID"**


On VMWare Horizon Universal Console add a new subscription and paste the information in the appropriate fields:
![HorizonConfig](/Horizon-Subscription-config.PNG)

## Check Azure Resource Provider Status and register required Providers

The script PowerShell **Register-Providers.ps1** will check all Azure Resource Providers required by VMWare Horizon and register the ones that are missing.
You should first change the **$location** variable to the Azure Region you want to deploy VMWare Horizon, and then execute the script on [Azure Cloud Shell ](https://shell.azure.com/)

The following Azure Resource Provider are required by VMware Horizon:
- Microsoft.Compute
- microsoft.insights
- Microsoft.Network
- Microsoft.Storage
- Microsoft.KeyVault
- Microsoft.Authorization
- Microsoft.Resources
- Microsoft.ResourceHealth
- Microsoft.ResourceGraph
- Microsoft.Security
- Microsoft.DBforPostgreSQL
- Microsoft.Sql







