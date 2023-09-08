EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;
DECLARE @DateTimeStamp VARCHAR(50)
SET @DateTimeStamp = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(19), GETDATE(), 120), '-', ''), ' ', '_'), ':', '') -- изменение формата
DECLARE @Command VARCHAR(200)
SET @Command = 'echo YourTextHere > C:\1\' + @DateTimeStamp + '.txt'
EXEC xp_cmdshell @Command;