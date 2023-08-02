/*сделать так, что бы нельзя было выдавать книгу, которой уже нет в БИБлиотеке(по количеству)*/
ALTER TRIGGER T_Take_B ON T_Cards FOR INSERT AS
BEGIN
    DECLARE @Name1_p nvarchar(50)
    DECLARE @Name2_p nvarchar(50)
    DECLARE @Name_b nvarchar(50)
    DECLARE @Date date
    SELECT @Date = GETDATE()

    SELECT @Name1_p = t.first_name , @Name2_p = t.last_name, @Name_b = b.name
    FROM inserted i
        JOIN Book b ON i.id_book = b.id
        JOIN Teacher t ON i.id_teacher = t.id

    DECLARE @Quantity INT
    SELECT @Quantity = b.quantity
    FROM Book b
    WHERE b.id = (SELECT id_book FROM inserted)

    IF @Quantity >= 1
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            UPDATE Book
            SET quantity = quantity - 1
            WHERE id = (SELECT id_book FROM inserted);

            INSERT INTO Issued(Name_person, Second_name_person, Name_book, Date)
            VALUES (@Name1_p, @Name2_p, @Name_b, @Date);

            COMMIT;
        END TRY
        BEGIN CATCH
            ROLLBACK;
            PRINT 'Произошла ошибка. Транзакция отменена.';
        END CATCH;
    END
    ELSE
    BEGIN
        DECLARE @RandomBookID INT
        SELECT TOP 1 @RandomBookID = id
        FROM Book
        WHERE quantity > 0
        ORDER BY NEWID()

        IF @RandomBookID IS NOT NULL
        BEGIN
            -- Сохраняем случайный ID книги
            UPDATE T_Cards
            SET id_book = @RandomBookID
            WHERE id = (SELECT id FROM inserted);

            PRINT 'Преподавателю выдана случайная книга.';
        END
        ELSE
        BEGIN
            PRINT 'Книги в библиотеке закончились.';
        END
    END
END
/*если нет книги, которую хочет взять препод.,выдать ему одну случайную книгу. в случае,
если книги в библиотеке совсем закончились - выдать сообщение об этом*/