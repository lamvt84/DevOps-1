CREATE TABLE [dbo].[Batch]
(
	[Batch_Id] INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_Batch PRIMARY KEY CLUSTERED,
	[Source_Name] VARCHAR(30),
	[Batch_Type] VARCHAR(20),
	[Batch_Status] INT,
	[Updated_Time] DATETIMEOFFSET,
	[Created_Time] DATETIMEOFFSET	
)
