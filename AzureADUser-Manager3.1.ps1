#Connect to Azure AD
Connect-AzureAD

#Get all users and their properties
$users = Get-AzureADUser -All $true | Select-Object UserPrincipalName, DisplayName, Mail, ObjectId, UserState

#Loop through each user and get their manager's email address
foreach ($user in $users) {
    $manager = Get-AzureADUserManager -ObjectId $user.ObjectId
    $user | Add-Member -MemberType NoteProperty -Name ManagerEmailAddress -Value $manager.Mail
}

#Select and output the desired properties to a CSV file
$filename = "AADUserManagerList_" + (Get-Date -Format "yyyyMMdd") + ".csv"
$path = "C:\Users\Bensmith\OneDrive - TK Elevator\Documents\DATA ANALYTICS\Powershell\ADUser Reports\" + $filename
$users | Select-Object UserPrincipalName, DisplayName, Mail, ManagerEmailAddress, UserState | Export-Csv -Path $path -NoTypeInformation

#Display a message indicating the CSV file location
Write-Host "The AAD user manager list has been exported to: $path"
