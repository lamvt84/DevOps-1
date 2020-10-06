﻿CREATE TABLE [dbo].[AlertConfig]
(
	[Id] INT NOT NULL IDENTITY(1,1),
    [Name] NVARCHAR(100),    
    [PauseStatus] TINYINT NULL, 
    [PausePeriod] INT NULL,
    [CreatedTime] DATETIMEOFFSET NOT NULL CONSTRAINT DF_AlertConfig_CreatedTime DEFAULT SYSDATETIMEOFFSET(), 
    [UpdatedTime] DATETIMEOFFSET NULL, 
    CONSTRAINT PK_AlertConfig PRIMARY KEY CLUSTERED (Id)
)
