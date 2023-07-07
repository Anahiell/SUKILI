--�� ������� ������ ����� ����� ������ ��
--���������� ���� � ��������� � ����������
ALTER PROCEDURE GetTotalBtak
    @TotalBooksTaken INT OUTPUT
AS
BEGIN
    DECLARE @SBT INT, @TBT INT

    SELECT @SBT = COUNT(*) 
    FROM S_Cards
    WHERE date_in IS NOT NULL

    SELECT @TBT = COUNT(*) 
    FROM T_Cards
    WHERE date_in IS NOT NULL

    SET @TotalBooksTaken = @SBT + @TBT
END