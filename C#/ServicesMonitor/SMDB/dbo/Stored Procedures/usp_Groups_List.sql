CREATE PROCEDURE [dbo].[usp_Groups_List]
AS
     SELECT g.*, gt.Name GroupTypeName
     FROM dbo.Groups g
     LEFT JOIN dbo.GroupType gt ON g.GroupTypeId = gt.Id;