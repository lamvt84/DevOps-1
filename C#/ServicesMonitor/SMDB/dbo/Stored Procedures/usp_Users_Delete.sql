CREATE PROCEDURE [dbo].[usp_Users_Delete] @Id INT
AS
    BEGIN
        DELETE FROM dbo.UsersLogin
        WHERE Id = @Id;
        DELETE FROM dbo.Users
        WHERE Id = @Id;
    END;