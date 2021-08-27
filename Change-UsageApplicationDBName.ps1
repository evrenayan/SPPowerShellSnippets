# You can change WSS Usage Service Application database name with this script
# First of all you should change database name on SQL Server Side. Above codes should be executed on SQL Server Management Studio Query Tool
USE master;
GO
ALTER DATABASE WSS_UsageApplication SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
ALTER DATABASE WSS_UsageApplication Modify Name = 'TEST_UsageApplication'
GO
ALTER DATABASE TEST_UsageApplication SET MULTI_USER;
GO

# And then change Service Application database name on Powershell side
Set-SPUsageApplication -Identity "WSS_UsageApplication" -DatabaseName "TEST_UsageApplication" -DatabaseServer "DATABASE_SERVERNAME"
