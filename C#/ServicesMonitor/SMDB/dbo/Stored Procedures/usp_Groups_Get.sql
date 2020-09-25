CREATE PROCEDURE [dbo].[usp_Groups_Get]
	@Id INT
AS
	SELECT g.*, gt.Name GroupTypeName
     FROM dbo.Groups g
     LEFT JOIN dbo.GroupType gt ON g.GroupTypeId = gt.Id
	 WHERE g.Id = @Id
