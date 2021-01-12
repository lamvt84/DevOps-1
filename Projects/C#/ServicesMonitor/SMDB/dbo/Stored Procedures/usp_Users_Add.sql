CREATE PROCEDURE [dbo].[usp_Users_Add] @FirstName    VARCHAR(50), 
                                       @LastName     VARCHAR(50), 
                                       @Email        VARCHAR(100), 
                                       @UserName     VARCHAR(50), 
                                       @Password     VARCHAR(100), 
                                       @ResponseCode INT OUTPUT
AS
    BEGIN
        SET @ResponseCode = 1;
        IF EXISTS
        (
            SELECT 1
            FROM dbo.Users
            WHERE Email = @Email
        )
            BEGIN
                SET @ResponseCode = -1; -- email existed
                RETURN;
            END;
        IF EXISTS
        (
            SELECT 1
            FROM dbo.UsersLogin
            WHERE UserName = @UserName
        )
            BEGIN
                SET @ResponseCode = -2; -- username existed
                RETURN;
            END;
        INSERT INTO dbo.Users
        (FirstName, 
         LastName, 
         Email
        )
        VALUES
        (@FirstName, 
         @LastName, 
         @Email
        );
        SET @ResponseCode = SCOPE_IDENTITY();
        INSERT INTO dbo.UsersLogin
        (Id, 
         UserName, 
         Password
        )
        VALUES
        (@ResponseCode, 
         @UserName, 
         @Password
        );
    END;