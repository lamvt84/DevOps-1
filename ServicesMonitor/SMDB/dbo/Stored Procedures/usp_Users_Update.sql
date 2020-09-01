CREATE PROCEDURE [dbo].[usp_Users_Update] @Id           INT, 
                                          @FirstName    VARCHAR(50), 
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
                  AND Id <> @Id
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
                  AND Id <> @Id
        )
            BEGIN
                SET @ResponseCode = -2; -- username existed
                RETURN;
            END;
        UPDATE dbo.Users
          SET 
              FirstName = @FirstName, 
              LastName = @LastName, 
              Email = @Email, 
              UpdatedTime = SYSDATETIMEOFFSET()
        WHERE Id = @Id;
        UPDATE dbo.UsersLogin
          SET 
              UserName = @UserName, 
              Password = (CASE
                              WHEN LEN(@Password) > 0
                              THEN @Password
                              ELSE Password
                          END), 
              UpdatedTime = SYSDATETIMEOFFSET()
        WHERE Id = @Id;
    END;