$regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
$regPathWow6432Node = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"

$apps = @()

# Retrieve 64-bit application information
$apps += Get-ItemProperty -Path $regPath |
         Where-Object { $_.DisplayName -ne $null } |
         Select-Object -Property DisplayName, Publisher, InstallDate, DisplayVersion

# Retrieve 32-bit application information
$apps += Get-ItemProperty -Path $regPathWow6432Node |
         Where-Object { $_.DisplayName -ne $null } |
         Select-Object -Property DisplayName, Publisher, InstallDate, DisplayVersion

$apps | Sort-Object DisplayName | Export-Csv -Path "InstalledApps.csv" -NoTypeInformation