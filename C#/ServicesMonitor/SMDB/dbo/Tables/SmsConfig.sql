﻿CREATE TABLE [dbo].[SmsConfig]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[AccountName] VARCHAR(30) NULL,
	[Mobile] VARCHAR(30) NULL,
	[Message] VARCHAR(130) NULL,
	[IsResend] BIT NULL DEFAULT 0,
	[ServiceId] INT NULL DEFAULT 0, 
    [SmsEmailId] INT NULL DEFAULT 0, 
    [LangId] INT NULL DEFAULT 0, 
    [DataSign] VARCHAR(100) NULL, 
	[IsEnable] BIT DEFAULT 1,
    [CreatedTime] DATETIMEOFFSET NULL DEFAULT SYSDATETIMEOFFSET(), 
    [UpdatedTime] DATETIMEOFFSET NULL, 
    CONSTRAINT PK_SmsConfig PRIMARY KEY CLUSTERED (Id)
)
