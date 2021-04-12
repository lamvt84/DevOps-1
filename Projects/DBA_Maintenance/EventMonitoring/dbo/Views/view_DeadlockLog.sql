
CREATE VIEW [dbo].[View_DeadlockLog]
AS
SELECT [DatabaseName],
       [Time],
       LockMode
FROM DeadlockLog
