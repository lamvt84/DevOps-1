CREATE TABLE [dbo].[PaymentAppsWebsiteStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	PaymentAppId	int,
	UserId	int,
	WebsiteName	nvarchar(50),
	Logo	varchar(100),
	ResponseUrl	varchar(100),
	PrivateKey	varchar(1000),
	NotifyUrl	nvarchar(100),
	Description	nvarchar(250),
	ChargePackageId	int,
	PaymentTypes	varchar(100),
	Enable	bit,
	CreatedTime	datetimeoffset
)
