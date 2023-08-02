/*что бы при взятии определенной книги, ее количество уменьшилось на 1,
а сам факт выдачи фиксировался в таблице Issued(в нее нужно записывать 
фимилию и имя студента/учителя, имя книги и дату выдачи)*/
/*сделать так, что бы нельзя было выдавать книгу, которой уже нет в БИБлиотеке(по количеству)*/
/*нельзя выдать новую книгу студенту, если в прошлый раз он читал книгу дольше 2 месяцев*/

/*если студента зовут Александр, он получает две одинаковые книги вместо одной(если есть второй екземпляр)*/

/*что бы нельзя было выдать более трех книг одному студенту */
/*сделать так, что бы нельзя было выдавать книгу, которой уже нет в БИБлиотеке(по количеству)*/


ALTER TRIGGER St_Take_B ON S_Cards FOR INSERT AS
BEGIN
	BEGIN TRAN;
    DECLARE @Name1_p nvarchar(50)
    DECLARE @Name2_p nvarchar(50)
    DECLARE @Name_b nvarchar(50)
    DECLARE @Date date

    SELECT @Date = GETDATE()

    SELECT @Name1_p = s.first_name, @Name2_p = s.last_name, @Name_b = b.name
    FROM inserted i
        JOIN Book b ON i.id_book = b.id
        JOIN Student s ON i.id_student = s.id

    DECLARE @StudentID INT
    SELECT @StudentID = id_student FROM inserted

    DECLARE @IssuedBooksCount INT
    SELECT @IssuedBooksCount = COUNT(*) 
    FROM S_Cards 
    WHERE id_student = @StudentID 

    IF @IssuedBooksCount < 3
    BEGIN
        DECLARE @Quantity INT
        SELECT @Quantity = b.quantity
        FROM Book b
        WHERE b.id = (SELECT id_book FROM inserted)

        --  если это Александр
        DECLARE @StudentName nvarchar(50)
        SELECT @StudentName = s.first_name
        FROM Student s
        WHERE s.id = @StudentID

        IF @StudentName = 'Александр'
        BEGIN
            -- есть ли в наличии еще
            IF @Quantity >= 2
            BEGIN
                -- проверка на возврат книги(дата)
                DECLARE @LastBookReturnDate date
                SELECT TOP 1 @LastBookReturnDate = date_in
                FROM S_Cards 
                WHERE id_student = @StudentID 
                ORDER BY date_in DESC

                IF @LastBookReturnDate IS NULL OR DATEDIFF(MONTH, @LastBookReturnDate, GETDATE()) <= 2
                BEGIN
                    UPDATE Book
                    SET quantity = quantity - 2
                    WHERE id = (SELECT id_book FROM inserted)

                    INSERT INTO Issued(Name_person, Second_name_person, Name_book, Date)
                    VALUES (@Name1_p, @Name2_p, @Name_b, @Date),
                           (@Name1_p, @Name2_p, @Name_b, @Date) -- Добавляем две записи
                UPDATE S_Cards
    SET date_out = @Date
    WHERE id_student = @StudentID AND id_book = (SELECT id_book FROM inserted)

				END
                ELSE
                BEGIN
                    PRINT 'Студент долго читал'
					ROLLBACK TRAN
                END
            END
            ELSE
            BEGIN
                PRINT 'Мало книг'
				ROLLBACK TRAN
            END
        END
        ELSE
        BEGIN
            -- если имя не Александр, выдаем одну книгу
            IF @Quantity >= 1
            BEGIN
                -- Проверяем опять дату возврата
				
                SELECT TOP 1 @LastBookReturnDate = date_in
                FROM S_Cards 
                WHERE id_student = @StudentID 
                ORDER BY date_in DESC

                IF @LastBookReturnDate IS NULL OR DATEDIFF(MONTH, @LastBookReturnDate, GETDATE()) <= 2
                BEGIN
                    UPDATE Book
                    SET quantity = quantity - 1
                    WHERE id = (SELECT id_book FROM inserted)

                    INSERT INTO Issued(Name_person, Second_name_person, Name_book, Date)
                    VALUES (@Name1_p, @Name2_p, @Name_b, @Date)
					UPDATE S_Cards
					SET date_out = @Date
					WHERE id_student = @StudentID AND id_book = (SELECT id_book FROM inserted)

                END
                ELSE
                BEGIN
				
                    PRINT 'Долго читал'
					ROLLBACK TRAN
                END
            END
            ELSE
            BEGIN
                PRINT 'Отсутствует книга'
				ROLLBACK TRAN
            END
        END
    END
    ELSE
    BEGIN
        PRINT 'Превышено максимальное количество выданных книг'
		ROLLBACK TRAN
    END
	COMMIT TRAN;
END