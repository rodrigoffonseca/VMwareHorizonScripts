# VMwareHorizonScripts
Repo with some Azure scripts to prepare your Azure environment to VMware Horizon deployment

Run the following commands on [Azure Cloud Shell ](https://shell.azure.com/), PowerShell Mode.

## Create Service Principal
Create Azure Service Principal with **Contributor Role** at the Subscription Level for VMWare Horizon Cloud connection:

> az ad sp create-for-rbac -n "VmwareHorizon" --role Contributor --scopes /subscriptions/{Your_SubscriptionID}

Take not of the output of this command, you will need the following information on Horizon Cloud configuration:

>   **"appId": "YOUR-APPLICATION-ID",**
>   "displayName": "VmwareHorizon",
>   "name": "hexadecimal-name-code-wont-be-used",
>   **"password": "YOUR-APPLICATION-SECRET",**
>   **"tenant": "YOUR-AZURE-AD-TENANT-ID"**

## Check Azure Resource Provider Status and Register required ones

The script PowerShell **Register-Providers.ps1** will check all Azure Resource Providers required by VMWare Horizon and register the ones that are missing.
You should first change the **$location** variable to the Azure Region you want to deploy VMWare Horizon, and then execute the script on [Azure Cloud Shell ](https://shell.azure.com/)





