# Script first adds all solutions in specified directory to SharePoint solution store and then deploys solutions to web applications (Microsoft SharePoint on-premise farm)

Add-PSSnapin Microsoft.SharePoint.PowerShell -erroraction SilentlyContinue
 
Function WaitForInsallation([string] $SolutionName)
{
        Write-Host -NoNewline "Waiting for deployment job to complete" $SolutionName "."
        $WSPSol = Get-SPSolution $SolutionName
        while($wspSol.JobExists)
        {
            sleep 2
            Write-Host -NoNewline "."
            $wspSol = Get-SPSolution $SolutionName
        }
        Write-Host "job Completed" -ForegroundColor green
}
 
Function Deploy-SPSolution ($WSPFolderPath)
{
    $WSPFiles = Get-childitem $WspFolderPath | where {$_.Name -like "*.wsp"}

    ForEach($File in $wspFiles)
    {
        $wsp = Get-SPSolution | Where {$_.Name -eq $File.Name}
 
        if($wsp -eq $null)
        {
            write-host "Adding WSP solution:"$File.Name
            Add-SPSolution -LiteralPath ($WspFolderPath + "\" + $file.Name)
        }
        else
        {
            write-host "Solution already exists!"

        }
    }
}
 
try
{
        Deploy-SPSolution "C:\WSPFiles"
}
catch
{
    write-host $_.exception
}
