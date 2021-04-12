CREATE TABLE [dbo].[DatabaseReportTraceId](
	[report_name] [nvarchar](150) NOT NULL,
	[trace_id] [bigint] NULL,
 CONSTRAINT [PK_DatabaseReportTraceId] PRIMARY KEY CLUSTERED 
(
	[report_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO