> Disclaimer: All scripts provided here are AS-IS and should be used with caution. We DO NOT offer any warranties.

# VMwareHorizonScripts
Repo with some Azure scripts to prepare your Azure environment to VMware Horizon deployment. All steps, commands and scripts present here were created to address the requirement of [VMWare Horizon Cloud on Azure Checklist](https://docs.vmware.com/en/VMware-Horizon-Cloud-Service/services/hzncloudmsazure.getstarted15/GUID-5F69086E-E061-48F3-93D9-9705B8B5FD8A.html)

> Note: Run the following commands on [Azure Cloud Shell ](https://shell.azure.com/), PowerShell Mode.



The following Azure Regions are not supported for [Horizon Cloud on Azure Deployment](https://kb.vmware.com/s/article/77121):
- France South
- UAE Central
- Azure Government (US Gov Iowa)
- Azure Germany (Germany Central, Germany Northeast)  

## Check Azure Resource Provider Status and register required Providers

The script PowerShell [**Register-Providers.ps1**](https://github.com/rodrigoffonseca/VMwareHorizonScripts/blob/main/Register-Providers.ps1) will check all Azure Resource Providers required by VMWare Horizon and register the ones that are missing.
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

## Check you Azure Subscription Available Quota

The script PowerShell [**Available-Quota.ps1**](https://github.com/rodrigoffonseca/VMwareHorizonScripts/blob/main/Available-quota.ps1) will check all Azure Resource Quota required by VMWare Horizon and if you have enough quota available or not.
You should first change the **$location** variable to the Azure Region you want to deploy VMWare Horizon, and then execute the script on [Azure Cloud Shell ](https://shell.azure.com/)

This is a sample script output that show quota is available to proceed with Horizon Deployment:

![Checking-quota](/checking-quota.PNG)

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

## Create VNET and Subnet for VMWare Horizon

The Script [**Create-Network.ps1**](https://github.com/rodrigoffonseca/VMwareHorizonScripts/blob/main/Create-Network.ps1) will help you to create a VNET and all required subnets to support VMWare Horizon deploy and a VPN Site to Site Connectivity with the minimum requirements needed. 
On the diagram below you have a network design and some detailed information:
![NetworkDesign](/networkdesign.PNG)

> NOTE: You MUST configure the script with the appropriate Address Space for VNET and Subnet that does not overlap with Customer's On-premises Address space.

> NOTE: You should define the custom DNS IP address for Name Resolution. Usually it's the IP addresses of you Active Directory Servers, that may exist on Azure has Virtual Machines, or On-premises. 

We create a VNET with 4 non-overlapping address ranges in CIDR format in the pod's VNet, reserved for subnets.
- Management subnet — /27 minimum - It must have SQL Service Endpoint enabled on this subnet.
- VM subnet - Primary (tenant) — /27 minimum with /24 - /22 preferred, based on the number of desktops and RDS servers
- DMZ subnet — /28 minimum when Unified Access Gateway is deployed in the pod's VNet (optional)
- Gateway subnet — /28 minimum, needed for VPN Gateway deployment to allow VPN Site-To-Site communication

After the creation of the VPN Gateway, that take around 45 minutes, you should configure both customer's on-premises gateway and Azure VPN Gateway to stablish the network connectivity. Please check this documentation for more information: 
- [Connect On-Premises with Azure using VPN Site-To-Site](https://docs.microsoft.com/en-us/azure/vpn-gateway/tutorial-site-to-site-portal)
- [Supported On-Premises VPN Devices and Configuration](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpn-devices)

## Create Azure App Service Certificate

Create Azure Service Principal with **Contributor Role** at the Subscription Level for VMWare Horizon Cloud connection:

## Create Azure App Service Certificate

Create Azure Service Principal with **Contributor Role** at the Subscription Level for VMWare Horizon Cloud connection:








