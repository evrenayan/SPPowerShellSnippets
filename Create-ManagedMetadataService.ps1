# Script creates Managed Metadata Service Application (Microsoft SharePoint on-premise farm)

$newSPMetadataServiceApplication = @{
    Name                 = "Managed Metadata Service Application"
    DatabaseName         = "TEST_Managed_Metadata_DB"
    ApplicationPool      = "DefaultAppPool"
    FullAccessAccount    = "DOMAIN\spapppool"
    DatabaseServer       = "DCSQL\SP2016"
}

$MMSApp = New-SPMetadataServiceApplication @newSPMetadataServiceApplication
New-SPMetadataServiceApplicationProxy -Name "Managed Metadata Service Application Proxy" -ServiceApplication $MMSApp -DefaultProxyGroup
