﻿CREATE TABLE [dbo].[Groups]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[GroupTypeId] INT,
	Name VARCHAR(100),
	Description VARCHAR(500),	
	CreatedTime DATETIMEOFFSET NOT NULL CONSTRAINT DF_Groups_CreatedTime DEFAULT SYSDATETIMEOFFSET(),
	UpdatedTime DATETIMEOFFSET,
	CONSTRAINT PK_ServicesGroup PRIMARY KEY CLUSTERED (Id)
)
