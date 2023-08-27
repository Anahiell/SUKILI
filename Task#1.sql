/*�������� �������, ������� ������� ������ ���� ����������������
��� ������ sql server, � �� ����� ������� � ������*/

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
        SUM(size * 8192) AS TotalSizeBytes--��������� �� 8��(8192)-��� ����������� ������
    FROM
        sys.master_files
    WHERE
        type_desc = 'ROWS' AND state_desc = 'ONLINE' --������ ������ ��� ��� ������ ��������� ��� ������ � ������
    GROUP BY
        name

    RETURN
END;
/*��� 'ROWS' ���������� ����� ������, 
������� ������ ����������� ������ ������.
� ������ ������ �� ����� ������ ������� ������ ������, 
������� �� �������� ����� � ����� 'ROWS'.*/

