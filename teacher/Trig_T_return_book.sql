ALTER TRIGGER T_return_book ON T_Cards FOR DELETE AS
BEGIN
    DECLARE @Name1_p nvarchar(50)
    DECLARE @Name2_p nvarchar(50)
    DECLARE @Name_b nvarchar(50)
    DECLARE @Date date

    SELECT @Date = GETDATE()

    SELECT @Name1_p = t.first_name, @Name2_p = t.last_name, @Name_b = b.name
    FROM deleted d
    JOIN Book b ON d.id_book = b.id
    JOIN Teacher t ON d.id_teacher = t.id

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Book
        SET quantity = quantity + 1
        WHERE id = (SELECT id_book FROM deleted);

        INSERT INTO Returned(Name_person, Second_name_person, Name_book, Date)
        VALUES (@Name1_p, @Name2_p, @Name_b, @Date);

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Произошла ошибка. Транзакция отменена.';
    END CATCH;
END
/*сделать так, что бы нельзя было вернуть книг больше, чем их было изначально*/
/*чтобы при возврате  определенной книги, ее количество увеличилось на 1, и это фиксировалось
в таблице Returned*/