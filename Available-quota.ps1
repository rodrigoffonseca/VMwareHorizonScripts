#This script will verify your current subpscription quota and check for all recommended VM families if you have available quota to proceed with Horizon Cloud on Azure Deployment.
#Define Azure Region/Location where you will deploy Horizon
$location = "eastus"
#Get your subscription quota config
$actualquota = Get-AzVMUsage -Location $location 
foreach ($item in $actualquota) {
    if ($item.Name.Value -eq "cores"){
        $temp = ($item.Limit - $item.CurrentValue)
        Write-host "Checking you quota for vCPU Cores..."
        If ($temp -gt 32) { 
        #Write the total Quota and shows OK if the value is greater than required
            write-host -BackgroundColor Green "Total available vCPU Cores are: "$temp 
            write-host -BackgroundColor Green "Your Quota for vCPU Core is OK"
            }
        else { 
            write-host -BackgroundColor Red "You need to increase your quota , open a Support Ticket in Azure Portal to request Quota increase" 
            }
    }
    if ($item.Name.Value -eq "virtualMachines"){
        $temp = ($item.Limit - $item.CurrentValue)
        Write-host "Checking you quota for Virtual Machines..."
        If ($temp -gt 16) { 
        #Write the total Quota and shows OK if the value is greater than required
            write-host -BackgroundColor Green "Total available VMs are: "$temp 
            write-host -BackgroundColor Green "Your Quota for Virtual Machines is OK"
            }
        else { 
            write-host -BackgroundColor Red "You need to increase your quota , open a Support Ticket in Azure Portal to request Quota increase" 
            }
    }
    if ($item.Name.Value -eq "standardDSv3Family"){
        $temp = ($item.Limit - $item.CurrentValue)
        Write-host "Checking you quota for standardDSv3Family..."
        If ($temp -gt 4) { 
        #Write the total Quota and shows OK if the value is greater than required
            write-host -BackgroundColor Green "Total available standardDSv3Family are: "$temp 
            write-host -BackgroundColor Green "Your Quota for standardDSv3Family is OK"
            }
        else { 
            write-host -BackgroundColor Red "You need to increase your quota , open a Support Ticket in Azure Portal to request Quota increase" 
            }
    }
    if ($item.Name.Value -eq "standardDSv2Family"){
        $temp = ($item.Limit - $item.CurrentValue)
        Write-host "Checking you quota for standardDSv2Family..."
        If ($temp -gt 4) { 
        #Write the total Quota and shows OK if the value is greater than required
            write-host -BackgroundColor Green "Total available standardDSv2Family are: "$temp 
            write-host -BackgroundColor Green "Your Quota for standardDSv2Family is OK"
            }
        else { 
            write-host -BackgroundColor Red "You need to increase your quota , open a Support Ticket in Azure Portal to request Quota increase" 
            }
    }
    if ($item.Name.Value -eq "standardAv2Family"){
        $temp = ($item.Limit - $item.CurrentValue)
        Write-host "Checking you quota for standardAv2Family..."
        If ($temp -gt 4) { 
        #Write the total Quota and shows OK if the value is greater than required
            write-host -BackgroundColor Green "Total available standardAv2Family are: "$temp 
            write-host -BackgroundColor Green "Your Quota for standardAv2Family is OK"
            }
        else { 
            write-host -BackgroundColor Red "You need to increase your quota , open a Support Ticket in Azure Portal to request Quota increase" 
            }
    }
    if ($item.Name.Value -eq "standardDSv4Family"){
        $temp = ($item.Limit - $item.CurrentValue)
        Write-host "Checking you quota for standardDSv4Family..."
        If ($temp -gt 4) { 
        #Write the total Quota and shows OK if the value is greater than required
            write-host -BackgroundColor Green "Total available standardDSv4Family are: "$temp 
            write-host -BackgroundColor Green "Your Quota for standardDSv4Family is OK"
            }
        else { 
            write-host -BackgroundColor Red "You need to increase your quota , open a Support Ticket in Azure Portal to request Quota increase" 
            }
    }
    if ($item.Name.Value -eq "standardFSv2Family"){
        $temp = ($item.Limit - $item.CurrentValue)
        Write-host "Checking you quota for standardFSv2Family..."
        If ($temp -gt 4) { 
        #Write the total Quota and shows OK if the value is greater than required
            write-host -BackgroundColor Green "Total available standardFSv2Family are: "$temp 
            write-host -BackgroundColor Green "Your Quota for standardFSv2Family is OK"
            }
        else { 
            write-host -BackgroundColor Red "You need to increase your quota , open a Support Ticket in Azure Portal to request Quota increase" 
            }
    }
}
