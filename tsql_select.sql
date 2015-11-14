/*	однотабличная выборка
1.	Вывести всех читателей
2.	Вывести все книги, которых нет в наличии
3.	Вывести всех читателей, упорядочив в алфавитном порядке по фамилии
4.	Вывести всех читателей, упорядочив в алфавитном порядке по фамилии и в обратном порядке по имени
5.	Вывести все строки из журнала библиотекаря дата возврата которых меньше некоторой даты
6.	Вывести все книги, у которых в наименовании есть слово «радар»
7.	Посчитать количество книг, которых нет в наличии
*/
set dateformat 'dmy';

SELECT * FROM clients;
SELECT * FROM books WHERE cnt = 0;
SELECT * FROM clients ORDER BY family ASC;
SELECT * FROM clients ORDER BY family ASC, name DESC;
SELECT * FROM journal WHERE return_date < '01-01-2015';
SELECT * FROM books WHERE name LIKE '%прог%';
SELECT COUNT(id) as not_in_library FROM books WHERE cnt = 0;

/* выборка с подзапросами
1.	Вывести все книги типа «уникальные»
2.	Вывести все операции с книгами типа «уникальные»
3.	Вывести все книги типа «уникальные», которые на руках у читателей
*/

SELECT * FROM books WHERE type_id = (SELECT id FROM book_types WHERE name = 'уникальные');
SELECT * FROM journal WHERE book_id = (SELECT id FROM book_types WHERE name = 'уникальные');
SELECT * FROM journal WHERE book_id = (SELECT id FROM book_types WHERE name = 'уникальные') AND return_date_real IS NULL;

/*
1.	Вывеси журнал библиотекаря и читателей
2.	Вывести журнал библиотекаря и читателей, включая читателей, которые не брали книг
3.	Вывести журнал библиотекаря, читателей, включая читателей, которые не брали книг и книги, включая книги, которых не выдавали
*/

SELECT j.*, c.* FROM journal j
 JOIN clients c ON j.client_id = c.id;

SELECT j.*, c.* FROM clients c
LEFT JOIN journal j ON c.id = j.client_id;

SELECT j.*, c.*, b.* FROM books b
FULL JOIN journal j ON b.id = j.book_id
FULL JOIN clients c ON j.client_id = c.id;
/*
1.	Число книг на руках у заданного клиента.
2.	Размер штрафа заданного клиента.
3.	Размер самого большого штрафа
4.	Три самые популярные книги
*/

SELECT COUNT(id) FROM journal WHERE client_id = 3;

SELECT SUM((result.delay * result.fine)) AS total_fine 
FROM (
	SELECT DATEDIFF(d, return_date, return_date_real) AS delay, t.fine AS fine
	FROM journal j
	JOIN books AS b ON j.book_id = b.id
	JOIN book_types AS t ON b.type_id = t.id
	WHERE DATEDIFF(dd, return_date, return_date_real) > 0 AND client_id = 4
) AS result;

SELECT MAX((result.delay * result.fine)) AS super_fine 
FROM (
	SELECT DATEDIFF(d, return_date, return_date_real) AS delay, t.fine AS fine
	FROM journal j
	JOIN books AS b ON j.book_id = b.id
	JOIN book_types AS t ON b.type_id = t.id
	WHERE DATEDIFF(dd, return_date, return_date_real) > 0
) AS result;

SELECT top (3) j.book_id, COUNT(j.book_id) AS total
FROM journal j 
GROUP BY j.book_id
ORDER BY total DESC;

/*
1.	Добавить нового клиента
2.	Выдать клиенту из п1 две книги
*/

INSERT INTO clients VALUES ('Титов','Борис','4202 786463');
declare @lastUser int;
set @lastUser = @@IDENTITY;
INSERT INTO journal VALUES
(	'10-01-2015', 
	9, 
	@lastUser, 
	DATEADD(day, (SELECT t.day_count FROM books b LEFT JOIN book_types t ON b.type_id = t.id WHERE b.id = 9), '10-01-2015'), 
	NULL
);
INSERT INTO journal VALUES
(	'09-10-2015', 
	10, 
	(SELECT id FROM clients WHERE family = 'Лядов'), 
	DATEADD(day, (SELECT t.day_count FROM books b LEFT JOIN book_types t ON b.type_id = t.id WHERE b.id = 10), '09-10-2015'), 
	NULL
);

/*
1.	Добавить в рамках транзакции клиента, книгу и запись в журнал библиотекаря о выдачи книги этому клиенту
2.	Добавить запись в журнал, в случае, если книг у данного клиента больше 10, транзакцию откатить
*/
BEGIN TRANSACTION;
INSERT INTO clients VALUES ('Ленин','Виссарион','4202 786463'); 
INSERT INTO books VALUES ('Objective-C', 6, 3);
INSERT INTO journal VALUES
(	'11-10-2015', 
	(SELECT id FROM books WHERE name = 'Objective-C'), 
	(SELECT id FROM clients WHERE family = 'Ленин'), 
	DATEADD(day, (SELECT t.day_count FROM books b LEFT JOIN book_types t ON b.type_id = t.id WHERE b.id = 10), '11-10-2015'), 
	NULL
);
IF @@ERROR = 0
	COMMIT TRANSACTION;

