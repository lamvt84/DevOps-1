CREATE PROCEDURE [dbo].[usp_Services_UpdateStatus]
	@Id int,
	@Status tinyint
AS
	UPDATE dbo.Services
	SET 
		Status = @Status,
		UpdatedTime = SYSDATETIMEOFFSET()
	WHERE Id = @Id
