CREATE TABLE Ref.[PaymentAppsWebsite]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	Source_Name Varchar(20),
	Batch_Id int,
	Created_Time datetimeoffset,
	Updated_Time datetimeoffset,
	Current_Flag varchar(1),
	Delete_Flag varchar(1),
	PaymentAppId int,
	UserId int,
	WebsiteName nvarchar(50),
	Logo varchar(100),
	ResponseUrl varchar(100),
	PrivateKey varchar(1000),
	NotifyUrl nvarchar(100),
	Description nvarchar(250),
	ChargePackageId int,
	PaymentTypes varchar(100),
	Enable bit,
	CreatedTime datetimeoffset
)
