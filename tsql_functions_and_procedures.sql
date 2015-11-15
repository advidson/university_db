/*без параметров*/
--1.Создать хранимую процедуру, выводящую читателей, у которых наибольшее количество книг на руках.
CREATE PROC max_books_in_the_hands
AS
	DECLARE @max_books INT
	SELECT  @max_books =  max(read_now) from vw_all_clients_and_num_of_books
	SELECT * FROM vw_all_clients_and_num_of_books where read_now = @max_books
GO
EXEC max_books_in_the_hands

--2.Создать хранимую процедуру, выводящую самую популярную книгу
CREATE PROC most_popular_book
AS
	SELECT * FROM books WHERE id = (SELECT TOP(1) book_id FROM journal GROUP BY book_id ORDER BY (COUNT(id)) DESC)
GO
EXEC most_popular_book

--3.Создать хранимую процедуру, выводящую все книги и среднее время, на которое их брали в днях
CREATE PROC reading_time
AS
	SELECT b.*, (CASE WHEN t.average IS NULL THEN 0 ELSE t.average END) AS days
	FROM books b
	LEFT JOIN (
		SELECT book_id, 
				AVG(datediff (day, ddate, case when return_date_real IS NOT NULL THEN return_date_real ELSE GETDATE() END)) AS average 
		FROM journal 
		GROUP BY book_id
	) AS t ON id = t.book_id
GO
EXEC reading_time

/*с входными параметрами*/
--1.Создать хранимую процедуру с параметром книга и выводящую всех читателей, бравших эту книгу.
CREATE PROC who_use_it
	@title varchar(50)
AS
	SELECT * 
	FROM clients 
	WHERE id IN (
		SELECT CLIENT_ID 
		FROM journal 
		WHERE book_id = (
			SELECT ID 
			FROM books 
			WHERE name LIKE '%'+@title+'%'
		)
	)
GO

EXEC who_use_it @TITLE = 'ОБЪЕКТНО'
--2.Создать хранимую процедуру, имеющую параметр читатель и выводящую все книги, которые он брал.
CREATE PROC what_they_read
	@Fname varchar(50),
	@Lname varchar(50)
AS
	SELECT book_id, b.name
	FROM journal
	JOIN books b ON book_id = b.id 
	WHERE client_id = (
		SELECT id 
		FROM clients 
		WHERE family LIKE @Lname AND name LIKE @Fname
	)
GO

EXEC what_they_read 'Снежана', 'Морозова'

--3.Создать хранимую процедуру, имеющую два параметра книга1 и  книга2. Она должна возвращать клиентов, которые вернули книгу1 быстрее чем книгу2. 
--	Если какой-либо клиент не брал одну из книг – он не рассматривается.


/*с выходными параметрами*/
--1.Создать хранимую процедуру с входным параметром тип, рассчитывающую количество книг этого типа.
CREATE PROC num_books_of_type
	@BOOK_TYPE INT,
	@NUM_OF_BOOKS INT OUTPUT
AS
	SELECT @NUM_OF_BOOKS = COUNT(id) FROM books WHERE type_id = @BOOK_TYPE
GO

DECLARE @VAL INT
EXEC num_books_of_type 2, @VAL OUTPUT
PRINT @VAL
--2.Создать хранимую процедуру с входным параметром клиент и выходным параметром – количество книг находящихся у него
CREATE PROC how_much_client_take (@UID INT, @NUM_OF_BOOKS INT OUTPUT)
AS
	SELECT @NUM_OF_BOOKS = read_now FROM vw_all_clients_and_num_of_books WHERE ID = @UID
	PRINT @NUM_OF_BOOKS
GO

DECLARE @HOW INT
EXEC how_much_client_take 2, @HOW OUTPUT
PRINT 'HE\SHE TAKES '+ CONVERT(VARCHAR(2), @HOW) + ' BOOKS'
--3.Создать хранимую процедуру с входным параметром книга и двумя выходными параметрами, возвращающими самое большое время 
	--на который брали книгу и читателя, поставившего рекорд
CREATE PROC read_time_record (@BOOK INT, @UFname VARCHAR(50) OUTPUT, @ULname VARCHAR(50) OUTPUT, @RECORD INT OUTPUT)
AS
	DECLARE @UID INT
	SELECT TOP(1) @UID = client_id,
		@RECORD = (datediff (day, ddate, case when return_date_real IS NOT NULL THEN return_date_real ELSE GETDATE() END))
	FROM journal
	WHERE book_id = @BOOK
	ORDER BY datediff (day, ddate, CASE WHEN return_date_real IS NOT NULL THEN return_date_real ELSE GETDATE() END) DESC
	
	SELECT @UFname = name, @ULname = family FROM clients WHERE id = @UID
GO

DECLARE @NAME VARCHAR(50), @FAMILY VARCHAR(50), @VAL INT
EXEC read_time_record 9, @NAME OUTPUT, @FAMILY OUTPUT, @VAL OUTPUT
PRINT @NAME +' '+@FAMILY+' TAKES BOOK FOR '+ CONVERT(VARCHAR(3), @VAL)+' DAYS'