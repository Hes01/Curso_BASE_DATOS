CREATE DATABASE BD_2023_II_1
go
use BD_2023_II_1

go 

create table Facultad(
	id tinyint identity(1,1) not null,
	nombre varchar(50) not null,
	constraint pk_facultad primary key clustered(id asc)
)

go

create table Escuela(
	id tinyint identity(1,1) primary key,
	nombre varchar(60) not null,
	codigo char(1) not null check(codigo>='0' and codigo<='9'),
	idFacultad tinyint not null,--fk
	foreign key (idFacultad) references Facultad(id) 
	)

	go

create table Alumno(
	id int identity(1,1) primary key,
	codigo char(10) not null,
	nombre varchar(30) not null,
	apPaterno varchar(30) not null,
	apMaterno varchar(30) not null,
	dni char(8) not null check(LEN(dni)=8 and dni not like '%[^0-9]'),
	correoElectronico varchar(70), 
	celular varchar(11) ,
	idEscuela tinyint not null foreign key references Escuela(id),
	domicilio varchar(100) not null,
	fecNac date not null,
	genero char(1) not null
	)
	go
create table Docente(
	id smallint identity(1,1) primary key,
	nombre varchar(30) not null,
	apPaterno varchar(30) not null,
	apMaterno varchar(30) not null,
	dni char(8) not null, --poner check por alter
	correoElectronico varchar(70),
	telefono varchar(11),
	idFacultad tinyint not null,--<<fk
	domicilio varchar(100),
	fecNac date,
	genero char(1) check(genero='M' or genero ='F'),
	constraint fk_docente foreign key (idFacultad) references Facultad(id)
	)
	go

create table Curso(
	id smallint identity primary key,
	codigo char(6) not null,
	nombre varchar(70) not null,
	creditos tinyint not null check( creditos >='1' and creditos <='4'),
	modalidad char(1) not null check( modalidad ='O' or modalidad ='E')
)
go
create table Inscripcion(
	id int identity(1,1) primary key,
	idAlumno int not null foreign key references Alumno(id),
	idCurso smallint not null foreign key references Curso(id),
	grupo char(2) not null,
	seccion char(1) not null,
	año char(4) not null, 
	semestre char(1) not null,
	fechaInscripcion datetime not null,
	unique(idAlumno, idCurso, año, semestre)
)
go
create table Programación(
	id char(6) ,
	grupo char(2) not null,
	seccion char(1) not null,
	año char(4) not null,
	semestre char(1) not null,
	idDocente smallint foreign key references Docente(id)
)
go

alter table Programación alter column id char(6) not null

alter table Programación add
constraint pk_programacion primary key Clustered (id asc)

alter table Programación add
xyz char(2) not null


alter table Programación alter column xyz char(2) not null


alter table Programación drop
column xyz

alter table Programación add
foranea smallint not null


alter table Programación add
constraint fk_Programacion foreign key (foranea) references Docente(id)

alter table Programación drop constraint fk_Programacion

alter table Programación drop column foranea
--primero se elimina el constraint luego ya la columna foranea :D




--------------------------------------------------------------------
--formas de crear un primary key,default,fk
--al momento y despues

create table NuevaTabla(
id int not null default 0 primary key,
--default:
--alter table NuevaTabla add
--Constraint DF_nuevaTabla default 0 for id


--constraint pk_NuevaTabla primary key clustered(id asc),
--alter NuevaTabla add
--constraint pk_nuevaTabla primary key clustered(id asc), 
nombre varchar(40) not null,
puntos smallint not null check(puntos>='1' and puntos <='4'),
idDocente smallint foreign key references Docente(id)--references Docente(id),
--constraint fk_nuevaTabla foreign key references Docente(id),
--foreign key (idDocente) references Docente(id),
--con alter: 
--alter table NuevaTabla add 
--constraint fk_nuevaTabla foreign key (idDocente) references Docente(id)
--check:
--alter table NuevaTabla add 
--constraint ck_nuevaTabla check(puntos>='1' and puntos <='4')
)  


select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME='Alumno'


use TestJoin
drop database BD_2023_II_1