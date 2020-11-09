/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
:setvar InitiatorCertPath ""
:setvar InitiatorTCP ""
:setvar TargetCertPath ""
:setvar TargetTCP ""
:setvar SqlServiceAccount "ServiceAccount"

USE [master]
GO

GRANT CONNECT ON ENDPOINT::InitiatorEndPoint TO [$(SqlServiceAccount)];
GO

USE [$(DatabaseName)]
GO

DECLARE @isExists INT
DECLARE @fileInput VARCHAR(150) = '$(InitiatorCertPath)'
EXEC master.dbo.xp_fileexist @fileInput, @isExists OUTPUT
IF (@isExists = 1) 
    CREATE CERTIFICATE [InitiatorCertificate] 
       AUTHORIZATION [InitiatorUser]
       FROM FILE = '$(InitiatorCertPath)'
ELSE
    PRINT '$(InitiatorCertPath) is not existed. Please re-do manually'
GO

BACKUP CERTIFICATE [TargetCertificate]
  TO FILE = '$(TargetCertPath)'
GO

CREATE ROUTE [//WalletAccount/Route/Source]
    WITH 
        SERVICE_NAME = N'//WalletAccount/Service/Source',
        ADDRESS = '$(InitiatorTCP)';
CREATE ROUTE [//WalletTransaction/Route/Source]
    WITH 
        SERVICE_NAME = N'//WalletTransaction/Service/Source',
        ADDRESS = '$(InitiatorTCP)';
CREATE ROUTE [//WalletProperty/Route/Source]
    WITH 
        SERVICE_NAME = N'//WalletProperty/Service/Source',
        ADDRESS = '$(InitiatorTCP)';


USE [msdb]
GO
CREATE ROUTE [//WalletAccount/Route/Target]
    WITH 
        SERVICE_NAME = '//WalletAccount/Service/Target',
        ADDRESS = N'LOCAL';
CREATE ROUTE [//WalletTransaction/Route/Target]
    WITH 
        SERVICE_NAME = '//WalletTransaction/Service/Target',
        ADDRESS = N'LOCAL';
CREATE ROUTE [//WalletProperty/Route/Target]
    WITH 
        SERVICE_NAME = '//WalletProperty/Service/Target',
        ADDRESS = N'LOCAL';