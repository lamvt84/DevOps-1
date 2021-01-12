CREATE TABLE [dbo].[BanksPartnerChannelsStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	PartnerCode	varchar(50),
	PartnerName	nvarchar(250),
	BankLinkType	tinyint,
	PaymentLinkType	tinyint,
	PaymentUnlinkType	tinyint,
	InternalGateUrl	varchar(250),
	UpdateTime	datetimeoffset
)
