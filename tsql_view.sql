/*Представления
1.	Создать представление, отображающее всех читателей
2.	Создать представление, отображающее всех читателей, фамилия которых начинается на заданную букву
3.	Создать представление, отображающее всех читателей, у которых количество книг на руках больше 8
4.	Создать представление, отображающее все книги и читателей, о которых найдены записи в журнале с заданной даты по заданную дату
5.	Создать представление, отображающее всех читателей и количество книг, находящихся у них на руках
*/

/*IF OBJECT_ID ('vw_clients', 'view') IS NOT NULL 
DROP VIEW vw_clients;
GO*/
--1
CREATE VIEW vw_clients AS 
SELECT * FROM clients
GO
--SELECT * FROM vw_clients

--2
CREATE VIEW vw_clients_with_family AS
SELECT * FROM clients WHERE family LIKE 'М%'
GO
--SELECT * FROM vw_clients

--3
CREATE VIEW vw_who_read_more_2_books AS
	SELECT client_id, c.name, c.family
	FROM
		(SELECT client_id, 
		(CASE WHEN COUNT(book_id) >= 2 THEN 1 END) AS num_of_books 
		FROM journal 
		WHERE return_date_real IS NULL 
		GROUP BY client_id
		) AS sort_client
	JOIN clients c ON client_id = c.id
	WHERE num_of_books IS NOT NULL
GO

--5
CREATE VIEW vw_all_clients_and_num_of_books AS
	SELECT 
		c.*, 
		(CASE WHEN sort_client.num_of_books IS NULL THEN 0 ELSE sort_client.num_of_books END) AS read_now 
	FROM clients c
	LEFT JOIN 
		(SELECT client_id, 
		COUNT(book_id) AS num_of_books 
		FROM journal 
		WHERE return_date_real IS NULL 
		GROUP BY client_id
		) AS sort_client ON c.id = sort_client.client_id
GO