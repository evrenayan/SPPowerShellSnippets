# Script creates State Service Application for your farm (Microsoft SharePoint on-premise farm)

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

$ServiceAppName = "State Service Application"
$ServiceAppProxyName ="State Service Application"
$DatabaseName ="SP16_StateService"

$StateServiceApp = New-SPStateServiceApplication -Name $ServiceAppName

$Database = New-SPStateServiceDatabase -Name $DatabaseName -ServiceApplication $StateServiceApp 

New-SPStateServiceApplicationProxy -Name $ServiceAppProxyName -ServiceApplication $StateServiceApp -DefaultProxyGroup 
 
Initialize-SPStateServiceDatabase -Identity $Database
Write-host "State Service Application Created Successfully!"
