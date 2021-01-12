CREATE TABLE [dbo].[PostHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PostHistoryTypeId] [int] NOT NULL,
	[PostId] [int] NOT NULL,
	[RevisionGUID] [uniqueidentifier] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[UserId] [int] NULL,
	[UserDisplayName] [nvarchar](50) NULL,
	[Comment] [nvarchar](max) NULL,
	[Text] [nvarchar](max) NULL,
 CONSTRAINT [PK_PostHistory__Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO