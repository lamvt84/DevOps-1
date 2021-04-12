CREATE TABLE [dbo].[WaitStats](
	[pass] [tinyint] NULL,
	[sample_time] [datetimeoffset](7) NULL,
	[server_name] [nvarchar](50) NULL,
	[wait_type] [nvarchar](60) NULL,
	[wait_time_s] [numeric](12, 1) NULL,
	[wait_time_per_core_s] [decimal](18, 1) NULL,
	[signal_wait_time_s] [numeric](12, 1) NULL,
	[signal_wait_percent] [numeric](4, 1) NULL,
	[wait_count] [bigint] NULL
) ON [PRIMARY]
GO