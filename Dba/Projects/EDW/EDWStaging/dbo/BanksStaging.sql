CREATE TABLE [dbo].[BanksStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	BankId	int,
	BankCode	varchar(30),
	BankName	nvarchar(250),
	BankType	tinyint,
	BankServiceType	tinyint,
	BankStatus	tinyint,
	WebSite	nvarchar(150),
	Logo	varchar(250),
	Address	nvarchar(250),
	Description	nvarchar(250),
	LogoMobileGrid	varchar(250),
	LogoMobileIcon	varchar(250),
	CardColor	varchar(20),
	CreatedTime	datetimeoffset,
	UpdatedUser	varchar(30),
	Linkable	bit,
	PartnerCode	varchar(50),
	BinCode	varchar(50)
)
