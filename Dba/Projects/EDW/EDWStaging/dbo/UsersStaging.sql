CREATE TABLE [dbo].[UsersStaging]
(	
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	UserId	int,
	Username	varchar(50),
	Password	varchar(500),
	VerifyType	tinyint,
	UserType	tinyint,
	UserStatus	int,
	CreatedTime	Datetimeoffset
)
