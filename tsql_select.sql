/*	������������� �������
1.	������� ���� ���������
2.	������� ��� �����, ������� ��� � �������
3.	������� ���� ���������, ���������� � ���������� ������� �� �������
4.	������� ���� ���������, ���������� � ���������� ������� �� ������� � � �������� ������� �� �����
5.	������� ��� ������ �� ������� ������������ ���� �������� ������� ������ ��������� ����
6.	������� ��� �����, � ������� � ������������ ���� ����� ������
7.	��������� ���������� ����, ������� ��� � �������
*/
set dateformat 'dmy';

SELECT * FROM clients;
SELECT * FROM books WHERE cnt = 0;
SELECT * FROM clients ORDER BY family ASC;
SELECT * FROM clients ORDER BY family ASC, name DESC;
SELECT * FROM journal WHERE return_date < '01-01-2015';
SELECT * FROM books WHERE name LIKE '%����%';
SELECT COUNT(id) as not_in_library FROM books WHERE cnt = 0;

/* ������� � ������������
1.	������� ��� ����� ���� �����������
2.	������� ��� �������� � ������� ���� �����������
3.	������� ��� ����� ���� �����������, ������� �� ����� � ���������
*/

SELECT * FROM books WHERE type_id = (SELECT id FROM book_types WHERE name = '����������');
SELECT * FROM journal WHERE book_id = (SELECT id FROM book_types WHERE name = '����������');
SELECT * FROM journal WHERE book_id = (SELECT id FROM book_types WHERE name = '����������') AND return_date_real IS NULL;

/*
1.	������ ������ ������������ � ���������
2.	������� ������ ������������ � ���������, ������� ���������, ������� �� ����� ����
3.	������� ������ ������������, ���������, ������� ���������, ������� �� ����� ���� � �����, ������� �����, ������� �� ��������
*/

SELECT j.*, c.* FROM journal j
 JOIN clients c ON j.client_id = c.id;

SELECT j.*, c.* FROM clients c
LEFT JOIN journal j ON c.id = j.client_id;

SELECT j.*, c.*, b.* FROM books b
FULL JOIN journal j ON b.id = j.book_id
FULL JOIN clients c ON j.client_id = c.id;
/*
1.	����� ���� �� ����� � ��������� �������.
2.	������ ������ ��������� �������.
3.	������ ������ �������� ������
4.	��� ����� ���������� �����
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
1.	�������� ������ �������
2.	������ ������� �� �1 ��� �����
*/

INSERT INTO clients VALUES ('�����','�����','4202 786463');
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
	(SELECT id FROM clients WHERE family = '�����'), 
	DATEADD(day, (SELECT t.day_count FROM books b LEFT JOIN book_types t ON b.type_id = t.id WHERE b.id = 10), '09-10-2015'), 
	NULL
);

/*
1.	�������� � ������ ���������� �������, ����� � ������ � ������ ������������ � ������ ����� ����� �������
2.	�������� ������ � ������, � ������, ���� ���� � ������� ������� ������ 10, ���������� ��������
*/
BEGIN TRANSACTION;
INSERT INTO clients VALUES ('�����','���������','4202 786463'); 
INSERT INTO books VALUES ('Objective-C', 6, 3);
INSERT INTO journal VALUES
(	'11-10-2015', 
	(SELECT id FROM books WHERE name = 'Objective-C'), 
	(SELECT id FROM clients WHERE family = '�����'), 
	DATEADD(day, (SELECT t.day_count FROM books b LEFT JOIN book_types t ON b.type_id = t.id WHERE b.id = 10), '11-10-2015'), 
	NULL
);
IF @@ERROR = 0
	COMMIT TRANSACTION;

BEGIN TRANSACTION;
INSERT INTO journal VALUES
(	'01-09-2015', 
	(SELECT id FROM books WHERE name LIKE '%��������%'), 
	(SELECT id FROM clients WHERE name LIKE '%���%'), 
	DATEADD(day, (SELECT t.day_count FROM books b LEFT JOIN book_types t ON b.type_id = t.id WHERE b.id = 10), '01-09-2015'), 
	NULL
);
IF @@ERROR = 0 AND ((SELECT COUNT(id) FROM journal WHERE client_id = (SELECT id FROM clients WHERE name LIKE '%���%')) < 10)
	BEGIN
		COMMIT TRANSACTION;
		SELECT * FROM journal;
	END
ELSE
	ROLLBACK TRAN;
	
/*
1.	������� ������ �� �������, ��� �������� ���� �������� ������ ��������� ����
2.	������� ������� � ���, ��������� � ���, ������ � �������
3.	������� �����, �� ������� ������ �� ������� � �������
*/
INSERT INTO journal VALUES
(	'01-09-2014', 
	(SELECT id FROM books WHERE name LIKE '%��������%'), 
	(SELECT id FROM clients WHERE name LIKE '%���%'), 
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
1.	������� � ������ ���������� ����� � ������ � �� ������
2.	�� ��, ��� � �1, �� ���������� ��������
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
1.	�������� ���������� ���� � �������� �������������
2.	�������� �������� ���� �������� �������� �����
3.	�������� ���������� ����, ������� ������ ��������� ������� (???)
*/

UPDATE books SET cnt = 0 WHERE name LIKE '%��������%';
SELECT * FROM books;

UPDATE journal SET return_date = '17-10-2014', return_date_real = '16-10-2014' WHERE book_id = 3;

UPDATE books set cnt +=1 WHERE id = (SELECT book_id FROM journal WHERE client_id = 1009);
  

/*
1.	� ������ ���������� �������� �������� ����� �� ���� ������� ������� �� ������ � ������� ��.
2.	�� ��, ��� � �1, �� ���������� ��������
*/

BEGIN TRAN;
	UPDATE journal SET book_id = 11 WHERE book_id = 6;
	/* ��� �������� ���� ��������
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



INSERT INTO clients VALUES ('���������','������','4801 789234');
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
