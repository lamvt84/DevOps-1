CREATE TABLE [dbo].[UsersProfileAttributesDictStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	KeyId	int,
	KeyName	varchar(50),
	Description	nvarchar(200),
	ValueType	tinyint,
	SortIndex	int
)
