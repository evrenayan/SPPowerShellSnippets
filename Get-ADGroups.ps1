# Script writes all domain groups used to give SharePoint permissions to a csv file (Microsoft SharePoint on-premise farm)

$SPWebApp = Get-SPWebApplication http://portal

foreach ($SPSite in $SPWebApp.Sites)
{
    write-host -foregroundcolor green "Working on Site Collection: "$SPsite.RootWeb.Title 
    ##write-host -foregroundcolor green "Working on Site Collection: "$SPsite.RootWeb.URL
    $SiteURL = $SPsite.RootWeb.URL
    $ADgroup=Get-SPUser -Web $SiteURL -Limit ALL | Where { $_.IsDomainGroup }
    foreach($group in $ADgroup)
    {
        if($Output -notcontains $group.DisplayName)
        {
            write-host $group.DisplayName
            $Output += ($group.DisplayName)
            $users = new-object psobject
            $users | add-member noteproperty -name "Site Collection" -value $SPsite.RootWeb.Title
            $users | add-member noteproperty -name "Groups" -value $group.DisplayName
            $combinedusers += $users
        }
    } 
    $combinedusers | export-csv "C:\fakepath\group.csv" -notypeinformation
}
