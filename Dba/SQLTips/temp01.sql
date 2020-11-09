SELECT '//WalletProperty/' + REPLACE(name,'_','') + '/Request' FROM sys.tables WHERE [type] = 'U'
--AND name like 'Account%' OR name like 'User%'
ORDER BY name

SELECT '//WalletTransaction/' + REPLACE(name,'_','') + '/Receive' FROM sys.tables WHERE [type] = 'U'
ORDER BY name

DECLARE @Cmd NVARCHAR(4000);
SET @Cmd = N'USE ServiceBrokerInitiatorDB;
CREATE ROUTE InstTargetRoute
WITH SERVICE_NAME =
       N''//TgtDB/2InstSample/TargetService'',
     ADDRESS = N''TCP://labdw:4022'';';

PRINT @Cmd;




DECLARE @TimeZone VARCHAR(50)
EXEC MASTER.dbo.xp_regread 'HKEY_LOCAL_MACHINE','SYSTEM\CurrentControlSet\Control\TimeZoneInformation','TimeZoneKeyName',@TimeZone OUT
SELECT @TimeZone

SELECT GETDATE() AT TIME ZONE 'SE Asia Standard Time' AS ChangeDateOffset, SYSDATETIMEOFFSET()


 @status IN ( 1, 2, 5, 8 ) –created (1), running (2), canceled (3), failed (4), pending (5), ended unexpectedly (6), succeeded (7), stopping (8), and completed (9).