# You can download all SharePoint solution files (wsp) from SharePoint farm solution store
$dirName = "C:\WSP"

Write-Host Exporting solutions to $dirName

foreach ($solution in Get-SPSolution)
{
    $id = $Solution.SolutionID
    $title = $Solution.Name
    $filename = $Solution.SolutionFile.Name
    Write-Host "Exporting ‘$title’ to …\$filename" -nonewline

    try 
    {
        $solution.SolutionFile.SaveAs("$dirName\$filename")
        Write-Host " – done" -foreground green
    }
    catch
    {
        Write-Host " – error : $_" -foreground red
    }
}
