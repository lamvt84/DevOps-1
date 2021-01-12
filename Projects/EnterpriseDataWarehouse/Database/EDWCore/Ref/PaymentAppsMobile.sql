CREATE TABLE Ref.[PaymentAppsMobile]
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
	AppName nvarchar(70),
	AppOS nvarchar(30),
	Language nvarchar(20),
	Description nvarchar(150),
	PrivateKey varchar(150),
	ChargePackageId int,
	PaymentTypes varchar(100),
	Enable bit,
	CreatedTime datetimeoffset
)
