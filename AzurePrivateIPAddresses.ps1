Connect-AzAccount
$subscriptionId = "31bb8307-fa5b-4c5c-9e26-f30cbe73e42c"
$reportName = "AzureVM_IPs.csv"
$pathToSave = "C:\Users\bensmith\desktop\"
Select-AzSubscription $subscriptionId
$report = @()
$vms = Get-AzVM
#$publicIps = Get-AzPrivateIpAddress 
$nics = Get-AzNetworkInterface | ?{ $_.VirtualMachine -NE $null} 
foreach ($nic in $nics) { 
    $info = "" | Select VmName, ResourceGroupName, Region, VmSize, VirtualNetwork, Subnet, PrivateIpAddress, OsType, PublicIPAddress, NicName, ApplicationSecurityGroup 
    $vm = $vms | ? -Property Id -eq $nic.VirtualMachine.id 
    foreach($privateIp in $privateIps) { 
        if($nic.IpConfigurations.id -eq $privateIp.ipconfiguration.Id) {
            $info.PrivateIPAddress = $privateIp.ipaddress
            } 
        } 
        $info.OsType = $vm.StorageProfile.OsDisk.OsType 
        $info.VMName = $vm.Name 
        $info.ResourceGroupName = $vm.ResourceGroupName 
        $info.Region = $vm.Location 
        $info.VmSize = $vm.HardwareProfile.VmSize
        $info.VirtualNetwork = $nic.IpConfigurations.subnet.Id.Split("/")[-3] 
        $info.Subnet = $nic.IpConfigurations.subnet.Id.Split("/")[-1] 
        $info.PrivateIpAddress = $nic.IpConfigurations.PrivateIpAddress
        $info.PublicIPAddress = $nic.IpConfigurations.PublicIpAddress 
        $info.NicName = $nic.Name 
        $info.ApplicationSecurityGroup = $nic.IpConfigurations.ApplicationSecurityGroups.Id 
        $report+=$info 
    } 
$report | ft VmName, ResourceGroupName, Region, VmSize, VirtualNetwork, Subnet, PrivateIpAddress, OsType, PublicIPAddress, NicName, ApplicationSecurityGroup 
$report | Export-CSV $pathToSave+"\AzureVM_LAN_IPs.csv"