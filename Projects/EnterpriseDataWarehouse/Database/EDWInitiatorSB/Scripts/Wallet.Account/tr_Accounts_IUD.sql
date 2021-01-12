CREATE OR ALTER TRIGGER [dbo].[tr_Accounts_IUD]
    ON [dbo].[Accounts]
    FOR INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @InitDlgHandle UNIQUEIDENTIFIER;
    DECLARE @ChangeMsg NVARCHAR(MAX);
    DECLARE @ChangeCnt INT;
    DECLARE @Action CHAR(1);
    DECLARE @ServiceName NVARCHAR(512) = N'//WalletAccount/Service/Source';

    BEGIN TRY
        BEGIN

            -- If there are rows in both inserted and deleted, the change is an update
            SELECT @ChangeCnt = COUNT(*)
            FROM [dbo].[Accounts] t
                INNER JOIN deleted d
                    ON t.AccountID = d.AccountID
                INNER JOIN inserted i
                    ON t.AccountID = i.AccountID;
            IF (@ChangeCnt > 0)
                BEGIN;
                    SET @Action = 'U';
                END;
            ELSE
            BEGIN
                -- Since rows aren't in both inserted and deleted, then the change is an insert or a delete
                -- If there are rows in deleted, the change is a delete, and we only need the primary key value
                SELECT @ChangeCnt = COUNT(*)
                FROM deleted
                IF (@ChangeCnt > 0)
                    BEGIN
                        SET @Action = 'D';
                    END;

                -- If there are rows in inserted, the change is an insert and we need all the column values
                SELECT @ChangeCnt = COUNT(*)
                FROM inserted
                IF (@ChangeCnt > 0)
                    BEGIN
                        SET @Action = 'I';
                    END;

            END;

            IF (@Action = 'D')
            BEGIN;
                -- Build the XML message, flagging it as an update
                SET @ChangeMsg =
                (
                    SELECT @Action AS [Action]
                            ,t.[AccountID]
                            ,t.[AccountName]
                            ,t.[Balance]
                            ,t.[BalanceType]
                            ,t.[Currency]
                            ,t.[UserID]
                    FROM [dbo].[Accounts] t
                        INNER JOIN deleted d
                            ON t.[AccountID] = d.[AccountID]
                    FOR XML RAW, ELEMENTS, ROOT('ETL')
                );
            END;
            ELSE
            BEGIN;
                -- Build the XML message, flagging it as an update
                SET @ChangeMsg =
                (
                    SELECT @Action AS [Action]
                            ,t.[AccountID]
                            ,t.[AccountName]
                            ,t.[Balance]
                            ,t.[BalanceType]
                            ,t.[Currency]
                            ,t.[UserID]
                    FROM [dbo].[Accounts] t
                        INNER JOIN inserted i
                            ON t.[AccountID] = i.[AccountID]
                    FOR XML RAW, ELEMENTS, ROOT('ETL')
                );
            END;

            EXEC [EDWInitiatorSB].dbo.sp_SendMessage_Users
                @ServiceName        =   @ServiceName,
                @MessageTypeName    =   N'//WalletAccount/Accounts/Request',
                @MessageBody        =   @ChangeMsg
        END
    END TRY
    BEGIN CATCH
        

    END CATCH
END
GO

EXEC sp_settriggerorder @triggername=N'[dbo].[tr_Accounts_IUD]', @order=N'Last', @stmttype=N'DELETE'
GO

EXEC sp_settriggerorder @triggername=N'[dbo].[tr_Accounts_IUD]', @order=N'Last', @stmttype=N'INSERT'
GO

EXEC sp_settriggerorder @triggername=N'[dbo].[tr_Accounts_IUD]', @order=N'Last', @stmttype=N'UPDATE'
GO


