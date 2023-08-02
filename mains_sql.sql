/*дополнительные таблици для таски*/
CREATE TABLE Issued(
id INT NOT NULL IDENTITY(1,1),
Name_person nvarchar(50) NOT NULL,
Second_name_person nvarchar(50) NOT NULL,
Name_book nvarchar(50) NOT NULL,
Date date NOT NULL
)
CREATE TABLE Returned(
id INT NOT NULL IDENTITY(1,1),
Name_person nvarchar(50) NOT NULL,
Second_name_person nvarchar(50) NOT NULL,
Name_book nvarchar(50) NOT NULL,
Date date NOT NULL
)
CREATE TABLE LibDelete(
id INT NOT NULL IDENTITY(1,1),
Name_book nvarchar(50) NOT NULL,
Pages int NOT NULL,
year_press int NOT NULL,
id_theme int NOT NULL FOREIGN KEY REFERENCES Theme(id),
id_cat int NOT NULL FOREIGN KEY REFERENCES Category(id),
id_author int NOT NULL FOREIGN KEY REFERENCES Author(id),
id_published int NOT NULL FOREIGN KEY REFERENCES Publishment(id)
)


