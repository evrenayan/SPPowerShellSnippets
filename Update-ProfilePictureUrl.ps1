# Update user profile picture url after mysite address changed. (Microsoft SharePoint on-premise farm)

$oldMySite = "http://personalsites.domain.local"
$newMySite = "http://mysites.domain.local"
$site = Get-SPSite $newMySite 
$SPServiceContext = Get-SPServiceContext $site 
 
$userProfileManager = New-Object Microsoft.Office.Server.UserProfiles.UserProfileManager($SPServiceContext) 
$userProfiles = $userProfileManager.GetEnumerator() 
foreach ($userProfile in $userProfiles) 
{ 
  if ($userProfile["PictureURL"] -ne '') 
  { 
    $oldProfileImageUrl = $userProfile["PictureURL"].toString() 
    $newProfileImageUrl = $oldProfileImageUrl -Replace $oldMySite, $newMySite
    write-host "Old Profile Image = " $oldProfileImageUrl " --> New Profile Image = " $newProfileImageUrl 
    $userProfile["PictureURL"].Value = $newProfileImageUrl 
    $userProfile.Commit()
  }  
}
