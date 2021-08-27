# Script installs all solutions which has state of "Not Deployed" to all web applications (Microsoft SharePoint on-premise farm)

Get-SPSolution | ForEach-Object { if (!$_.Deployed) {
 If ($_.ContainsWebApplicationResource -eq $False) {
    Install-SPSolution -Identity $_ -GACDeployment
 }
else {
    Install-SPSolution -Identity $_ -AllWebApplications -GACDeployment
  }
 }
}
