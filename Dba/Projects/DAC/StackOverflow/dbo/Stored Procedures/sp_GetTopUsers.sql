CREATE PROCEDURE [dbo].[sp_GetTopUsers]
	
AS
	SELECT TOP 10 * FROM dbo.Users;

