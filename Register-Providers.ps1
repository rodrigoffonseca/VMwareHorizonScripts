$RPList = @("Microsoft.Compute", "microsoft.insights", "Microsoft.Network", "Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Authorization", "Microsoft.Resources", "Microsoft.ResourceHealth","Microsoft.ResourceGraph","Microsoft.Security","Microsoft.DBforPostgreSQL","Microsoft.Sql")
$location = "eastus"
foreach ($RP in $RPList)
{
    $temp = Get-AzResourceProvider -ProviderNamespace $RP -Location $location
    if ($temp.RegistrationState -eq "NotRegistered")
        {
            Register-AzResourceProvider -ProviderNamespace $RP -WhatIf
        }
    else
        {
        Write-Host $RP "already Registered"
        }
}
