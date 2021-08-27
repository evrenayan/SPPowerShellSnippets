# Script gets and writes user profile properties to a csv file from User Profile Service Application (Microsoft SharePoint on-premise farm)

$siteUrl = "http://portal.domain.local"
$outputFile = "c:\fakepath\sharepoint_user_profiles.csv"


Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
$serviceContext = Get-SPServiceContext -Site $siteUrl
$profileManager = New-Object Microsoft.Office.Server.UserProfiles.UserProfileManager($serviceContext);
$profiles = $profileManager.GetEnumerator()

$fields = @(
            "SID",
            "ADGuid",
            "AccountName",
            "FirstName",
            "LastName",
            "PreferredName",
            "Title",
            "Manager"
           )

$collection = @()

foreach ($profile in $profiles) {
   $user = "" | select $fields
   foreach ($field in $fields) {
     if($profile[$field].Property.IsMultivalued) {
       $user.$field = $profile[$field] -join "|"
     } else {
       $user.$field = $profile[$field].Value
     }
   }
   $collection += $user
}

$collection | Export-Csv $outputFile -NoTypeInformation
$collection |  Out-GridView
