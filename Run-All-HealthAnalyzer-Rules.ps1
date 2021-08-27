# Script starts SharePoint timerjob for running all health analyzer rules (Microsoft SharePoint on-premise farm)

$snapin = Get-PSSnapin | Where-Object {$_.Name -eq 'Microsoft.SharePoint.Powershell'}
if ($snapin -eq $null) {
  Write-Host "Loading SharePoint Powershell Snapin"
  Add-PSSnapin "Microsoft.SharePoint.Powershell"
}

Get-SPTimerJob | Where {$_.Name -like "*Health*" -and $_.Name -like "*-all-*"} | Start-SPTimerJob
