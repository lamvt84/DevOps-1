CREATE PROCEDURE [dbo].[usp_Groups_Get]
	@Id INT
AS
	SELECT g.*
     FROM dbo.Groups g
	 WHERE g.Id = @Id
