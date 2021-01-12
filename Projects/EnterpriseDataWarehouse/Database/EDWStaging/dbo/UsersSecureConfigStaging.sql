CREATE TABLE [dbo].[UsersSecureConfigStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	UserId	int,
	SecureType	int,
	AccountName	varchar(50),
	MinAmount	numeric(28,12),
	SecureStatus	tinyint,
	NotifyType	varchar(20),
	ModifiedTime	datetimeoffset
)
