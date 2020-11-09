CREATE TABLE [dbo].[ErrorLog]
(
	[ErrorLogID] [int] IDENTITY(1,1) NOT NULL,
	[ErrorTime] DATETIMEOFFSET NOT NULL,
	[UserName] [sysname] NOT NULL,
	[ErrorNumber] [int] NOT NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorProcedure] [nvarchar](126) NULL,
	[ErrorLine] [int] NULL,
	[ErrorMessage] [nvarchar](4000) NOT NULL,
	[MessageBody] [xml] NULL,
	CONSTRAINT [PK_ErrorLog_ErrorLogID] PRIMARY KEY CLUSTERED 
	(
		[ErrorLogID] ASC
	)
)
