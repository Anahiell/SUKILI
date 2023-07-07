
--хп которая показывает кол-во взятых книг по каждой группе, и по каждой кафедре
ALTER PROCEDURE TakenBook AS
BEGIN
    DECLARE @T TABLE (
        GroupName VARCHAR(100),
        DepartmentName VARCHAR(100),
        TakenB INT
    )

    INSERT INTO @T (GroupName, DepartmentName, TakenB)
    SELECT G.name, D.name, COUNT(*) AS Taken_Books_Count
    FROM T_Cards TC
    INNER JOIN [Group] G ON TC.id_teacher = G.ID
    INNER JOIN Department D ON G.id_department = D.ID
    GROUP BY G.name, D.name

    INSERT INTO @T (GroupName, DepartmentName, TakenB)
    SELECT G.name, D.name, COUNT(*) AS Taken_Books_Count
    FROM S_Cards SC
    INNER JOIN [Group] G ON SC.id_student = G.ID
    INNER JOIN Department D ON G.id_department = D.ID
    GROUP BY G.name, D.name

    -- Вывод результатов
    SELECT GroupName, DepartmentName, SUM(TakenB) AS TotalTakenBooksCount
    FROM @T
    GROUP BY GroupName, DepartmentName
END
