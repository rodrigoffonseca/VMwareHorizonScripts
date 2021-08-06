#This script will check if all provider required by VMWare Horizon cloud are already registered in your subscription, and will register what is missing.
$RPList = @("Microsoft.Compute", "microsoft.insights", "Microsoft.Network", "Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Authorization", "Microsoft.Resources", "Microsoft.ResourceHealth","Microsoft.ResourceGraph","Microsoft.Security","Microsoft.DBforPostgreSQL","Microsoft.Sql")
#Define your Azure Region / Location where you will deploy Horizon Cloud on Azure
$location = "eastus"
foreach ($RP in $RPList)
{
    $temp = Get-AzResourceProvider -ProviderNamespace $RP -Location $location
    if ($temp.RegistrationState -eq "NotRegistered")
        {
            Write-Host -BackgroundColor Green $RP "will be registered now..."
            Register-AzResourceProvider -ProviderNamespace $RP
        }
    else
        {
        Write-Host -BackgroundColor Green $RP "already Registered"
        }
}
