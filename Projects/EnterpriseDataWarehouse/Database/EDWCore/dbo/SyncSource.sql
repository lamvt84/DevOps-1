CREATE TABLE [dbo].[SyncSource]
(
	[Sync_Id] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_SyncSource PRIMARY KEY CLUSTERED,
	[Sync_Name] VARCHAR(30),
	[Batch_Id] INT,	
	[Sync_Status] INT,
	[Updated_Time] DATETIMEOFFSET,
	[Created_Time] DATETIMEOFFSET
)
