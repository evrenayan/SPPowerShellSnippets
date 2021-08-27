Function Add-FarmAdmin ([string]$userid)
{
    # Connect to Central Administration web applicaton
    $adminWebApp = Get-SPWebApplication –IncludeCentralAdministration | where {$_.DisplayName –like "SharePoint Central Administration*"};

    # Add user to the Farm Administrators SharePoint Group
    New-SPUser –UserAlias $userid –Web $adminWebApp.URL –Group "Farm Administrators";

    # Give permission to Admin Content database
    $adminContentDB = Get-SPContentDatabase –WebApplication $adminWebApp;
    Add-SPShellAdmin -Database $adminContentDB -Username $userid;
    
    # Give permission to all content databases
    $contentDBs = Get-SPContentDatabase;
    foreach ($contentDB in $contentDBs) {
        Add-SPShellAdmin -Database $contentDB -Username $userid;
    }
}

Add-FarmAdmin –userid "domain\dev.user"
