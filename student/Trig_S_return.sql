ALTER TRIGGER S_return_book ON S_Cards FOR DELETE AS
BEGIN
    DECLARE @Name1_p nvarchar(50)
    DECLARE @Name2_p nvarchar(50)
    DECLARE @Name_b nvarchar(50)
    DECLARE @Date date

    SELECT @Date = GETDATE()

    SELECT @Name1_p = s.first_name, @Name2_p = s.last_name, @Name_b = b.name
    FROM deleted d
    JOIN Book b ON d.id_book = b.id
    JOIN Student s ON d.id_student = s.id

    BEGIN TRY
        UPDATE Book
        SET quantity = quantity + 1
        WHERE id = (SELECT id_book FROM deleted);

        INSERT INTO Returned(Name_person, Second_name_person, Name_book, Date)
        VALUES (@Name1_p, @Name2_p, @Name_b, @Date);
    END TRY
    BEGIN CATCH
        PRINT 'Ошибка при возврате книги';
        ROLLBACK TRAN; 
    END CATCH;
END
/*сделать так, что бы нельзя было вернуть книг больше, чем их было изначально*/
/*чтобы при возврате  определенной книги, ее количество увеличилось на 1, и это фиксировалось
в таблице Returned*/