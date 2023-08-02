/*что бы при удалении книги, данные о ней копировались в таблицу LibDelete*/
CREATE TRIGGER Del_Book ON Book FOR DELETE AS
BEGIN
    DECLARE @Name_b nvarchar(50)
    DECLARE @Pages INT
    DECLARE @YearPress INT
    DECLARE @IdTheme INT
    DECLARE @IdCategory INT
    DECLARE @IdAuthor INT
    DECLARE @IdPublishment INT

    SELECT @Name_b = d.name, @Pages = d.pages, @YearPress = d.year_press,
           @IdTheme = id_theme, @IdCategory = id_category,
           @IdAuthor = id_author, @IdPublishment = id_publishment
    FROM deleted d

    IF @Name_b IS NULL OR @Pages IS NULL OR @YearPress IS NULL
        OR @IdTheme IS NULL OR @IdCategory IS NULL
        OR @IdAuthor IS NULL OR @IdPublishment IS NULL
    BEGIN
        PRINT 'Некорректные данные. Откат транзакции.'
        ROLLBACK TRANSACTION
        RETURN
    END

    INSERT INTO LibDelete (Name_book, Pages, year_press,
                           id_theme, id_cat, id_author, id_published)
    VALUES (@Name_b, @Pages, @YearPress,
            @IdTheme, @IdCategory, @IdAuthor, @IdPublishment)
END