CREATE TABLE [dbo].[WaitCategories](
	[wait_type] [nvarchar](60) NOT NULL,
	[wait_category] [nvarchar](128) NOT NULL,
	[ignorable] [bit] NULL,
CONSTRAINT PK_WaitCategories PRIMARY KEY CLUSTERED 
(
	[wait_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO