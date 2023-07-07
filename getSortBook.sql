--ХП,которая показывающую список книг, отвечающих набору критериев
--критерии:имя автора,фамилия авт, тематика, категория. Кроме того , список должен быть отсортирован по номеру поля
--указанному в 5-м параметре, в направлении, указанном 6-м параметре(sp_executesql)
ALTER PROCEDURE GetSortBook
    @SortField VARCHAR(100),
    @SortDirection INT
AS
BEGIN
    DECLARE @OrderBy NVARCHAR(4)

    IF @SortDirection = 1
        SET @OrderBy = 'ASC'
    ELSE
        SET @OrderBy = 'DESC'

    SELECT A.first_name AS AuthorFirstName, A.last_name AS AuthorLastName, T.name AS Theme, C.name AS Category
    FROM Book B
    LEFT JOIN Author A ON B.id_author = A.id
    LEFT JOIN Theme T ON B.id_theme = T.id
    LEFT JOIN Category C ON B.id_category = C.id
    ORDER BY
        CASE
            WHEN @SortField = 'AuthorFirstName' THEN A.first_name
            WHEN @SortField = 'AuthorLastName' THEN A.last_name
            WHEN @SortField = 'Theme' THEN T.name
            WHEN @SortField = 'Category' THEN C.name
        END
        COLLATE SQL_Latin1_General_CP1_CI_AS,--stackower
        CASE
            WHEN @SortDirection = 1 THEN B.id
        END ASC,
        CASE
            WHEN @SortDirection = 2 THEN B.id
        END DESC
END