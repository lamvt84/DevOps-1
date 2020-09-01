CREATE PROCEDURE [dbo].[usp_Groups_Get]
	@Id INT
AS
	SELECT * FROM dbo.Groups WHERE Id = @Id
