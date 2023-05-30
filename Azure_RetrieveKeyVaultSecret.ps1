#Set the environment variables for the AAD application's client ID and client secret:
$env:AZURE_CLIENT_ID = '<client-id>'
$env:AZURE_CLIENT_SECRET = '<client-secret>'

#Retrieve an access token for the AAD application:
$tenantId = '<tenant-id>'
$resource = 'https://vault.azure.net'
$body = @{
    grant_type    = 'client_credentials'
    client_id     = $env:AZURE_CLIENT_ID
    client_secret = $env:AZURE_CLIENT_SECRET
    resource      = $resource
}
$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantId/oauth2/token" -Method POST -Body $body
$accessToken = $tokenResponse.access_token

#Use the access token to retrieve the secret:
$keyVaultName = '<key-vault-name>'
$secretName = '<secret-name>'
$uri = "https://$keyVaultName.vault.azure.net/secrets/$secretName?api-version=2016-10-01"
$secretResponse = Invoke-RestMethod -Uri $uri -Headers @{ Authorization = "Bearer $accessToken" }
$secretValue = $secretResponse.value