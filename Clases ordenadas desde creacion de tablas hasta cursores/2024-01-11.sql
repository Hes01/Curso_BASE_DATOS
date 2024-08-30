--11/01/2024
--FUNCIONES DE MANIPULACION DE CADENAS 

--RECORTAR CADENA DESDE EL INICIO
select top 10 cNombre ,left(cnombre,10) IZQUIERDO 
from tContribuyente
--EXTRAER CADENA DESDE EL FINAL
select top 10 cNombre ,right(cnombre,10) DERECHO
from tContribuyente
--LONGITUD DE LA CADENA;
				--Nota: no considera los espacios.
select top 10 cNombre ,LEN(cnombre) [LONGITUD DE LA CADENA]
from tContribuyente
--DEVUELVE EN MAYUSCULAS Y MINUSCULAS
select top 10 cNombre ,LOWER(cnombre) [CADENA EN MINUSCULAS]
from tContribuyente

select top 10 cNombre ,UPPER(cnombre) [CADENA EN MAYUSCULAS]
from tContribuyente

--ELIMINAR LOS ESPACIOS AL INICIO, AL FINAL Y EN LOS EXTREMOS
select top 10 cNombre ,LTRIM(cnombre) [QUITA ESPACIOS A LA IZQ]
from tContribuyente

select top 10 cNombre ,RTRIM(cnombre) [QUITA ESPACIOS A LA DER]
from tContribuyente

select top 10 cNombre ,TRIM(cnombre) [QUITA ESPACIOS EN LOS EXTREMOS]
from tContribuyente

--DEVUELVE LA PRIMERA POSICION SEGUN LA COINCIDENCIA

select top 10 cNombre ,PATINDEX('%E%',cnombre) [PRIMERA POSICION SEGUN LA COINCIDENCIA]
from tContribuyente

--REEMPLAZAR UNA PARTE POR LA CADENA 
			--La cadena ,cadena a buscar,cadena reemplazar
SELECT REPLACE('FELIX ESTUDIA EN LA UNIVERSIDAD','FELIX','ELVIS')

--REPLICAR UNA CADENA POR CIERTO NUMERO DE VECES LOS CUALES SE ESPECIFIQUEN 

SELECT REPLICATE('ELVIS',10)

--DEVOLVER CADENA DE ESPACIOS
--SPACE(N)

--DEVOLVER UNA CADENA A NUMERO ESPECIFICANDO SU ESCALA Y PRESICION
			--STR('CADENA',[ESCALA[,PRESICION]]) --los corchetes indica que es opcional
SELECT 'NOTA' + STR('126.5',3,1)  

SELECT 'NOTA' + STR('126.5')	--Lo que hace es concatenar convirtiendo el numero a cadena 

--DEVUELVE UNA PORCION DE LA CADENA INDICANDO DESDE DONDE EMPIEZA HASTA DONDE TERMINA
select SUBSTRING('felix trabaja',2,5)

--TAREA:

--hacer con el appmat ese apmat empieza despues
--de los dos espacios pero tambien termina
--cuando empieza el guion aqui se utilizara
--varias funciones
--funcion recomendada substring
--nombre empieza despues del guion ojo.

select top 50 cNombre
into NombresContribuyentes
from tContribuyente 

--TAREA mostrar:  apellidopat mat luego el nombre
--hacerlo en un select nada mas 

--AP+2espacios+AM+'-'+Nombres
select *
from NombresContribuyentes
--apPat-apMat-nombres

select PATINDEX('% %','h ola')
--patindex('% %',cNombre)
--SUBSTRING('holac',2,5)

select *
from NombresContribuyentes

--apPaterno
----------------------------------------------------------------------------------------------------
select left(cNombre,PATINDEX('% %',cNombre))
from NombresContribuyentes
----------------------------------------------------------------------------------------------------
--apMaterno
select substring('123456789',2,5-2)

select cnombre,PATINDEX('% %',cnombre),PATINDEX('%-%',cnombre) -PATINDEX('% %',cnombre)
from NombresContribuyentes
----------------------------------------------------------------------------------------------------
select  replace(
				SUBSTRING( substring(cNombre,PATINDEX('% %',cnombre),PATINDEX('%-%',cnombre)),
					1,
					PATINDEX('%-%', substring(cNombre,PATINDEX('% %',cnombre),PATINDEX('%-%',cnombre)))
					),
					'-',
					' '
				)
from NombresContribuyentes
----------------------------------------------------------------------------------------------------

--nombre
----------------------------------------------------------------------------------------------------
select replace(right(trim(cnombre), PATINDEX('%-%',REVERSE(trim(cnombre))) ) ,'-',' ' ) 
from NombresContribuyentes
----------------------------------------------------------------------------------------------------





select right('hola',2) 

--substring(cad,1,patindex(PATINDEX('%-%',cad))
select cNombre,PATINDEX('%-%',cNombre) guion,PATINDEX('% %',cNombre) espacio,rtrim(cnombre)
from NombresContribuyentes

----------------------------------------------------------------------------------------------------
select replace(SUBSTRING(
			SUBSTRING(
		(cNombre),
		PATINDEX('% %',(cNombre)),
		PATINDEX('%-%',(cNombre))
		)
			,1,
			patindex('%-%',SUBSTRING(
		(cNombre),
		PATINDEX('% %',(cNombre)),
		PATINDEX('%-%',(cNombre))
		))
			),'-',' ')
from NombresContribuyentes
----------------------------------------------------------------------------------------------------


--finalmente Tarea resuelto :D

select  left(cNombre,PATINDEX('% %',cNombre)) [apellido paterno],
		replace(SUBSTRING( substring(cNombre,PATINDEX('% %',cnombre),PATINDEX('%-%',cnombre)),1,PATINDEX('%-%', substring(cNombre,PATINDEX('% %',cnombre),PATINDEX('%-%',cnombre)))),'-',' ') [apellido materno],
		replace(right(trim(cnombre), PATINDEX('%-%',REVERSE(trim(cnombre))) ) ,'-',' ' ) [nombres]
from tContribuyente










		
