CREATE TABLE [dbo].[UsersProfileVerificationStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	UserId	int,
	AccountName	varchar(50),
	ImageUrl	varchar(1000),
	VerifyStatus	tinyint,
	Description	nvarchar(200),
	UserConfirm	varchar(50),
	ConfirmTime	Datetimeoffset,
	CreatedTime	Datetimeoffset
)
