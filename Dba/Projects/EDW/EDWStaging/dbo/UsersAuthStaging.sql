CREATE TABLE [dbo].[UsersAuthStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	UserId	int,
	UserName	varchar(50),
	IsVerify	bit,
	CreatedTime	Datetimeoffset
)
