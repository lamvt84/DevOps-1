CREATE TABLE [dbo].[PaymentAppsButtonStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	PaymentAppId	int,
	UserId	int,
	ButtonStyle	varchar(25),
	ButtonProduct	nvarchar(100),
	ButtonCode	varchar(50),
	ButtonType	tinyint,
	Price	numeric(28,12),
	PaymentCode	varchar(50),
	PaymentLogo	varchar(500),
	PaymentLanguage	tinyint,
	SuccessUrl	varchar(500),
	CancelUrl	varchar(500),
	Description	nvarchar(250),
	Enable	bit,
	ChargePackageId	tinyint,
	PaymentTypes	varchar(100),
	CreatedTime	datetimeoffset
)
