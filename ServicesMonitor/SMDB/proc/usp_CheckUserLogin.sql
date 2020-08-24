CREATE PROCEDURE [dbo].[usp_CheckUserLogin]
	@UserName VARCHAR(50),
	@Password VARCHAR(100),
	@ResponseCode INT OUTPUT
AS
	SET @ResponseCode = 0
	SELECT @ResponseCode = Id
	FROM dbo.UsersLogin
	WHERE UserName = @UserName
		AND Password = @Password
