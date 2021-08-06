#Define your subscription, resource group and Location
$Sub1           = "Azure Subscription 1"
$RG           = "Your-Azure-ResourceGroup-For-Horizon"
$Location     = "eastus"

#Define your VNet and Subnet Settings
$VNetHorizonPrefix = "172.16.0.0/20"
$VNetHorizonName      = "VNET-Horizon"
$VSubNetVMName   = "VM-Subnet"
$VSubNetMGMTName   = "MGMT-Subnet"
$VSubNetDMZName   = "DMZ-Subnet"
$SubnetVMPrefix    = "172.16.0.0/22"
$SubnetMGMTPrefix    = "172.16.4.0/27"
$SubnetDMZPrefix    = "172.16.4.32/27"

#Define your gateway subnet settings
$GWSubName     = "GatewaySubnet"
$GWName        = "HSoA-VNetGW-01"
$GWSubPrefix   = "172.16.4.64/27"
$GWIPName1     = "HSoA-VNetGW-01-IP"
$GWIPconfName1 = "gwipconf1"

#Your Custom DNS (Same from AD DS)
$DNS1           = "10.0.0.4"
$DNS2           = "10.0.0.250"

# Connect to your subscription and create a new resource group

$azsubscription = Select-AzSubscription -SubscriptionName $Sub1
New-AzResourceGroup -Name $RG -Location $Location

# Create virtual networks and Subnets for Horizon Service

$VSubNet1 = New-AzVirtualNetworkSubnetConfig -Name $VSubNetVMName -AddressPrefix $SubnetVMPrefix
$VSubNet2 = New-AzVirtualNetworkSubnetConfig -Name $VSubNetMGMTName -AddressPrefix $SubnetMGMTPrefix
$VSubNet3 = New-AzVirtualNetworkSubnetConfig -Name $VSubNetDMZName -AddressPrefix $SubnetDMZPrefix
$GWSubNet1 = New-AzVirtualNetworkSubnetConfig -Name $GWSubName -AddressPrefix $GWSubPrefix
$vnetHSoA = New-AzVirtualNetwork -Name $VNetName1 -ResourceGroupName $RG -Location $Location -AddressPrefix $VNet1Prefix -Subnet $VSubNet1,$VSubNet2,$VSubNet3,$GWSubNet1 -DnsServer $DNS1,$DNS2

# Create VPN gateway

$gwpip1    = New-AzPublicIpAddress -Name $GWIPName1 -ResourceGroupName $RG -Location $Location -AllocationMethod Dynamic
$vnet1     = Get-AzVirtualNetwork -Name $VNetHorizonName -ResourceGroupName $RG
$subnet1   = Get-AzVirtualNetworkSubnetConfig -Name $GWSubName -VirtualNetwork $VNetHorizonName
$gwipconf1 = New-AzVirtualNetworkGatewayIpConfig -Name $GWIPconfName1 -Subnet $subnet1 -PublicIpAddress $gwpip1

New-AzVirtualNetworkGateway -Name $GWName1 -ResourceGroupName $RG -Location $Location -IpConfigurations $gwipconf1 -GatewayType Vpn -VpnType RouteBased -GatewaySku VpnGw1
