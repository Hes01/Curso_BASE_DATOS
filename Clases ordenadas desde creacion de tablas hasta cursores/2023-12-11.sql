--Lunes, 11 dic 


--DR:para el trabajo de bd

use TRIBUTOS


--integridad referencial:tuplas repetidas, etc , no coherentes como codigos pk repetidos
--formas de ... :rechazar, valor null,valores por defecto  


--Repasando insersiones 
		INSERT INTO Alumno( codigo, nombre, apPaterno, apMaterno, dni, correoElectronico, celular, idEscuela, domicilio, fecNac, genero)
VALUES('0512019134', 'Elvis', 'Huanca', 'Flores', '74026711', 'elvishuancaflores@gmail.com', '917297036', 1, 'Piura', '2000/06/03', 'M');

--despues
		INSERT INTO Alumno( codigo, nombre, apPaterno, apMaterno, dni, correoElectronico, celular, idEscuela, domicilio, fecNac)
VALUES('0512019134', 'Elvis', 'Huanca', 'Flores', '74026711', 'elvishuancaflores@gmail.com', '917297036', 1, 'Piura', '2000/06/03');

--el despues puede aceptar o rechazar en forma de null si la columna esta en null y puede rechazar si esta en not null, asi mismo aceptar 
--si esta por default 


--ACTUALIZAR TABLAS 

--UPDATE
	--update TABLA set fecha='2004' 
	update Alumno	set fecNac ='2004/05/28',domicilio='sullana'
	Where id=1
	--no podria funcionar si el id esta referenciado 

--DELETE 
delete from Alumno
Where id=1
--la eliminacion anterior no podria funcionar si el id esta referenciado 

--truncate : borra todo el contenido de la tabla 
--delete: por filas y condiciones 

--SELECT:consultar o generar reportes 

---------------------------------------------------------------------------------------------------------------------------------------------------

--[Repaso de la clase 25 de setiembre del 2023]

--intereses tabla contribuyente
--deuda:ntributo,nReajuste,nInteres,nGasto
--predio:casa, edificio, etc : esto dice a que uso se le esta dando a ese predio

--SELECT 

select * from tDeudas

select top 1000 * from tDeudas --top primeras n filas especificadas

select cCod_cont,cAño from tDeudas --solo muestra el codigo y año

select cCod_cont as codigo,cAño  as año, nTributo+nReajuste+nInteres+nGasto as "Deuda total " from tDeudas --alias con as

select cCod_cont as codigo,cAño  as año, nTributo+nReajuste+nInteres+nGasto as "Deuda total " from tDeudas 
where nTributo+nReajuste+nInteres+nGasto >500 

select cCod_cont as codigo,cAño  as año, nTributo+nReajuste+nInteres+nGasto as "Deuda total " from tDeudas 
where nTributo+nReajuste+nInteres+nGasto >500 and cAño='2003' --agregando and ,or,not etc

--Para ordenar con order by se puede utilizar el alias de la columna 
select cCod_cont as codigo,cAño  as año, nTributo+nReajuste+nInteres+nGasto as "Deuda total " from tDeudas 
where nTributo+nReajuste+nInteres+nGasto >500 and cAño='2003'
order by "Deuda total " --alias para ordenar

select cCod_cont as codigo,cAño  as año, nTributo+nReajuste+nInteres+nGasto as "Deuda total " from tDeudas 
where nTributo+nReajuste+nInteres+nGasto >500 and cAño='2003'
order by 1,3 --indica la columna cCod_cont,cCod_Trib
--la forma de ordenar es en orden por ejm: primero 1 luego la columna 3

select cCod_cont as codigo,cAño  as año, nTributo+nReajuste+nInteres+nGasto as "Deuda total " from tDeudas 
where nTributo+nReajuste+nInteres+nGasto >500 and cAño='2003'
order by 3

--------------------------------------------------------------------------------------------------------------
--------------------------------------------SUBCONSULTAS------------------------------------------------------
--...es una consulta dentro de otra consulta


--OPERADOR IN
--listar los contribuyentes cuya calificacion sea A o Z
select *
from tLugares
where calificacion = 'Z' or calificacion ='A'
--pero tambien es equivalente al or 
select *
from tLugares
where calificacion IN ('Z','A')--agrupa un grupo o lista de valores a consultar

--operador LIKE

select *
from tContribuyente
where cNombre like 'ALVAREZ%'--Aquellos contributentes que EMPIEZE con ALVAREZ

select *
from tContribuyente
where cNombre like '%ALVAREZ'--Aquellos contributentes que TERMINE en ALVAREZ

select *
from tContribuyente
where cNombre like '%ALVAREZ%'--todos los que EMPIEZAN, TERMINAN, O TIENEN INTERMEDIO el apellido ALVAREZ

--operador DISTINCT 
select  distinct cCod_cont 
from tDeudas --listar todos los contribuyentes que tienen deudas (sin que se repitan)

--ver los años de deudas 
select  distinct cAño 
from tDeudas --listar todos los años que tienen deudas (sin que se repitan)
order by 1 


--si quiero saber el codigo de contribuyente y año de deuda 
select distinct cCod_cont,cAño--nota: el distinct va una sola vez para todas las columnas 
from tDeudas
order by 1,2

--Listar los nombres de contribuyentes que viven en asentamientos humanos 
--Estos son aquellos cuyo nombre de lugar empieza con A.H.
select top 100*
from tContribuyente 
where ( select cCod_Lug
		from tLugares 
		where cNombre LIKE 'A.H%')


--Listar las deudas de los contrubuyentes 
select *
from tDeudas








