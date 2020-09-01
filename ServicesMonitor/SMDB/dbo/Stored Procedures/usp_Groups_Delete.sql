CREATE PROCEDURE [dbo].[usp_Groups_Delete] @Id INT
AS
    BEGIN
        UPDATE dbo.[Services]
          SET 
              GroupId = 0
        WHERE GroupId = @Id;
        DELETE FROM dbo.Groups
        WHERE Id = @Id;
    END;