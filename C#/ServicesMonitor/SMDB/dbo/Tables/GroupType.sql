CREATE TABLE [dbo].[GroupType]
(
	[Id] INT NOT NULL, 
    [Name] NVARCHAR(50) NULL, 
    [Description] NVARCHAR(250) NULL,
    CONSTRAINT PK_GroupType PRIMARY KEY CLUSTERED (Id)
)
