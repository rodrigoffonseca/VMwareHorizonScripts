#define the variables with the correct value for your environment
$rgname = "MyResourceGroup"
$DnsZoneName = "labfoca01.com.br"
$location = "eastus"
$DNSExteralName = "vdi" #The name of your external gateway defined during horizon cloud setup

#If you want to create an Azure DNS Zone, remove the comments from the following lines
New-AzResourceGroup -name $rgname -location $location
New-AzDnsZone -Name $DnsZoneName -ResourceGroupName $rgname

#Get Azure Load Balancer DNS Name 
$lb = Get-AzLoadBalancer | where {$_.name -like '*uag*'}
$temp = Get-AzResource -Id $lb.FrontendIpConfigurations.PublicIpAddress.Id
$Dnsvalue = Get-AzPublicIpAddress -Name $temp.name -ResourceGroupName $temp.ResourceGroupName

#Display the CNAME value you should use to create the DNS record on your third-party provider
Write-Host -BackgroundColor Green "Use the following DNS value to create the CNAME record on your External DNS Provider":
write-host -BackgroundColor Green $Dnsvalue.DnsSettings.Fqdn

#create DNS CNAME Record
New-AzDnsRecordSet -Name $DNSExteralName -RecordType CNAME -ZoneName $DnsZoneName -ResourceGroupName $rgname -Ttl 3600 -DnsRecords (New-AzDnsRecordConfig -Cname $Dnsvalue.DnsSettings.Fqdn)

#show your DNS record
Get-AzDnsRecordSet -Name $DNSExteralName -ZoneName $DnsZoneName -ResourceGroupName $rgname -RecordType CNAME
