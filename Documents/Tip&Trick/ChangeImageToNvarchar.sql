DROP TABLE #ChangeColumnType

CREATE TABLE #ChangeColumnType (Id INT, ColumnChange IMAGE)

INSERT #ChangeColumnType SELECT 1, NULL
-- xx
ALTER TABLE #ChangeColumnType ALTER COLUMN ColumnChange VARBINARY
ALTER TABLE #ChangeColumnType ALTER COLUMN ColumnChange VARCHAR(MAX)
