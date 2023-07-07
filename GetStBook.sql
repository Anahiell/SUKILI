--хп, которая покажет имя фамили. студента, набравшего
--наибольшее кол-во книг
CREATE PROCEDURE GetStBooks
AS
BEGIN
    SELECT TOP 1 S.first_name + S.last_name AS FullName
    FROM Student S
    INNER JOIN S_Cards SC ON S.id = SC.id_student
    GROUP BY S.id, S.first_name + S.last_name 
    ORDER BY COUNT(SC.id) DESC
END