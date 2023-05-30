#set variables
$pathToSave = "C:\users\bensmith\desktop\"
$subscriptionId = "31bb8307-fa5b-4c5c-9e26-f30cbe73e42c"


# Authenticate to Azure
Connect-AzAccount

# Specify the subscription ID you want to list resources for

Set-AzContext -SubscriptionId $subscriptionId

# Retrieve all resources in the specified subscription
$resources = Get-AzResource

# Create an array to store the output
$output = @()

# Loop through each resource and get its public and private IP addresses
foreach ($resource in $resources) {
    
    # Check if the resource has any tags
    if ($resource.Tags -ne $null) {
        $tags = $resource.Tags.GetEnumerator() | ForEach-Object { "$($_.Key): $($_.Value)" } | Sort-Object
    } else {
        $tags = "NULL"
    }
    
    # Create a hashtable to store the resource information
    $resourceInfo = @{
        "ResourceGroup" = $resource.ResourceGroupName
        "Name" = $resource.Name
        "Location" = $resource.Location
        "Type" = $resource.ResourceType
        "ManagedBy" = $resource.ManagedBy
        "Tags" = $tags -join "; "
        "Notes" = " "
    }
    # Add the resource information to the output array
    $output += New-Object PSObject -Property $resourceInfo
}
$ColumnOrder = "ResourceGroup","Name","Location","Type","ManagedBy","Tags","Notes"
# Export the output to a CSV file
$output | Select-Object $columnOrder | Export-Csv -Path $pathToSave"AzureResources_v2.2.csv" -NoTypeInformation
