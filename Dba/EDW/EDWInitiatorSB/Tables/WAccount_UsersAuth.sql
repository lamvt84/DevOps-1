CREATE TABLE [dbo].[WAccount_UsersAuth]
(
	[Action] [varchar](1),
	[Username] [varchar](50)NULL,
	[UserID] [int] NOT NULL,
	[IsVerify] [bit] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
)
