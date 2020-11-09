CREATE TABLE Ref.[BanksPartnerChannels]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	Source_Name	Varchar(20),
	Batch_Id	int,
	Created_Time	datetimeoffset,
	Updated_Time	datetimeoffset,
	Current_Flag	varchar(1),
	Delete_Flag	varchar(1),
	PartnerCode	varchar(50),
	PartnerName	nvarchar(250),
	BankLinkType	tinyint,
	PaymentLinkType	tinyint,
	PaymentUnlinkType	tinyint,
	InternalGateUrl	varchar(250),
	UpdateTime	datetimeoffset
)
