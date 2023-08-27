/*написать функцию, котора€ покажет список всех таблиц базы данных, 
название которой передано как параметр, 
количество записей в каждой из ее таблиц, и общий размер каждой таблицы в байтах*/
CREATE FUNCTION dbo.GetT_RSizes(@dbName NVARCHAR(max))
RETURNS @TableInfo TABLE (
    TableName NVARCHAR(max),
    RecordCount INT,
    TotalSizeBytes BIGINT
)
AS
BEGIN
    INSERT INTO @TableInfo (TableName, RecordCount, TotalSizeBytes)
    SELECT
        t.name AS TableName,
        SUM(p.rows) AS RecordCount,
        SUM(a.total_pages) * 8192 AS TotalSizeBytes
    FROM
        sys.tables t --инфа о таблицах в базе 
        JOIN sys.indexes i ON t.object_id = i.object_id AND i.index_id <= 1-- соедин€ем с индексами и учитываем только основные
        JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id--тут получаем инфу про каждый раздел св€заный с индексом
        JOIN sys.allocation_units a ON p.partition_id = a.container_id--эта таблица о выделено пам€ти, св€зь с ней дает инфу по каждому разделу
    WHERE
        OBJECT_SCHEMA_NAME(t.object_id) = 'dbo' AND  --тут провер€ем принадлежит ли и ессть ли эта база данных
        EXISTS (
            SELECT 1
            FROM sys.databases d
            WHERE d.name = @dbName
        )
    GROUP BY
        t.name;

    RETURN;
END;
