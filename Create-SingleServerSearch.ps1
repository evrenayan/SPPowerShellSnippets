# Script creates single server search service application (Microsoft SharePoint on-premise farm)

$saAppPoolName = "Search Service App Pool"

$searchServerName = (Get-ChildItem env:computername).value
$serviceAppName = "Search Service Application"
$searchDBName = "DEV_SearchService"

$saAppPool = Get-SPServiceApplicationPool $saAppPoolName

# Start Search Service Instance
Write-Host "Starting Search Service Instances..."
Start-SPEnterpriseSearchServiceInstance $searchServerName
Start-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance $searchServerName

# Create Search Service Application and Proxy
Write-Host "Creating Search Service Application and Proxy..."
$searchServiceApp = New-SPEnterpriseSearchServiceApplication -Name $serviceAppName -ApplicationPool $saAppPoolName -DatabaseName $searchDBName
$searchProxy = New-SPEnterpriseSearchServiceApplicationProxy -Name "$serviceAppName Proxy" -SearchApplication $searchServiceApp

# Create Topology
Write-Host "Creating Search Topology..."
$clone = $searchServiceApp.ActiveTopology.Clone()
$searchServiceInstance = Get-SPEnterpriseSearchServiceInstance
New-SPEnterpriseSearchAdminComponent –SearchTopology $clone -SearchServiceInstance $searchServiceInstance
New-SPEnterpriseSearchContentProcessingComponent –SearchTopology $clone -SearchServiceInstance $searchServiceInstance
New-SPEnterpriseSearchAnalyticsProcessingComponent –SearchTopology $clone -SearchServiceInstance $searchServiceInstance 
New-SPEnterpriseSearchCrawlComponent –SearchTopology $clone -SearchServiceInstance $searchServiceInstance 
New-SPEnterpriseSearchIndexComponent –SearchTopology $clone -SearchServiceInstance $searchServiceInstance
New-SPEnterpriseSearchQueryProcessingComponent –SearchTopology $clone -SearchServiceInstance $searchServiceInstance
$clone.Activate()

Write-Host "Search Service Configured Successfully!"
