--’ѕ,котора€ показывающую список книг, отвечающих набору критериев
--критерии:им€ автора,фамили€ авт, тематика, категори€.  роме того , список должен быть отсортирован по номеру пол€
--указанному в 5-м параметре, в направлении, указанном 6-м параметре(sp_executesql)
ALTER PROCEDURE GetSortBook
    @A_name NVARCHAR(50) = '',
    @A_Lastname NVARCHAR(50) = '',
    @Thme NVARCHAR(50) = '',
    @Categ NVARCHAR(50) = '',
    @SortField INT = 1,
    @SortDirection NVARCHAR(4) = 'ASC' 
AS
BEGIN
    IF @SortField < 1 OR @SortField > 5
    BEGIN
        PRINT 'wrong sort number'
        RETURN
    END

    DECLARE @din NVARCHAR(MAX)

    SET @din = '
    SELECT a.first_name AS [Author name], a.last_name AS [Author last name], t.name AS [Theme],
           c.name AS [Category]
    FROM Author a
    JOIN Book b ON a.id = b.id_author
    JOIN Theme t ON b.id_theme = t.id
    JOIN Category c ON b.id_category = c.id
    WHERE a.first_name LIKE ''%'' + @A_name + ''%'' AND
          a.last_name LIKE ''%'' + ''' + @A_Lastname + ''' AND
		  t.name LIKE ''%'' + ''' + @Thme + ''' AND
		  c.name LIKE ''%'' + ''' + @Categ + ''''

    SET @din = @din + '
    ORDER BY ' +
    CASE @SortField
        WHEN 1 THEN 'a.first_name'
        WHEN 2 THEN 'a.last_name'
        WHEN 3 THEN 't.name'
        WHEN 4 THEN 'c.name'
    END +
    ' ' + @SortDirection

    --PRINT @din
    EXEC sp_executesql @din, N'@A_name NVARCHAR(50), @A_Lastname NVARCHAR(50), @Thme NVARCHAR(50), @Categ NVARCHAR(50)',
                       @A_name, @A_Lastname, @Thme, @Categ
END

exec GetSortBook
@A_name = 'јлек',
@SortDirection='DESC'