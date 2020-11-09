CREATE TABLE [dbo].[UsersAuthenDevicesStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	UserId	int,
	DeviceId	varchar(100),
	PublicKey	varchar(1000),
	SecureData	varchar(max),
	ActiveTime	Datetimeoffset
)
