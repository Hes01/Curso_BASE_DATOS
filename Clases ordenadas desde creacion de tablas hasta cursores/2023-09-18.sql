--Base datos-inscripción por cursos 
--18 de setiembre 2023
----------------------------------
--en el archivo datos de fila estan todos los archivos 
--crecimieno automatico : aumenta segun la asignacion que se le de; tambien se le puede limitar

--el _log es el archivo de registro: tiene archivos de borrado, transacciones y se podria recuperar una bd
-- la bd se puede reducir en modo automatico ; esto elim ina los log que son las transacciones

--Creacion de una base de datos 
--Ejm:

--create database baseDatos2023II
----Aqui tambien se puede agregar las configuraciones adicionales como para el crecimiento etc...
--CREATE DATABASE [BD20232]
-- CONTAINMENT = NONE
-- ON  PRIMARY 
--( NAME = N'BD20232', FILENAME = N'E:\bd20232\BD20232.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
-- LOG ON  
--( NAME = N'BD20232_log', FILENAME = N'E:\bd20232\BD20232_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
--GO
create database hola
drop database if exists hola
--Sistemas Gestores de Base de Datos:
	--pgAdmin 4
	--postgres
--Tipos de Datos:
	--char: cuando vamos a guardar datos de longitud constante
	--varchar: cuando los datos que almacenamos no son de longitud fija sino de longitud variable
	--bit: dato entero que adminte valores de 0 a 1
	--tinyint: dato entero que adminte valores de 0 a 255
	--smallint: dato entero que adminte valores de -32 768 a 32 767
	--int: dato entero que adminte valores de -2 147 483 684 a +2 147 483 684
	--identity(1,1): parte entera es donde va a empezar la numeracion, parte decimal el incremento
	--numeric: tipo de dato que admite valores reales [numeric(l, d)]>>>>>l=longitud total(.)>>>>>d=decimales

--listar Restricciones: select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME='Alumno'

--Borrar una Base de Datos: drop database if exists "bdBaseDeDatos"
--Crear una Base de Datos: create database bdBaseDeDatos

----------------------------------------------------------------------------------------

--CREACION DE TABLAS

--a todas las tablas se le crea un id ; identity
--valor o enlace predeterminado : poner un valor por defecto
--no se pueden borrar datos de una tabla porque pueden estar referenciados
--todo sistema tiene que tener auditoria es decir tiene que ser auditable


-----------------------------------------------------------------------------------------------

--CREAR TABLAS:


--CLAVE FORANEA: relacionada con la clave primaria de otra tabla

--BORAR UNA CLAVE FORANEA: ALTER TABLE Escuela DROP CONSTRAINT FK_ESCUELA_FACULTAD


--CREAR TABLA ALUMNO


----clase 20

--NOTA:Restriccion de identidad se define a traves de los foreign key es la restriccion del modelo relacional de sgbd


--CLASE 20 SETIEMBRE 2023

--TAREA: Traer la tabla alumno y tabla escuela, docente y una tabla de inscripcion y curso crear y como se relacionan con la tabla facultad
--nota: las tablas no se ponen en plural solo en singular 
--tablas : alumno, escuela, docente, inscripcion, curso,facultad

use BD_2023_II

drop database CURSO_BASE_DATOS
	--FACULTAD
	create table Facultad(
		id tinyint identity(1,1) not null, --PKidFacultad
		nombre varchar(50) not null,
		constraint pk_facultad primary key clustered(id asc)
	)

	--ESCUELA
	create table Escuela(
	id tinyint identity(1,1) primary key,-->>>>>> PKidEscuela 
	nombre varchar(60) not null,--deberia ponerse restriccion para que el nombre sea unico
	codigo char(1) not null check(codigo>='0' and codigo<='9'),--son 9 escuelas (0-9) >>>>se le agrega constrain
	idFacultad tinyint not null,
	foreign key ( idFacultad) references Facultad(id) --
	)
	
	---ALUMNO
	create table Alumno(
	id int identity(1,1) primary key,--<<<<< pkAlumno
	codigo char(10) not null,--sin importar si es unico a todas las tablas se les define un id por preferencia del profesor 
	nombre varchar(30) not null,
	apPaterno varchar(30) not null,
	apMaterno varchar(30) not null,
	dni char(8) not null,
	correoElectronico varchar(70),
	celular varchar(11) ,
	idEscuela tinyint not null foreign key references Escuela(id),	-->>>>>>>>  FKidEscuela
	domicilio varchar(100) not null,
	fecNac date not null,
	genero char(1)
	)

	--DOCENTE 
	create table Docente(
	id smallint identity(1,1) primary key,-->>>pk_docente
	nombre varchar(30) not null,
	apPaterno varchar(30) not null,
	apMaterno varchar(30) not null,
	dni char(8) not null,
	correoElectronico varchar(70),
	telefono varchar(11) ,
	idFacultad tinyint not null,	-->>>>>>>>  FKidFacultad
	domicilio varchar(100),
	fecNac date ,
	genero char(1) check(genero='M' or genero='F'),--genero ('M','F') otra forma de ponerlo 
	constraint fk_Docente foreign key (idFacultad) references Facultad(id)
)


--CURSO
create table curso(
	id smallint identity primary key,
	codigo char(6) not null,
	clave char(4) not null,
	nombre varchar(70) not null ,
	creditos tinyint not null check (creditos>='1' and creditos<='4'),
	modalidad char(1) not null check (modalidad='O' or modalidad='E') --es el tipo para ver si es obligatorio 
)

--INCRIPCIÓN
create table Inscripcion(
	id int identity(1,1) primary key,--
	idAlumno int not null foreign key references Alumno(id),--Nota: el idcurso y el idalumno si se puede repetir por que puede que jalo y de nuevo lo lleve
	idCurso smallint not null foreign key references Curso(id),-- unique 
	grupo	char(2) not null,--unique 
	seccion char(1) not null,
	año char(4) not null,--unique
	semestre char(1) not null,-- check(semestre='I' or semestre='II'),--unique
	fechaInscripcion datetime not null ,--nota : deben ser unique idcurso , año y semestre porque un alumno no puede inscribirse en el mismo 
	--curso en el mismo año y el mismo semestre y el mismo grupo
	unique (idAlumno, idCurso, año,semestre) --forma de hacerlo ojo :O
	)

	-- Tabla ProgramacionAcademica
CREATE TABLE Programacion(
    id char(6), 
	grupo	char(2) not null,--unique 
	seccion char(1) not null,
	año char(4) not null,--unique
	semestre char(1) not null,-- check(semestre='I' or semestre='II'),--unique
	idDocente Smallint foreign key references Docente(id)--docente el lo tiene como int 
)


--ALTER TABLE para agregar columna

alter table Facultad add codigo char(2) not null --si hubiere check aqui se crea tambien , con comas agrego mas columas ejm: num int

alter table Facultad add xyz char(2) not null 

--borrar columna
alter table Facultad drop column xyz --sin tipo de dato :D

--modificar tipo dato
alter table Facultad alter column codigo char(3)

--para agregar  : uniques checks fk pk... (REPASAR)
	--alter table TABLA add constraint NOMBRE ...
	--para fk: foreign key (cual es la fk en tu tabla) references Nombretabla_dondeviene(idClavePrimaria)
	--para pk: primary key clustered nombreTablaReferenciada(id asc)
	--para uq: unique(idAlumno,idCurso,año,semestre)
	--para df:default 'hola' for NombreColumna

--borrar: drop constraint 
	--alter table TABLA drop constraint NOMBRE_CONSTRAINT

--nota:
--El creo un valor por defecto en la tabla curso
	--dentro de una tabla se crea como : curso varchar(30) not null default 'sin nombre'

	--CLASE 22 SETIEMBRE DE 2023 
	
	--creo un default para creditos 

	--Investigar que es clustered y no clustered

	--ya vimos ddl y dml y alter para borrar tablas y constrains, asi mismo como para agregar


	--las sentencias ddl: lenguaje de definicion de datos son create , drop y alter


---------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------





--PRACTICAR

	--renombrar columnas 
exec sp_rename 'Facultad.xyz','abc','COLUMN'
--tip tambien se puede renombrar por diseño de tablas


-----------------------------------------25 SETIEMBRE DEL 2023----------------------------------------------------------------------------------

	-- las sentencias dml: lenguaje de manipulacion de datos son: update, select, insert,delete

--INSERT
	--insertar datos en una tabla
	--insert into TABLA(atributo1, atributo2...) values (valor1,valor2...)
		insert into Facultad(nombre,codigo) values('INGENIERIA INDUSTRIAL','05')
		insert into Escuela(nombre,codigo,idFacultad) values('INGENIERIA INFORMATICA','1',1)


		--primera forma de hacer 
		INSERT INTO Alumno( codigo, nombre, apPaterno, apMaterno, dni, correoElectronico, celular, idEscuela, domicilio, fecNac, genero)
VALUES('0512019134', 'Elvis', 'Huanca', 'Flores', '74026711', 'elvishuancaflores@gmail.com', '917297036', 1, 'Piura', '2000/06/03', 'M');
		--segundo forma de hacerlo
INSERT INTO Alumno
VALUES('0512019134', 'Elvis', 'Huanca', 'Flores', '74026711', 'elvishuancaflores@gmail.com', '917297036', 1, 'Piura', '2000/06/03', 'M');

INSERT INTO Alumno
VALUES('0512019137', 'Lucas', 'Jacinto', 'Alvares', '75028755', 'LucasEJA@gmail.com', '984511236', 1, 'sechura', '2006/06/03', 'M');

INSERT INTO Alumno
VALUES('0512019107', 'Gustavo', 'Garcia', 'Tacure', '71026589', 'Gustavo89@gmail.com', '956234578', 1, 'castilla', '2002/07/03', 'M');

INSERT INTO Alumno
VALUES('0512018041', 'felix', 'feria', 'reyes', '71026515', 'felix89@gmail.com', '956234554', 1, 'castilla', '2000/07/07', 'M');


		select * from Alumno
		--tarea: como inicializar un valor identity que ya se creo por error
		
		
--UPDATE
	--update TABLA set fecha='2004' 
	update Alumno	set fecNac ='2004/05/28',domicilio='sullana'

	--modificar registro con where
		--update TABLA set COLUMNA=VALOR where columna=valor
	update Alumno	set fecNac ='2004/05/28',domicilio='sullana' where id=1; --se utiliza and, or y not

	--update Alumno	set fecNac ='2004/05/28',domicilio='sullana' where not id=1;--para los que son diferente de 1


--DELETE: aqui borra registros de una tabla pero poniendo condiciones 

	delete from Alumno where id=1

--TRUNCATE:Borra todos los registros de una tabla 

	truncate table Alumno --borra todos los registros de los alumnos aqui no se admite condiciones
	--ojo: si quiero borrar datos de una tabla que esta referenciada con fk se elimina ese fk para proceder a eliminar
--SELECT
	select * from Alumno

	UPDATE Alumno set correoElectronico='jose@gmail.com' where id=8;
	update Alumno set celular='963258745' where id=6


	
	--tarea: como inicializar un valor identity que ya se creo por error

	--tabla temp
	--create table #temp(
	--	id int ,
	--	nombre varchar(90)
	--)

	--para copiar de una normal a una tabla temporal es lo siguiente

	--ejmplo tenemos la tabla con los datos : Alumno(id , nombre)

	--copiar de la original a la temporal
	--insert into #temp(id,nombre)
	--select id,nombre
	--from Alumno

	--de la temporal a la original

	--insert into Alumno(id,nombre)
	--select id,nombre
	--from #temp

