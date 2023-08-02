/*если новая книга добавляется в базу, она должна быть удалена из таблицы LibDelete(если она в ней есть)*/
CREATE TRIGGER ADD_Book ON Book FOR INSERT AS
BEGIN
    DECLARE @Name_b nvarchar(50)

    SELECT @Name_b = name FROM inserted

    IF @Name_b IS NULL
    BEGIN
        PRINT 'Некорректные данные. Откат транзакции.'
        ROLLBACK TRANSACTION
        RETURN
    END

    IF EXISTS (SELECT 1 FROM LibDelete WHERE Name_book = @Name_b)
    BEGIN
        BEGIN TRANSACTION
        DELETE FROM LibDelete WHERE Name_book = @Name_b
        COMMIT TRANSACTION
    END
END