--взял студент
INSERT INTO S_Cards(id_book,id_librarian,id_student,date_out)
VALUES(7,2,6,GETDATE())
--возврат студентом
DELETE FROM S_Cards WHERE id = 36
--взял препод
INSERT INTO T_Cards(id_book,id_librarian,id_teacher,date_out)
VALUES(5,1,1,GETDATE())
--вернул
DELETE FROM T_Cards WHERE id = 20

--добавляем книгу
INSERT INTO Book(name,pages,year_press,id_theme,id_author,id_category,id_publishment,quantity)
VALUES('LOL',500,2010,1,1,1,1,10)
--убираем книгу
DELETE FROM Book WHERE name = 'LOL'