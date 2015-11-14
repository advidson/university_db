CREATE TABLE clients (
	id int identity(1,1) PRIMARY KEY,
	family varchar(50) NOT NULL,
	name varchar(50) NOT NULL,
	passport varchar(50) NOT NULL
);

CREATE TABLE book_types (
	id int identity(1,1) PRIMARY KEY,
	name varchar(50) NOT NULL,
	fine decimal NOT NULL,
	day_count int 
);

CREATE TABLE books (
	id int identity(1,1) PRIMARY KEY,
	name varchar(50) NOT NULL,
	cnt int NOT NULL,
	type_id int FOREIGN KEY REFERENCES book_types (id)
);

CREATE TABLE journal (
	id int identity(1,1) PRIMARY KEY,
	ddate datetime NOT NULL DEFAULT getdate(),
	book_id int FOREIGN KEY REFERENCES books (id),
	client_id int FOREIGN KEY REFERENCES clients (id),
	return_date datetime,
	return_date_real datetime
);

INSERT INTO book_types 
VALUES ('обычные', 10.00, 60), ('редкие', 50.00, 21), ('уникальные', 300.00, 7);
INSERT INTO clients 
VALUES ('Сосулькин','Коля','1122 123443'), 
		('Морозова','Снежана','2233 987543'), 
		('Похмелкин','Никита','4409 878621'), 
		('Кукушкин','Петр','5101 320947'), 
		('Ананьев','Гавриил','5666 336699');
INSERT INTO books
VALUES ('Совершенный код', 50, 1),
		('Введение в теорию графов', 30, 1),
		('Алгоритмы сжатия изображений', 15, 2),
		('Unix-системы', 40, 1),
		('Linux полное руководство', 40, 1),
		('FreeBSD. Установка, настройка, использование', 10, 2),
		('Эффективное использование STL', 100, 1),
		('Язык программирования Си', 70, 1),
		('Объектно-ориентированное программирование', 70, 1),
		('Программирование драйверов и систем безопасности', 20, 2),
		('Как ломают телефонные сети', 6, 3),
		('Теория и практика защиты программ', 30, 1),
		('MySQL: Справочник по языку', 33, 1),
		('SQL в примерах и задачах', 66, 1),
		('Oracle. Проектирование баз данных', 23, 2),
		('Бибилия хакера. Рукопись', 1, 3);
INSERT INTO books VALUES ('Паттерны проекьтровния', 0, 2);