CREATE TABLE [dbo].[SyncProcMapping]
(
	[Id] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_SyncProcMapping PRIMARY KEY CLUSTERED,
	[Sync_Name] VARCHAR(30),
	[Proc_Name] VARCHAR(150),
	[Message_Type] VARCHAR(256),
	[Service_Name] VARCHAR(512)
)
