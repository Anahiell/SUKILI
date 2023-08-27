/*�������� �������, ������� ������� ������ ���� ������ ���� ������, 
�������� ������� �������� ��� ��������, 
���������� ������� � ������ �� �� ������, � ����� ������ ������ ������� � ������*/
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
        sys.tables t --���� � �������� � ���� 
        JOIN sys.indexes i ON t.object_id = i.object_id AND i.index_id <= 1-- ��������� � ��������� � ��������� ������ ��������
        JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id--��� �������� ���� ��� ������ ������ �������� � ��������
        JOIN sys.allocation_units a ON p.partition_id = a.container_id--��� ������� � �������� ������, ����� � ��� ���� ���� �� ������� �������
    WHERE
        OBJECT_SCHEMA_NAME(t.object_id) = 'dbo' AND  --��� ��������� ����������� �� � ����� �� ��� ���� ������
        EXISTS (
            SELECT 1
            FROM sys.databases d
            WHERE d.name = @dbName
        )
    GROUP BY
        t.name;

    RETURN;
END;
