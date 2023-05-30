# Define the source and destination storage accounts
$sourceStorageAccountName = "sourcestorageaccount"
$sourceStorageAccountKey = "sourcestorageaccountkey"
$sourceFileShareName = "sourcefileshare"

$destinationStorageAccountName = "destinationstorageaccount"
$destinationStorageAccountKey = "destinationstorageaccountkey"
$destinationFileShareName = "destinationfileshare"

# Connect to the source storage account
$sourceStorageContext = New-AzureStorageContext -StorageAccountName $sourceStorageAccountName -StorageAccountKey $sourceStorageAccountKey

# Get a reference to the source file share
$sourceFileShare = Get-AzureStorageShare -Context $sourceStorageContext -Name $sourceFileShareName

# Create a destination storage context
$destinationStorageContext = New-AzureStorageContext -StorageAccountName $destinationStorageAccountName -StorageAccountKey $destinationStorageAccountKey

# Create a new file share in the destination storage account
New-AzureStorageShare -Context $destinationStorageContext -Name $destinationFileShareName

# Get a reference to the destination file share
$destinationFileShare = Get-AzureStorageShare -Context $destinationStorageContext -Name $destinationFileShareName

# Copy the files from the source file share to the destination file share
$sourceFileShare | Get-AzureStorageFile | Start-AzureStorageFileCopy -DestShare $destinationFileShareName -DestContext $destinationStorageContext

# Delete the source file share
Remove-AzureStorageShare -Context $sourceStorageContext -Name $sourceFileShareName
