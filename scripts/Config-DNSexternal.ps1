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

#create DNS CNAME Record
New-AzDnsRecordSet -Name $DNSExteralName -RecordType CNAME -ZoneName $DnsZoneName -ResourceGroupName $rgname -Ttl 3600 -DnsRecords (New-AzDnsRecordConfig -Cname $Dnsvalue.DnsSettings.Fqdn)

#show your DNS record
Get-AzDnsRecordSet -Name $DNSExteralName -ZoneName $DnsZoneName -ResourceGroupName $rgname -RecordType CNAME
