-- Identify repl errors
USE [distribution]
SELECT *
FROM MSrepl_errors
ORDER BY TIME DESC

-- Identify the publisher database id
SELECT *
FROM MSpublisher_databases

-- Identify the ID number and command id of the command causing the problem. 
-- This will typically show up in the Replication Monitor.

-- To locate articles that not in sync.
SELECT *
FROM dbo.MSarticles
WHERE article_id IN
      (
          SELECT article_id
          FROM MSrepl_commands
          WHERE xact_seqno = 0x00032F6B00000845000500000000
      )

-- To identify the command with the problem.
-- Can remove @command_id for whole command in 1 transaction
EXEC sp_browsereplcmds @xact_seqno_start = '0x00032F6B0000084B000300000000',
                       @xact_seqno_end = '0x00032F6B0000084B000300000000',
                       @publisher_database_id = 18,
                       @command_id = 1

-- Delete the command from MSRepl_commands using the xact_seqno and command_id
SELECT *
FROM MSrepl_commands
WHERE xact_seqno = 0x00032F6B0000084B0003

DELETE FROM MSrepl_commands
WHERE xact_seqno = 0x00032F6B0000084B0003
      AND command_id = 1
      AND publisher_database_id = 18