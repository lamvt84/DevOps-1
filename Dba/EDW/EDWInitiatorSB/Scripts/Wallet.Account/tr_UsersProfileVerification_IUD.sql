CREATE OR ALTER TRIGGER dbo.tr_UsersProfileVerification_IUD
    ON [dbo].[Users_ProfileVerification]
    FOR INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @InitDlgHandle UNIQUEIDENTIFIER;
    DECLARE @ChangeMsg XML;
    DECLARE @ChangeCnt INT;
    DECLARE @Action CHAR(1);
    DECLARE @ServiceName NVARCHAR(512) = N'//WalletAccount/Service/Source';

    BEGIN TRY
        BEGIN

            -- If there are rows in both inserted and deleted, the change is an update
            SELECT @ChangeCnt = COUNT(*)
            FROM [dbo].[Users_ProfileVerification] t
                INNER JOIN deleted d
                    ON t.UserID = d.UserID
                INNER JOIN inserted i
                    ON t.UserID = i.UserID;
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
                        ,t.[UserID]
                        ,t.[AccountName]
                        ,t.[ImageUrl]
                        ,t.[VerifyStatus]
                        ,t.[Description]
                        ,t.[UserConfirm]
                        ,t.[ConfirmTime]
                        ,t.[CreatedTime]
                        ,t.[CreatedUnixTime]
                    FROM [dbo].[Users_ProfileVerification] t
                        INNER JOIN deleted d
                            ON t.[UserID] = d.[UserID]
                    FOR XML RAW, ELEMENTS, ROOT('ETL')
                );
            END;
            ELSE
            BEGIN;
                -- Build the XML message, flagging it as an update
                SET @ChangeMsg =
                (
                    SELECT @Action AS [Action]
                        ,t.[UserID]
                        ,t.[AccountName]
                        ,t.[ImageUrl]
                        ,t.[VerifyStatus]
                        ,t.[Description]
                        ,t.[UserConfirm]
                        ,t.[ConfirmTime]
                        ,t.[CreatedTime]
                        ,t.[CreatedUnixTime]
                    FROM [dbo].[Users_ProfileVerification] t
                        INNER JOIN inserted i
                            ON t.[UserID] = i.[UserID]
                    FOR XML RAW, ELEMENTS, ROOT('ETL')
                );
            END;

            EXEC [EDWInitiatorSB].dbo.sp_SendMessage_Users
                @ServiceName        =   @ServiceName,
                @MessageTypeName    =   N'//WalletAccount/UsersProfileVerification/Request',
                @MessageBody        =   @ChangeMsg
        END
    END TRY
    BEGIN CATCH
        

    END CATCH
END
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_UsersProfileVerification_IUD]',
                        @order = N'Last',
                        @stmttype = N'DELETE'
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_UsersProfileVerification_IUD]',
                        @order = N'Last',
                        @stmttype = N'INSERT'
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_UsersProfileVerification_IUD]',
                        @order = N'Last',
                        @stmttype = N'UPDATE'
GO