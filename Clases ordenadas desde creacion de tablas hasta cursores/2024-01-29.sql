--------------solucion del examen parcial------------------

--1.	La tabla tValuos, contiene el valor por año de los predios de cada contribuyente, cada predio se identifica por el código catastral (cCod_Catas) y el valor total del predio  está dado por la columna nVal_Tot. Se requiere crear una vista 
--(vDeudasPredios) que liste por año los códigos de contribuyentes , su nombre, el lugar donde viven,la cantidad de predios y el valor total de los mismos en ese   año, estos últimos de la tabla tValuos. Deberá  filtrar esta información para que sólo aparezcan aquellos que tienen deudas y que no tengan su domicilio en        Asentamientos Humanos.

CREATE VIEW vDeudasPredios
	([AÑO], [CODIGO], [CONTRIBUYENTE], [LUGAR], [CANTIDAD PREDIOS], [VALOR TOTAL]) AS
SELECT v.cAño,c.cCod_Cont codigo,c.cNombre nombre,l.cNombre lugar,
       count(*) predios,
       sum(v.nVal_Tot) total
FROM tValuos v
JOIN tContribuyente c ON c.cCod_Cont=v.cCod_Cont
JOIN tLugares l ON l.cCod_Lug = c.cCod_Lug
WHERE c.cCod_Cont in
    (SELECT cCod_Cont
     FROM tDeudas
     WHERE (nTributo+nReajuste+nInteres+nGasto)>0)
  AND l.cNombre not like 'A.H%'
GROUP BY v.cAño,c.cCod_Cont,c.cNombre,l.cNombre


--2.	Crear la tabla tDeudaAño, que contenga las siguientes columnas: cCod_Cont char(11),cNombre      varchar(100),nDeuda2008,nDeuda2009,nDeuda2010, estas tres de tipo decimal(9,2). Luego     deberá actualizar esta tabla para colocar los datos correspondientes usando la tabla      tDeudas y tContribuyente, en las columnas nDeuda2008, nDeuda2009, nDeuda2010, deberá      colocar las deudas totales correspondientes a esos años. No debe usar PIVOT, sino         utilizar tablas temporales en las cuales vaya colocando las deudas de cada año y luego    actualizar en la tabla creada. Además debe actualizar la tabla de forma tal que no quede  ninguna fila en la que hayan columnas con valores NULL.

CREATE TABLE tDeudaAño(
	cCod_Cont char(11), cNombre varchar(100), nDeudas2008 decimal(9, 2) DEFAULT 0,
	nDeudas2009 decimal(9, 2) DEFAULT 0, nDeudas2010 decimal(9, 2) DEFAULT 0)

SELECT d.cCod_Cont,
       sum(d.nTributo+d.nReajuste+d.nInteres+d.nGasto) total 
INTO #2008
FROM tDeudas d
WHERE year(d.cAño)=2008
GROUP BY d.cCod_Cont

SELECT d.cCod_Cont,
       sum(d.nTributo+d.nReajuste+d.nInteres+d.nGasto) total INTO #2009
FROM tDeudas d
WHERE year(d.cAño)=2009
GROUP BY d.cCod_Cont

SELECT d.cCod_Cont,
       sum(d.nTributo+d.nReajuste+d.nInteres+d.nGasto) total INTO #2010
FROM tDeudas d
WHERE year(d.cAño)=2010
GROUP BY d.cCod_Cont

INSERT INTO tDeudaAño(cCod_Cont)
SELECT cCod_Cont
FROM #2008
UNION
SELECT cCod_Cont
FROM #2009
UNION
SELECT cCod_Cont
FROM #2010

UPDATE tDeudaAño
SET cNombre =c.cNombre
FROM tDeudaAño d
JOIN tContribuyente c ON c.cCod_Cont=d.cCod_Cont

UPDATE tDeudaAño
SET nDeudas2008 =a.total
FROM tDeudaAño d
JOIN #2008 a ON d.cCod_Cont=a.cCod_Cont

UPDATE tDeudaAño
SET nDeudas2009 =a.total
FROM tDeudaAño d
JOIN #2009 a ON d.cCod_Cont=a.cCod_Cont
UPDATE tDeudaAño
SET nDeudas2010 =a.total
FROM tDeudaAño d
JOIN #2010 a ON d.cCod_Cont=a.cCod_Cont
 


--3.	En la siguiente sentencia : Select t1.codpersona from tabla1 t1 left join tabla2 t2 on t1.codpersona=t2.codpersona.
--Daría el mismo resultado si en lugar de poner Select t1.codpersona ponemos Select t2.codPersona ? Explique 

--Depende primero de la integridad referencial,ya que el LEFT JOIN puede darnos nulos en caso de que no encuentre referencia con ciertos registros en la tabla donde se le      referencia,en caso de que un registro no este referenciado en por otro entonces este   dara nulo,y asi en viceversa ademas en las consultas con t1.codpersona y t2.codPersona puede ser diferente,ya que cada una de ellas muestra datos de una tabla diferente en el contexto de la consulta LEFT JOIN.


--4.	Se requiere implementar la posibilidad de que algunos contribuyentes puedan      efectuar algún reclamo sobre las deudas que tienen pendientes. Estos reclamos son     presentados por tipo de tributo (3 primero caracteres de cCod_Trib) y por año.   Para ello se le solicita a usted crear una tabla (tReclamos), que permita        insertar los  registros de reclamos. Crear el procedimiento almacenado           paInsertaReclamos, que permita efectuar la inserción de registros, validando     además que la deuda que se está reclamando exista en tDeudas, si no existe       simplemente no hace la inserción. A este procedimiento se le pasará como         parámetro de entrada el código del contribuyente, el año, el código de tributo y el motivo de reclamo.
CREATE TABLE tReclamos(cCod_Cont char(11), año char(4), cCod_Trib char(3), motivo text)
SELECT *
FROM tReclamos

CREATE PROCEDURE paInsertaReclamos 
(@cCod_Cont char(11), @año char(4), @cCod_Trib char(3), @motivo text)
AS 
BEGIN 
IF EXISTS(SELECT * FROM tDeudas
   	WHERE year(cAño)=@año AND cCod_Cont=@cCod_Cont
   	AND left(trim(cCod_Trib),3)=@cCod_Trib) 
BEGIN
INSERT INTO tReclamos
VALUES(@cCod_Cont,@año,@cCod_Trib,@motivo) 
PRINT 'INSERCIÓN EXITOSA' 
END 
ELSE 
BEGIN 
PRINT 'FALLO LA INSERCIÓN' 
END
END


---pruebas 
exec paInsertaReclamos '0002107','2008','007','no puedieron recibir mi tarjeta :v '

	select * 
	from tDeudas 
	where year(cAño)=2008 and cCod_Cont='0002107' and left(trim(cCod_Trib),3)='007'

	select top 50 d.cCod_Trib,d.cCod_Cont,d.cAño
	from tDeudas d 
	