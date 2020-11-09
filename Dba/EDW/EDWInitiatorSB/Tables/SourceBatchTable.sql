CREATE TABLE [dbo].[SourceBatchTable]
(
	[Batch_Id] INT NOT NULL IDENTITY(1,1),
	[Batch_Name] VARCHAR(30),
	[Batch_Type] VARCHAR(10),
	[Created_Time] DATETIMEOFFSET,
	CONSTRAINT PK_SourceBatchTable PRIMARY KEY CLUSTERED (Batch_Name, Batch_Id)
)
