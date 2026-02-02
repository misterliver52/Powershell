# Install the Azure PowerShell module if not already installed
# Run this command if you haven't installed the module before
# Install-Module -Name Az

# Connect to your Azure account
Connect-AzAccount
Set-AzContext -SubscriptionId 31bb8307-fa5b-4c5c-9e26-f30cbe73e42c

# Define the resource group name and the resources' name or ID
$resourceGroupName = "<ResourceGroupName>"

$resourceNames = @("<ResourceNames>")

# Define the tags you want to update
$newTags = @{
 #   "Environment" = "uat"
    "<tagName1>" = "<value1>"
    "<tagName2>" = "<value2>"
}

# Update the tags for each resource
foreach ($resourceName in $resourceNames) {
    # Get the resource by name
    $resource = Get-AzResource -ResourceGroupName $resourceGroupName -Name $resourceName

    # Update or add the tags
    foreach ($tagKey in $newTags.Keys) {
        $tagValue = $newTags[$tagKey]
        $resource.Tags[$tagKey] = $tagValue
    }

    # Update the resource with the new tags
    $resource | Set-AzResource -Force

}