BEGIN TRANSACTION;
INSERT INTO journal VALUES
(	'01-09-2015', 
	(SELECT id FROM books WHERE name LIKE '%Рукопись%'), 
	(SELECT id FROM clients WHERE name LIKE '%неж%'), 
	DATEADD(day, (SELECT t.day_count FROM books b LEFT JOIN book_types t ON b.type_id = t.id WHERE b.id = 10), '01-09-2015'), 
	NULL
);
IF @@ERROR = 0 AND ((SELECT COUNT(id) FROM journal WHERE client_id = (SELECT id FROM clients WHERE name LIKE '%неж%')) < 10)
	BEGIN
		COMMIT TRANSACTION;
		SELECT * FROM journal;
	END
ELSE
	ROLLBACK TRAN;
	
/*
1.	Удалить выдачи из журнала, где реальная дата возврата меньше некоторой даты
2.	Удалить клиента и все, связанные с ним, записи в журнале
3.	Удалить книги, не имеющие ссылок из записей в журнале
*/
INSERT INTO journal VALUES
(	'01-09-2014', 
	(SELECT id FROM books WHERE name LIKE '%Рукопись%'), 
	(SELECT id FROM clients WHERE name LIKE '%неж%'), 
	DATEADD(day, (SELECT t.day_count FROM books b LEFT JOIN book_types t ON b.type_id = t.id WHERE b.id = 10), '01-09-2014'), 
	'21-09-2014'
);
SELECT * FROM journal;

DELETE FROM journal WHERE return_date_real < '01-01-2015';
SELECT * FROM journal;

DELETE FROM journal WHERE client_id = 1006;
DELETE FROM clients WHERE id = 1006;
SELECT * FROM clients;

SELECT * FROM books;
DELETE FROM books WHERE id NOT IN (SELECT book_id FROM journal);

/*
1.	Удалить в рамках транзакции книгу и записи о ее выдаче
2.	то же, что и п1, но транзакцию откатить
*/

BEGIN TRAN;
DELETE FROM journal WHERE book_id = 16;
DELETE FROM books WHERE id = 16;
IF @@ERROR = 0
	COMMIT TRAN;

BEGIN TRAN;
DELETE FROM journal WHERE book_id = 16;
DELETE FROM books WHERE id = 16;
IF @@ERROR = 0
	ROLLBACK TRAN;

/*
1.	Изменить количество книг с заданным наименованием
2.	Изменить реальную дату возврата заданной книги
3.	Изменить количество книг, которые выданы заданному клиенту (???)
*/

UPDATE books SET cnt = 0 WHERE name LIKE '%паттерны%';
SELECT * FROM books;

UPDATE journal SET return_date = '17-10-2014', return_date_real = '16-10-2014' WHERE book_id = 3;

UPDATE books set cnt +=1 WHERE id = (SELECT book_id FROM journal WHERE client_id = 1009);
  

/*
1.	В рамках транзакции поменять заданную книгу во всех записях журнала на другую и удалить ее.
2.	то же, что и п1, но транзакцию откатить
*/

BEGIN TRAN;
	UPDATE journal SET book_id = 11 WHERE book_id = 6;
	/* как изменить дату возврата
	UPDATE journal 
		SET return_date = DATEADD(	DAY, 
									(SELECT t.day_count FROM books b LEFT JOIN book_types t ON b.type_id = t.id WHERE b.id = 11),
									(SELECT ddate FROM journal WHERE book_id = 11) 
								)
									WHERE book_id = 11;
	
	*/
	DELETE FROM books WHERE id = 6;
IF @@ERROR = 0
	COMMIT TRAN

BEGIN TRAN;
	UPDATE journal SET book_id = 6 WHERE book_id = 11;
	DELETE FROM books WHERE id = 6;
IF @@ERROR = 0
	ROLLBACK TRAN



INSERT INTO clients VALUES ('Похмелкин','Михаил','4801 789234');
INSERT INTO journal VALUES 
	('27-09-2014', '3', '3', DATEADD(day, 7,  GETDATE()), NULL);
INSERT INTO journal VALUES 
	('10-01-2015', 9, 4, DATEADD(day, 60, '10-01-2015'), '10-06-2015');
INSERT INTO journal VALUES 
	('07-03-2015', 6, 1, DATEADD(day, 21, '07-03-2015'), '10-06-2015');
INSERT INTO journal VALUES 
	('07-03-2015', 6, 4, DATEADD(day, 21, '07-03-2015'), '01-05-2015');

select convert(nvarchar(30), GETDATE(), 103);
select j.*, c.family, c.name from journal j 
left join clients c on j.client_id = c.id;
