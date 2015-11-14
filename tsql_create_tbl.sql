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
VALUES ('�������', 10.00, 60), ('������', 50.00, 21), ('����������', 300.00, 7);
INSERT INTO clients 
VALUES ('���������','����','1122 123443'), 
		('��������','�������','2233 987543'), 
		('���������','������','4409 878621'), 
		('��������','����','5101 320947'), 
		('�������','�������','5666 336699');
INSERT INTO books
VALUES ('����������� ���', 50, 1),
		('�������� � ������ ������', 30, 1),
		('��������� ������ �����������', 15, 2),
		('Unix-�������', 40, 1),
		('Linux ������ �����������', 40, 1),
		('FreeBSD. ���������, ���������, �������������', 10, 2),
		('����������� ������������� STL', 100, 1),
		('���� ���������������� ��', 70, 1),
		('��������-��������������� ����������������', 70, 1),
		('���������������� ��������� � ������ ������������', 20, 2),
		('��� ������ ���������� ����', 6, 3),
		('������ � �������� ������ ��������', 30, 1),
		('MySQL: ���������� �� �����', 33, 1),
		('SQL � �������� � �������', 66, 1),
		('Oracle. �������������� ��� ������', 23, 2),
		('������� ������. ��������', 1, 3);
INSERT INTO books VALUES ('�������� �������������', 0, 2);