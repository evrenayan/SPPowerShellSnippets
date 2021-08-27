# Script creates three server Search Service Application (Microsoft SharePoint on-premise farm)

$App1 = "SRVAPP1"
$App2 = "SRVWF1"
$App3 = "SRVWF2"
$SearchAppPoolName = "SharePoint_SearchApp"
$SearchAppPoolAccountName = "DOMAIN\SearchSvc"
$SearchServiceName = "Search Service Application"
$SearchServiceProxyName = "Search Service Application Proxy"
$DatabaseName = "TEST_Search_Admin"

Add-PsSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
#Create a Search Service Application Pool
$spAppPool = New-SPServiceApplicationPool -Name $SearchAppPoolName -Account $SearchAppPoolAccountName -Verbose
 
#Start Search Service Instance on all Application Servers
Start-SPEnterpriseSearchServiceInstance $App1 -ErrorAction SilentlyContinue
Start-SPEnterpriseSearchServiceInstance $App2 -ErrorAction SilentlyContinue
Start-SPEnterpriseSearchServiceInstance $App3 -ErrorAction SilentlyContinue
Start-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance $App1 -ErrorAction SilentlyContinue
Start-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance $App2 -ErrorAction SilentlyContinue
Start-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance $App3 -ErrorAction SilentlyContinue
 
#Create Search Service Application
$ServiceApplication = New-SPEnterpriseSearchServiceApplication -Partitioned -Name $SearchServiceName -ApplicationPool $spAppPool.Name -DatabaseName $DatabaseName
 
#Create Search Service Proxy
New-SPEnterpriseSearchServiceApplicationProxy -Partitioned -Name $SearchServiceProxyName -SearchApplication $ServiceApplication

$clone = $ServiceApplication.ActiveTopology.Clone()
$App1SSI = Get-SPEnterpriseSearchServiceInstance -Identity $App1
$App2SSI = Get-SPEnterpriseSearchServiceInstance -Identity $App2
$App3SSI = Get-SPEnterpriseSearchServiceInstance -Identity $App3

#We need only one admin component
New-SPEnterpriseSearchAdminComponent –SearchTopology $clone -SearchServiceInstance $App1SSI
 
#We need one content processing components for HA
New-SPEnterpriseSearchContentProcessingComponent –SearchTopology $clone -SearchServiceInstance $App1SSI
 
#We need one analytics processing components for HA
New-SPEnterpriseSearchAnalyticsProcessingComponent –SearchTopology $clone -SearchServiceInstance $App1SSI
 
#We need one crawl components for HA
New-SPEnterpriseSearchCrawlComponent –SearchTopology $clone -SearchServiceInstance $App1SSI
 
#We need three query processing components for HA
New-SPEnterpriseSearchQueryProcessingComponent –SearchTopology $clone -SearchServiceInstance $App1SSI
New-SPEnterpriseSearchQueryProcessingComponent –SearchTopology $clone -SearchServiceInstance $App2SSI 
New-SPEnterpriseSearchQueryProcessingComponent –SearchTopology $clone -SearchServiceInstance $App3SSI

#Set the primary and replica index location; ensure these drives and folders exist on application servers
$PrimaryIndexLocation = "E:\SearchIndex\Primary"
$ReplicaIndexLocation = "E:\SearchIndex\Replica"
 
#We need two index partitions and replicas for each partition. Follow the sequence.
New-SPEnterpriseSearchIndexComponent –SearchTopology $clone -SearchServiceInstance $App2SSI -RootDirectory $PrimaryIndexLocation -IndexPartition 0
New-SPEnterpriseSearchIndexComponent –SearchTopology $clone -SearchServiceInstance $App1SSI -RootDirectory $ReplicaIndexLocation -IndexPartition 0
New-SPEnterpriseSearchIndexComponent –SearchTopology $clone -SearchServiceInstance $App3SSI -RootDirectory $ReplicaIndexLocation -IndexPartition 0

New-SPEnterpriseSearchIndexComponent –SearchTopology $clone -SearchServiceInstance $App3SSI -RootDirectory $PrimaryIndexLocation -IndexPartition 1
New-SPEnterpriseSearchIndexComponent –SearchTopology $clone -SearchServiceInstance $App2SSI -RootDirectory $ReplicaIndexLocation -IndexPartition 1
New-SPEnterpriseSearchIndexComponent –SearchTopology $clone -SearchServiceInstance $App1SSI -RootDirectory $ReplicaIndexLocation -IndexPartition 1

$clone.Activate()

$ssa = Get-SPEnterpriseSearchServiceApplication
Get-SPEnterpriseSearchTopology -Active -SearchApplication $ssa
