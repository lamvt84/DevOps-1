CREATE TABLE Ref.[TransactionsService]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	Source_Name Varchar(20),
	Batch_Id int,
	Created_Time datetimeoffset,
	Updated_Time datetimeoffset,
	Current_Flag varchar(1),
	Delete_Flag varchar(1),
	ServiceId int,
	GroupServiceId int,
	GroupServiceName nvarchar(150),
	ServiceKey nvarchar(50),
	ServiceName nvarchar(100),
	Description nvarchar(250),
	AffectToBalance tinyint,
	Enable bit,
	ParentId int
)
