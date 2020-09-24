﻿CREATE TABLE [dbo].[Services]
(
	Id INT NOT NULL IDENTITY(1,1),
	GroupId INT NOT NULL CONSTRAINT DF_Services_GroupId DEFAULT 0,
	Name VARCHAR(100),
	Description NVARCHAR(250),
	Url VARCHAR(500),
	Params VARCHAR(500),
	ResponseCode VARCHAR(100),
	CreatedTime DATETIMEOFFSET NOT NULL CONSTRAINT DF_Services_CreatedTime DEFAULT SYSDATETIMEOFFSET(),
	UpdatedTime DATETIMEOFFSET,
	Enable TINYINT NOT NULL CONSTRAINT DF_Services_Enable DEFAULT 1,
	Status TINYINT NOT NULL CONSTRAINT DF_Services_Status DEFAULT 0,
	CONSTRAINT PK_Services PRIMARY KEY CLUSTERED (Id)
)
