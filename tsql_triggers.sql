/*Триггера на вставку*/
--1.Создать триггер, который не позволяет добавить читателя с номером паспорта, который уже есть у существующего читателя
ALTER TRIGGER i_clients ON clients
INSTEAD OF INSERT
AS
	BEGIN
		IF EXISTS (SELECT * FROM clients WHERE passport = (select passport from inserted))
			BEGIN
				PRINT 'Такие паспортные данные уже есть в системе'
				ROLLBACK TRANSACTION
			END
		ELSE
			BEGIN
				INSERT INTO clients (name, family, passport) (SELECT name, family, passport FROM inserted)
			END
	END
GO

--INSERT INTO clients 
	--VALUES ('Петров','Тимур','6666 987543')

--2.Создать триггер, который не позволяет добавить запись в журнал библиотекаря, в которой дата возврата не NULL
CREATE TRIGGER tr_date ON journal
INSTEAD OF INSERT
AS
	BEGIN
		IF exists (SELECT * FROM inserted WHERE return_date IS NULL)
			BEGIN
				PRINT 'Не указана дата возврата'
				ROLLBACK TRANSACTION
			END
		ELSE
			BEGIN
				INSERT INTO journal (ddate, book_id, client_id, return_date) (SELECT ddate, book_id, client_id, return_date FROM inserted)
			END
	END
GO

--INSERT INTO journal VALUES 
	--('16-12-2015', '3', '3', '30-12-2015', NULL);

--3.Создать триггер, который не позволяет выдать книгу, который нет в наличии
ALTER TRIGGER tr_date ON journal
INSTEAD OF INSERT
AS
	DECLARE @amount int
	SELECT @amount = cnt FROM books WHERE id = (SELECT book_id FROM inserted); 
	BEGIN
		IF @amount = 0
			BEGIN 
				PRINT 'Выдавать нечего'
				ROLLBACK TRANSACTION
			END
		ELSE
			BEGIN
				INSERT INTO journal (ddate, book_id, client_id, return_date) (SELECT ddate, book_id, client_id, return_date FROM inserted)
			END
	END
GO

--INSERT INTO journal VALUES 
	--('16-12-2015', 16, '3', '30-12-2015', NULL);
 
/*Триггера на модификацию*/
--1.Создать триггер, не позволяющий изменить паспорт читателя
ALTER TRIGGER tr_client ON clients
INSTEAD OF update
AS
	IF UPDATE(passport)
		BEGIN
			PRINT 'Приколочено. Менять нельзя'
			ROLLBACK TRANSACTION
		END
	ELSE
		BEGIN
			UPDATE clients SET name = i.name, family = i.family FROM inserted i, clients c WHERE c.id = i.id
		END
GO

--update clients set family = 'frolova' where id = 1015
--2.Создать триггер, который не позволяет изменить читателя, у которого на руках есть книги
alter trigger tr_client on clients
instead of update
as
	begin
		if exists (select * from journal where client_id = (select id from inserted) and return_date_real is null)
		begin
			print 'Нельзя менять. Он пока читает'
			rollback transaction 
		end
		else
		begin
			update clients set name = i.name, family = i.family from inserted i, clients c where c.id = i.id
		end
	end
go

--update clients set name = 'Vasya' where id = 4
--3.Создать триггер, который не позволяет установить реальную дату возврата журнала библиотекаря меньше, чем дата выдачи
create trigger tr_corruption on journal
instead of update
as
	begin
		if exists (select * from journal where id = (select id from inserted) and ddate >=  (select return_date_real from inserted))
			begin
				print 'Не надо мухлевать'
				rollback transaction
			end
		else
			begin
				update journal set return_date_real = i.return_date_real from inserted i, journal j where j.id = i.id
			end
	end
go

update journal set return_date_real = '27-09-2015' where id = 1
/*Триггера на удаление*/
--1.Создать триггер, который при удалении читателя в случае наличия на него ссылок откатывает транзакцию
create trigger tr_remember_user on clients
instead of delete
as
	if exists (select * from journal where client_id = (select id from deleted))
	begin
		print 'Память о читателе - бесценна'
		rollback transaction
	end
	else
	begin
		delete from clients where id = (select id from deleted)
	end
go

--delete from clients where id = 3
--2.Создать триггер, который при удалении книги в случае наличия на нее ссылок откатывает транзакцию
create trigger tr_remember_book on books
instead of delete
as
	if exists (select * from journal where book_id = (select id from deleted))
	begin
		print 'Память о книге - бесценна'
		rollback transaction
	end
	else
	begin
		delete from books where id = (select id from deleted)
	end
go

--delete from books where id = 1
--3.Создать триггер, который при удалении строки журнала в случае, если книга не возвращена - откатывает транзакцию
CREATE TRIGGER tr_corruption2 ON journal
INSTEAD OF delete
AS
	IF exists (SELECT * FROM journal WHERE id = (SELECT id FROM deleted) AND return_date_real IS NULL)
	BEGIN
		PRINT 'Книга не на полке'
		ROLLBACK TRANSACTION
	END
	ELSE 
	BEGIN
		DELETE FROM journal WHERE id = (SELECT id FROM deleted)
	END
GO

--delete from journal where id = 1022