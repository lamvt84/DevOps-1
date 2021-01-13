﻿CREATE TABLE [dbo].[SmsConfig]
(
	[Id] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_SmsConfig PRIMARY KEY CLUSTERED,
	[AlertConfigId] INT NOT NULL,
	[AccountName] VARCHAR(30) NULL,
	[Mobile] VARCHAR(30) NULL,
	[Message] VARCHAR(130) NULL,
	[IsResend] BIT NOT NULL CONSTRAINT DF_SmsConfig_IsResend DEFAULT 0,
	[ServiceId] INT NOT NULL CONSTRAINT DF_SmsConfig_ServiceId DEFAULT 0, 
    [SmsEmailId] INT NOT NULL CONSTRAINT DF_SmsConfig_SmsEmailId DEFAULT 0, 
    [LangId] INT NOT NULL CONSTRAINT DF_SmsConfig_LangID DEFAULT 0, 
    [DataSign] VARCHAR(100) NULL, 
	[IsEnable] BIT DEFAULT 1,
    [CreatedTime] DATETIMEOFFSET NOT NULL CONSTRAINT DF_SmsConfig_CreatedTime DEFAULT SYSDATETIMEOFFSET(), 
    [UpdatedTime] DATETIMEOFFSET NULL
)