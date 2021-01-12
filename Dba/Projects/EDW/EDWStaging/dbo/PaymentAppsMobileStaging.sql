CREATE TABLE [dbo].[PaymentAppsMobileStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	PaymentAppId	int,
	UserId	int,
	AppName	nvarchar(70),
	AppOS	nvarchar(30),
	Language	nvarchar(20),
	Description	nvarchar(150),
	PrivateKey	varchar(150),
	ChargePackageId	int,
	PaymentTypes	varchar(100),
	Enable	bit,
	CreatedTime	datetimeoffset
)
