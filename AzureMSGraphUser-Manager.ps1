# Connect to Microsoft Graph API
Connect-MgGraph -Scopes 'User.Export.All'

# Define the properties to retrieve
$properties = 'employeeId,displayName,userPrincipalName,mail,manager($select=displayName,userPrincipalName,mail),accountEnabled'

# Retrieve the users and their properties
$users = Get-MgUser -Select $userProperties

# Create a custom object for each user with the desired properties
$usersData = foreach ($user in $users) {
    # Retrieve the manager's information separately for each user
    $manager = Get-MgUserManager -UserId $user.Id -Select 'displayName,userPrincipalName,mail'
    
    [pscustomobject]@{
        EmployeeId = $user.employeeId
        DisplayName = $user.displayName
        UserPrincipalName = $user.userPrincipalName
        Mail = $user.mail
        Manager = $manager.displayName
        ManagerEmail = $manager.mail
        AccountEnabled = $user.accountEnabled
    }
}

# Get the current datestamp
$dateStamp = Get-Date -Format 'yyyyMMdd'

# Build the CSV filename with the datestamp
$csvFileName = "C:\Users\Bensmith\OneDrive - TK Elevator\Documents\DATA ANALYTICS\Powershell\ADUser ReportsUsersData_$dateStamp.csv"

# Export the user data to the CSV file
$usersData | Export-Csv -Path $csvFileName -NoTypeInformation

# Output the CSV file path
Write-Host "User data exported to: $csvFileName"