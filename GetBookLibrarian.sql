--создать хп которая показывает список библиотекарей
--и колво выданных каждым из них книг
CREATE PROCEDURE GetLibGiveBook
AS
BEGIN
    SELECT L.id AS LibrarianID, L.first_name+l.last_name AS LibrarianName, COUNT(T.id) AS BookCount
    FROM Librarian L
    LEFT JOIN T_Cards T ON L.id = T.id_librarian
    GROUP BY L.id, L.first_name+l.last_name
END