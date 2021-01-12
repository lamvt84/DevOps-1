CREATE TABLE [dbo].[UsersProfileStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	UserId	int,
	AccountName	varchar(50),
	Mobile	varchar(30),
	FullName	nvarchar(100),
	Email	varchar(30),
	Passport	varchar(30),
	Avatar	varchar(150),
	Attributes	nvarchar(max)
)
