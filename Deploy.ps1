
# Define env

# Set SQLServer, database and an account that have write permissions
$SQLInstnce = "sqlplaceholder"
$Database = "dbplaceholder"

# Path to the extension zip file
$ExtensionSource = "urlplaceholder"

# SHA256 hash of the zip file (Get-FileHash)
$Hash = "hashplaceholder"


# Install the extension in the database
& $PSScriptRoot\Config.ps1 -Instance $SQLInstnce  -Database $Database -Credentials $Credentials -ExtensionSource $ExtensionSource -Hash $Hash



