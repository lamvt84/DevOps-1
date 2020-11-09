CREATE TABLE Ref.[UsersProfileAttributesDict]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	Source_Name Varchar(20),
	Batch_Id int,
	Created_Time datetimeoffset,
	Updated_Time datetimeoffset,
	Current_Flag varchar(1),
	Delete_Flag varchar(1),
	KeyId int,
	KeyName varchar(50),
	Description nvarchar(200),
	ValueType tinyint,
	SortIndex int
)
