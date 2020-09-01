
CREATE PROCEDURE dbo.usp_Services_Update @Id           INT, 
                                         @GroupId      INT, 
                                         @Name         VARCHAR(100), 
                                         @Description  VARCHAR(500), 
                                         @Url          VARCHAR(500), 
                                         @Params       VARCHAR(500), 
                                         @ResponseCode VARCHAR(100), 
                                         @Enable       TINYINT, 
                                         @Status       TINYINT
AS
    BEGIN
        UPDATE dbo.Services
          SET 
              GroupId = @GroupId, 
              Name = @Name, 
              Description = @Description, 
              Url = @Url, 
              Params = @Params, 
              ResponseCode = @ResponseCode, 
              UpdatedTime = SYSDATETIMEOFFSET(), 
              Enable = @Enable, 
              Status = @Status
        WHERE Id = @Id;
    END;