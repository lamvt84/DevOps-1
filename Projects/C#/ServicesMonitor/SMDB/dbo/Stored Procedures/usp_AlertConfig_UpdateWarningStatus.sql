
CREATE PROCEDURE dbo.usp_AlertConfig_UpdateWarningStatus @Id          INT, 
                                                  @PauseStatus TINYINT, 
                                                  @PausePeriod INT
AS
    BEGIN
        UPDATE dbo.AlertConfig
          SET 
              PauseStatus = @PauseStatus, 
              PausePeriod = @PausePeriod,
              UpdatedTime = SYSDATETIMEOFFSET()
        WHERE Id = @Id;
    END;