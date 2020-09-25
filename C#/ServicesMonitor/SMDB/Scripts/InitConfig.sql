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
IF NOT EXISTS (SELECT 1 FROM dbo.EmailConfig WHERE Id = 1)
BEGIN
    SET IDENTITY_INSERT dbo.EmailConfig ON
    INSERT dbo.EmailConfig(Id,[AlertConfigId],[SenderName],[ToMail],[CCMail],[Subject],[Message],[IsResend],[ServiceId],[SmsEmailId],[LangId],[DataSign],[IsEnable],[CreatedTime],[UpdatedTime]) 
        VALUES (1,1,'MONITOR SYSTEM','devops@1fintech.vn','','[PAYMOBI] ALERT - SERVICE ERROR','<b>ALERT</b><br /><br /><b>CHECK ID: </b>{check_id}<br />{service_list}<br /><br />Sent by monitor system',
                            0,0,0,0,'befea2e192a917222d09c0d4c2f34466',1, SYSDATETIMEOFFSET(), NULL);
    SET IDENTITY_INSERT dbo.EmailConfig OFF
END

IF NOT EXISTS (SELECT 1 FROM dbo.AlertConfig WHERE Id = 1)
BEGIN
    SET IDENTITY_INSERT dbo.AlertConfig ON
    INSERT dbo.AlertConfig(Id,[Name],[PauseStatus],[PausePeriod],[CreatedTime],[UpdatedTime]) 
        VALUES (1,'Service Alert Config', 0, 0, SYSDATETIMEOFFSET(), NULL)
    SET IDENTITY_INSERT dbo.AlertConfig OFF
END

TRUNCATE TABLE dbo.GroupType

INSERT dbo.GroupType
VALUES (1,N'HealthCheck Api',N'Check via health check function'),
       (2,N'Powershell Check',N'Check via powershell script with IP and Port')