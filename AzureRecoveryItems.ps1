# Install Az module if not already installed
#Install-Module Az

# Set variables
$AzureSubscriptionName = "NA.REPORTING"

# Connect to Azure
Connect-AzAccount

# Select the subscription to use
Select-AzSubscription -SubscriptionName $AzureSubscriptionName

# Get the list of resource groups in the subscription
$ResourceGroups = Get-AzResourceGroup

# Loop through each resource group
foreach ($ResourceGroup in $ResourceGroups)
{
    Write-Host "Resource Group:" $ResourceGroup.ResourceGroupName
    
    # Get the list of recovery services vaults in the resource group
    $Vaults = Get-AzRecoveryServicesVault -ResourceGroupName $ResourceGroup.ResourceGroupName
    
    # Loop through each recovery services vault
    foreach ($Vault in $Vaults)
    {
        Write-Host "Recovery Services Vault:" $Vault.Name
        
        # Get the list of backup containers in the recovery services vault
        $BackupContainers = Get-AzRecoveryServicesBackupContainer -ContainerType "Azure VM" -VaultId $Vault.Id -ResourceGroupName $ResourceGroup.ResourceGroupName
        
        # Loop through each backup container
        foreach ($Container in $BackupContainers)
        {
            # Get the list of backup items in the backup container
            $BackupItems = Get-AzRecoveryServicesBackupItem -Container $Container -VaultId $Vault.Id -ResourceGroupName $ResourceGroup.ResourceGroupName
            
            # Loop through each backup item
            foreach ($Item in $BackupItems)
            {
                # Get the list of workload types in the backup item
                $WorkloadTypes = (Get-AzRecoveryServicesBackupItem -ItemId $Item.Id -VaultId $Vault.Id -ResourceGroupName $ResourceGroup.ResourceGroupName).ItemType
                
                # Output the workload types
                Write-Host "Backup Container:" $Container.Name "Backup Item:" $Item.Name "Workload Types:" $WorkloadTypes
            }
        }
    }
}
