USE DeadLockDB
GO

/* 
+ Use Philips Daily Collection - boiling water
+ Go get Vinacafe pack Golden Original
*/
BEGIN TRANSACTION
	UPDATE p
	SET 
		p.Status = 1
	FROM dbo.Product p WITH (FORCESEEK)
	JOIN dbo.Brand b ON p.BrandId = b.Id
	WHERE b.Name = 'Philips'
	AND p.Name = 'Daily Collection'
	AND p.Status = 0

/*
	UPDATE p
	SET 
		p.Status = 1
	FROM dbo.Product p 
	JOIN dbo.Brand b ON p.BrandId = b.Id
	WHERE b.Name = 'Vinacafe'
	AND p.Name = 'Vinacafe Golden Original Instant Coffee'
	AND p.Status = 0
ROLLBACK
*/