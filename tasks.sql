--1taska
EXEC TakenBook
--2taska
EXEC GetSortBook @SortField = 'AuthorLastName', @SortDirection = 1
--task3
EXEC GetLibGiveBook
--task4
EXEC GetStBooks
--5taska
DECLARE @TotalBooks INT

EXEC GetTotalBtak @TotalBooksTaken = @TotalBooks OUTPUT

SELECT @TotalBooks AS TotalBooksTaken