> Disclaimer: All scripts provided here are AS-IS and should be used with caution. We DO NOT offer any warranties.


- [Prepare Azure for VMWare Horizon Cloud Deployment](#prepare-azure-for-vmware-horizon-cloud-deployment)
  * [Check Azure Resource Provider Status and register required Providers](#check-azure-resource-provider-status-and-register-required-providers)
  * [Check you Azure Subscription Available Quota](#check-you-azure-subscription-available-quota)
  * [Get Azure Subscription ID](#get-azure-subscription-id)
  * [Create Service Principal](#create-service-principal)
  * [Create VNET and Subnet for VMWare Horizon](#create-vnet-and-subnet-for-vmware-horizon)
  * [Create Azure App Service Certificate to be used by External Gateway](#create-azure-app-service-certificate-to-be-used-by-external-gateway)
  * [Configure your Active Directory Domain Services with appropriate permissions](#configure-your-active-directory-domain-services-with-appropriate-permissions)
 
 
# Prepare Azure for VMWare Horizon Cloud Deployment

This Repo contains scripts to prepare your Azure environment to VMware Horizon deployment. All steps, commands and scripts present here were created to address the requirements of [VMWare Horizon Cloud on Azure Checklist](https://docs.vmware.com/en/VMware-Horizon-Cloud-Service/services/hzncloudmsazure.getstarted15/GUID-5F69086E-E061-48F3-93D9-9705B8B5FD8A.html)

> Note: Run the following commands on [Azure Cloud Shell ](https://shell.azure.com/), PowerShell Mode.

The following Azure Regions are not supported for [Horizon Cloud on Azure Deployment](https://kb.vmware.com/s/article/77121):
- France South
- UAE Central
- Azure Government (US Gov Iowa)
- Azure Germany (Germany Central, Germany Northeast)  

## Check Azure Resource Provider Status and register required Providers

The script PowerShell [**Register-Providers.ps1**](https://github.com/rodrigoffonseca/VMwareHorizonScripts/blob/main/scripts/Register-Providers.ps1) will check all Azure Resource Providers required by VMWare Horizon and register the ones that are missing.
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

The script PowerShell [**Available-Quota.ps1**](https://github.com/rodrigoffonseca/VMwareHorizonScripts/blob/main/scripts/Available-quota.ps1) will check all Azure Resource Quota required by VMWare Horizon and if you have enough quota available or not.
You should first change the **$location** variable to the Azure Region you want to deploy VMWare Horizon, and then execute the script on [Azure Cloud Shell ](https://shell.azure.com/)

This is a sample script output that show quota is available to proceed with Horizon Deployment:

![Checking-quota](/Images/checking-quota.PNG)

## Get Azure Subscription ID

Get you Azure Subscription ID with the following command:

> Get-AzSubscription

Take note of the output and copy your Subscription ID:
![SubscriptionID](/Images/subscription-id.PNG)

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
![HorizonConfig](/Images/Horizon-Subscription-config.PNG)

## Create VNET and Subnet for VMWare Horizon

The Script [**Create-Network.ps1**](https://github.com/rodrigoffonseca/VMwareHorizonScripts/blob/main/scripts/Create-Network.ps1) will help you to create a VNET and all required subnets to support VMWare Horizon deploy and a VPN Site to Site Connectivity with the minimum requirements needed. 
On the diagram below you have a network design and some detailed information:
![NetworkDesign](/Images/networkdesign.PNG)

> NOTE: You MUST configure the script with the appropriate Address Space for VNET and Subnet that does not overlap with Customer's On-premises Address space.

> NOTE: You should define the custom DNS IP address for Name Resolution. Usually, it's the IP addresses of you Active Directory Servers, that may exist on Azure has Virtual Machines, or On-premises. 

We create a VNET with 4 non-overlapping address ranges in CIDR format in the pod's VNet, reserved for subnets.
- Management subnet — /27 minimum - It must have SQL Service Endpoint enabled on this subnet.
- VM subnet - Primary (tenant) — /27 minimum with /24 - /22 preferred, based on the number of desktops and RDS servers
- DMZ subnet — /28 minimum when Unified Access Gateway is deployed in the pod's VNet (optional)
- Gateway subnet — /28 minimum, needed for VPN Gateway deployment to allow VPN Site-To-Site communication

After the creation of the VPN Gateway, that take around 45 minutes, you should configure both customer's on-premises gateway and Azure VPN Gateway to stablish the network connectivity. Please check this documentation for more information: 
- [Connect On-Premises with Azure using VPN Site-To-Site](https://docs.microsoft.com/en-us/azure/vpn-gateway/tutorial-site-to-site-portal)
- [Supported On-Premises VPN Devices and Configuration](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpn-devices)

## Create Azure App Service Certificate to be used by External Gateway

Azure provides you the ability to buy an SSL certificate that you can export and use for Horizon Cloud External Gateway configuration. Unfortunately, we can't complete automate this procedure using scripts, but we will provide a how-to guidance on creating the certificate, converting it to PEM format and adding to you Horizon Cloud setup.

1. Go to [Azure Portal]( http://portal.azure.com/), click create a resource and type “App Service Certificate”
2. Select App Service Certificate and click Create
3. Complete the wizard with the following information:
  - Select your Resource Group where you will deploy Horizon Cloud on Azure
  - Select the certificate type:
	- Standard will provide you a FQDN certificate like “MyVDI.contoso.com”
	- Wildcard will give you more freedom to choose your hostname once you have a “*.contoso.com” certificate
  - Type your domain hostname
	- If using Standard: MyVDI.contoso.com
	- if using Wildcard: *.contoso.com
  - Type your certificate name: Mycertificate
  -  Select Autorenewal so your certificate gets renewed every year.

![Certcreation](/Images/certcreation.PNG)

4. Click Review And Create, and then click Create.
5. After the certificate is created, you need to complete some validation steps to have it issued and available for download
6. Open your new created certificate and go to "Certificate Configuration" on the left-side menu
7. Configure your certificate store with Azure KeyVault
- If you don't have a Azure KeyVault, you can create a new KeyVault with the following PowerShell command:
> New-AzKeyVault -VaultName 'Your-KeyVault-Name' -ResourceGroupName 'Your-ResourceGroup-Name' -Location 'East US'
9. Verify your domain name using one of the methods recommend on the portal. Creating a TXT record on your Public DNS zone is probably the easier way to do it.
10. Once you complete all validation steps, your certificate will be issued and ready to be used.

![Certcreation](/Images/certvalidation.PNG)

11. Now you need to download the certificate in PFX format with its Private Key
12. Go to your Azure Key Vault, Select **Secrets** on the Left-Side Menu
14. Click on secret that start with your Certificate Name you defined on Step 3.
![keyvault1](/Images/keyvault1.PNG)
15. Click on hexadecimal code under Current Version
![keyvault2](/Images/keyvault2.PNG)
17. Click **Download as a Certificate** on teh bottom of the page
![keyvault3](/Images/keyvault3.PNG)

19. Now your certificate was download to your computer in PFX format and we need to convert it to PEM format, what is supported by VMWahre Horizon Cloud.
20. Go to your downloaded certificate and click Install PFX
21. Select Local Manchine and click Next

![certimport1](/Images/certimport1.PNG)

23. Click Next on File to Import
24. On Private Key Protection left the password field **empty** and check the option **"Mark This Key As Exportable"**

![certimport2](/Images/certimport2.PNG)

26. Click Next and then Finish to complete the certificate import.
27. Now open the Command Prompt (CMD) and run this command: certlm.msc
28. It will open the Cert manager snapin
29. Go to Personal, Certificates, and you will be able to locate a certificate with the same FQDN name you defined in Step 3.

![certimport3](/Images/certimport3.PNG)

30. Double-Click the certificate, go to **Certification Path** tab and make user you can see both root and Intermediate certification as the image below:

![certimport4](/Images/certimport4.PNG)

31. Now go to **Details** tab and click **Copy To File**
32. Click Next on the Certificate Export Wizard
33. Select **Yes, Export the private key** and click Next

![certimport5](/Images/certimport5.PNG)

34. Make sure **Include all certificates in the certificate path if possible** is selected and click Next

![certimport6](/Images/certimport6.PNG)

35. Type a password to protect your exported certificate and click Next. Take note of this password, you will need it later.

![certimport7](/Images/certimport7.PNG)

36. Type the path and name of your certificate to be exported, click Next and then click Finish.

![certimport8](/Images/certimport8.PNG)

37. Now that your certificate is exported with Private Key and all Certificate Chain inside it, we can convert it to PEM format
38. Open your Command-Prompt (CMD) and run the following command

> Note: To complete this step you need to have OpenSSL command line installed on you computer. If you don't have it, use this link to [install OpenSSL](https://www.xolphin.com/support/OpenSSL/OpenSSL_-_Installation_under_Windows)

> openssl pkcs12 -in <Your-Certificate-Name.PFX> -out <New-Certificate-Name.PEM> -nodes

![certimport9](/Images/certimport9.PNG)

40. Now your certificate is ready to upload at Horizon Cloud POD wizard. Select your .PEM certificate file and upload it.

![certimport10](/Images/certimport10.PNG)

## Configure your Active Directory Domain Services with appropriate permissions

The PowerShell Script [**Config-AD.ps1**](https://github.com/rodrigoffonseca/VMwareHorizonScripts/blob/main/scripts/Config-AD.ps1) will help you to configure your Active Directory Domain Service Environment with the appropriate permissions required to complete Horizon on Azure Deploy. It's important to highlight that your Domain Controllers can be On-Premises or 
on Azure. The Script will works for both scenarios, but it's important that in case you are using On-Premises Domain Controllers, the VNET where you will deploy Horizon must have connectivity (VPN or ExpressRoute) to your On-Premises network, where your DNS and Domain Controllers are.
The Script will:
- Create two Bind User with Password defined by you
- Create a Group and add the Bind users to this group
- Create an Organizational Unity where both users, group and Horizon VMs will reside
- Delegate required permissions for the users to be able to join VM to the OU

It's important that you run the PowerShell script directly in a Domain Controller server with Domain Admin rigths and with [Active Directory PowerShell Module](https://docs.microsoft.com/en-us/powershell/module/activedirectory/?view=windowsserver2019-ps) installed.

The expect script output is:

![output](/Images/output.PNG)

Take not of the OU Path, Bind User name and password, you will use it during your Horizon Deployment.



