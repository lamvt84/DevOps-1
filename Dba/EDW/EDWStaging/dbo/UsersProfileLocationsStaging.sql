CREATE TABLE [dbo].[UsersProfileLocationsStaging]
(
	Source_Name	Varchar(20),
	Batch_Id	int,
	Action_Flag	varchar(1),
	LocationId	int,
	LocationCode	varchar(30),
	LocationName	nvarchar(100),
	LocationLevel	tinyint,
	ParentId	int
)
