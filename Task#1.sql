/*написать функцию, которая покажет список всех пользовательских
баз данных sql server, и их общие размеры в байтах*/

USE master;

ALTER FUNCTION dbo.GetDBSizes()
RETURNS @DatabaseSizes TABLE (
    DatabaseName NVARCHAR(max),
    TotalSizeBytes BIGINT
)
AS
BEGIN
    INSERT INTO @DatabaseSizes (DatabaseName, TotalSizeBytes)
    SELECT
        name AS DatabaseName,
        SUM(size * 8192) AS TotalSizeBytes--умножание на 8КБ(8192)-это стандартный размер
    FROM
        sys.master_files
    WHERE
        type_desc = 'ROWS' AND state_desc = 'ONLINE' --онлайн потому что это данные доступные для чтения и записи
    GROUP BY
        name

    RETURN
END;
/*Тип 'ROWS' обозначает файлы данных, 
которые хранят фактические данные таблиц.
В данной задаче мы хотим узнать размеры именно данных, 
поэтому мы выбираем файлы с типом 'ROWS'.*/

