CREATE TABLE [dbo].[IndexFragmentation](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [varchar](128) NULL,
	[DBName] [varchar](128) NULL,
	[TableName] [varchar](100) NULL,
	[IndexName] [varchar](100) NULL,
	[FragPercent] [float] NULL,
	[page_count] [bigint] NULL,
	[IndexType] [tinyint] NULL,
	[IsPrimaryKey] [bit] NULL,
	[type] [varchar](2) NULL,
	[command] [varchar](200) NULL,
	[createDate] [date] NULL,
	CONSTRAINT PK_IndexFragmentation PRIMARY KEY ( id )
) ON [PRIMARY]
GO