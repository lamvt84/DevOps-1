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

/* Mail Config
DECLARE @mailTable TABLE ([Id] INT NOT NULL,
	[SenderEmail] VARCHAR(50), 
    [ToMail] VARCHAR(50), 
    [CCMail] VARCHAR(500), 
    [Subject] NVARCHAR(250), 
    [Message] NVARCHAR(MAX), 
    [IsResend] BIT, 
    [ServiceId] INT, 
    [SmsEmail] INT, 
    [LangId] INT,
    [DataSign] VARCHAR(100),
    [IsEnable] BIT
)
*/

DECLARE @tempAlertConfig TABLE
(
	[Id] INT,
    [Name] NVARCHAR(100)
)

INSERT INTO @tempAlertConfig SELECT 1,'Alert when service is down'
INSERT INTO @tempAlertConfig SELECT 2, 'Alert when service is up'

SET IDENTITY_INSERT dbo.AlertConfig ON
MERGE INTO dbo.AlertConfig a
USING @tempAlertConfig t ON a.Id = t.Id
WHEN NOT MATCHED THEN
    INSERT (Id, Name) VALUES (t.Id, t.Name);
SET IDENTITY_INSERT dbo.AlertConfig OFF

DECLARE @tempEmail TABLE 
(
	[Id] INT,
    AlertConfigId INT,
	[SenderName] VARCHAR(50)
)

INSERT INTO @tempEmail SELECT 1,1,'MONITOR SYSTEM'
INSERT INTO @tempEmail SELECT 2,2,'MONITOR SYSTEM'

SET IDENTITY_INSERT dbo.EmailConfig ON
MERGE INTO dbo.EmailConfig a
USING @tempEmail t ON a.Id = t.Id
WHEN NOT MATCHED THEN
    INSERT (Id, AlertConfigId, SenderName) VALUES (t.Id, t.AlertConfigId, t.SenderName);
SET IDENTITY_INSERT dbo.EmailConfig OFF