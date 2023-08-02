/*��� �� ��� ������ ������������ �����, �� ���������� ����������� �� 1,
� ��� ���� ������ ������������ � ������� Issued(� ��� ����� ���������� 
������� � ��� ��������/�������, ��� ����� � ���� ������)*/
/*������� ���, ��� �� ������ ���� �������� �����, ������� ��� ��� � ����������(�� ����������)*/
/*������ ������ ����� ����� ��������, ���� � ������� ��� �� ����� ����� ������ 2 �������*/

/*���� �������� ����� ���������, �� �������� ��� ���������� ����� ������ �����(���� ���� ������ ���������)*/

/*��� �� ������ ���� ������ ����� ���� ���� ������ �������� */
/*������� ���, ��� �� ������ ���� �������� �����, ������� ��� ��� � ����������(�� ����������)*/


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

        --  ���� ��� ���������
        DECLARE @StudentName nvarchar(50)
        SELECT @StudentName = s.first_name
        FROM Student s
        WHERE s.id = @StudentID

        IF @StudentName = '���������'
        BEGIN
            -- ���� �� � ������� ���
            IF @Quantity >= 2
            BEGIN
                -- �������� �� ������� �����(����)
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
                           (@Name1_p, @Name2_p, @Name_b, @Date) -- ��������� ��� ������
                UPDATE S_Cards
    SET date_out = @Date
    WHERE id_student = @StudentID AND id_book = (SELECT id_book FROM inserted)

				END
                ELSE
                BEGIN
                    PRINT '������� ����� �����'
					ROLLBACK TRAN
                END
            END
            ELSE
            BEGIN
                PRINT '���� ����'
				ROLLBACK TRAN
            END
        END
        ELSE
        BEGIN
            -- ���� ��� �� ���������, ������ ���� �����
            IF @Quantity >= 1
            BEGIN
                -- ��������� ����� ���� ��������
				
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
				
                    PRINT '����� �����'
					ROLLBACK TRAN
                END
            END
            ELSE
            BEGIN
                PRINT '����������� �����'
				ROLLBACK TRAN
            END
        END
    END
    ELSE
    BEGIN
        PRINT '��������� ������������ ���������� �������� ����'
		ROLLBACK TRAN
    END
	COMMIT TRAN;
END