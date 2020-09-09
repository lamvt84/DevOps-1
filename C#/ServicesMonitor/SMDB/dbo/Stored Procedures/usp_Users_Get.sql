CREATE PROCEDURE [dbo].[usp_Users_Get] @Id INT
AS
     SELECT u.Id, 
            u.FirstName, 
            u.LastName, 
            u.Email, 
            ul.UserName, 
            ul.Password, 
            u.[Status], 
            u.CreatedTime, 
            u.UpdatedTime
     FROM dbo.Users u
          LEFT JOIN dbo.UsersLogin ul ON u.Id = ul.Id
     WHERE u.Id = @Id;