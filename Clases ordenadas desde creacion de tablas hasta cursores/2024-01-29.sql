--------------solucion del examen parcial------------------

--1.	La tabla tValuos, contiene el valor por a�o de los predios de cada contribuyente, cada predio se identifica por el c�digo catastral (cCod_Catas) y el valor total del predio  est� dado por la columna nVal_Tot. Se requiere crear una vista 
--(vDeudasPredios) que liste por a�o los c�digos de contribuyentes , su nombre, el lugar donde viven,la cantidad de predios y el valor total de los mismos en ese   a�o, estos �ltimos de la tabla tValuos. Deber�  filtrar esta informaci�n para que s�lo aparezcan aquellos que tienen deudas y que no tengan su domicilio en        Asentamientos Humanos.

CREATE VIEW vDeudasPredios
	([A�O], [CODIGO], [CONTRIBUYENTE], [LUGAR], [CANTIDAD PREDIOS], [VALOR TOTAL]) AS
SELECT v.cA�o,c.cCod_Cont codigo,c.cNombre nombre,l.cNombre lugar,
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
GROUP BY v.cA�o,c.cCod_Cont,c.cNombre,l.cNombre


--2.	Crear la tabla tDeudaA�o, que contenga las siguientes columnas: cCod_Cont char(11),cNombre      varchar(100),nDeuda2008,nDeuda2009,nDeuda2010, estas tres de tipo decimal(9,2). Luego     deber� actualizar esta tabla para colocar los datos correspondientes usando la tabla      tDeudas y tContribuyente, en las columnas nDeuda2008, nDeuda2009, nDeuda2010, deber�      colocar las deudas totales correspondientes a esos a�os. No debe usar PIVOT, sino         utilizar tablas temporales en las cuales vaya colocando las deudas de cada a�o y luego    actualizar en la tabla creada. Adem�s debe actualizar la tabla de forma tal que no quede  ninguna fila en la que hayan columnas con valores NULL.

CREATE TABLE tDeudaA�o(
	cCod_Cont char(11), cNombre varchar(100), nDeudas2008 decimal(9, 2) DEFAULT 0,
	nDeudas2009 decimal(9, 2) DEFAULT 0, nDeudas2010 decimal(9, 2) DEFAULT 0)

SELECT d.cCod_Cont,
       sum(d.nTributo+d.nReajuste+d.nInteres+d.nGasto) total 
INTO #2008
FROM tDeudas d
WHERE year(d.cA�o)=2008
GROUP BY d.cCod_Cont

SELECT d.cCod_Cont,
       sum(d.nTributo+d.nReajuste+d.nInteres+d.nGasto) total INTO #2009
FROM tDeudas d
WHERE year(d.cA�o)=2009
GROUP BY d.cCod_Cont

SELECT d.cCod_Cont,
       sum(d.nTributo+d.nReajuste+d.nInteres+d.nGasto) total INTO #2010
FROM tDeudas d
WHERE year(d.cA�o)=2010
GROUP BY d.cCod_Cont

INSERT INTO tDeudaA�o(cCod_Cont)
SELECT cCod_Cont
FROM #2008
UNION
SELECT cCod_Cont
FROM #2009
UNION
SELECT cCod_Cont
FROM #2010

UPDATE tDeudaA�o
SET cNombre =c.cNombre
FROM tDeudaA�o d
JOIN tContribuyente c ON c.cCod_Cont=d.cCod_Cont

UPDATE tDeudaA�o
SET nDeudas2008 =a.total
FROM tDeudaA�o d
JOIN #2008 a ON d.cCod_Cont=a.cCod_Cont

UPDATE tDeudaA�o
SET nDeudas2009 =a.total
FROM tDeudaA�o d
JOIN #2009 a ON d.cCod_Cont=a.cCod_Cont
UPDATE tDeudaA�o
SET nDeudas2010 =a.total
FROM tDeudaA�o d
JOIN #2010 a ON d.cCod_Cont=a.cCod_Cont
 


--3.	En la siguiente sentencia : Select t1.codpersona from tabla1 t1 left join tabla2 t2 on t1.codpersona=t2.codpersona.
--Dar�a el mismo resultado si en lugar de poner Select t1.codpersona ponemos Select t2.codPersona ? Explique 

--Depende primero de la integridad referencial,ya que el LEFT JOIN puede darnos nulos en caso de que no encuentre referencia con ciertos registros en la tabla donde se le      referencia,en caso de que un registro no este referenciado en por otro entonces este   dara nulo,y asi en viceversa ademas en las consultas con t1.codpersona y t2.codPersona puede ser diferente,ya que cada una de ellas muestra datos de una tabla diferente en el contexto de la consulta LEFT JOIN.


--4.	Se requiere implementar la posibilidad de que algunos contribuyentes puedan      efectuar alg�n reclamo sobre las deudas que tienen pendientes. Estos reclamos son     presentados por tipo de tributo (3 primero caracteres de cCod_Trib) y por a�o.   Para ello se le solicita a usted crear una tabla (tReclamos), que permita        insertar los  registros de reclamos. Crear el procedimiento almacenado           paInsertaReclamos, que permita efectuar la inserci�n de registros, validando     adem�s que la deuda que se est� reclamando exista en tDeudas, si no existe       simplemente no hace la inserci�n. A este procedimiento se le pasar� como         par�metro de entrada el c�digo del contribuyente, el a�o, el c�digo de tributo y el motivo de reclamo.
CREATE TABLE tReclamos(cCod_Cont char(11), a�o char(4), cCod_Trib char(3), motivo text)
SELECT *
FROM tReclamos

CREATE PROCEDURE paInsertaReclamos 
(@cCod_Cont char(11), @a�o char(4), @cCod_Trib char(3), @motivo text)
AS 
BEGIN 
IF EXISTS(SELECT * FROM tDeudas
   	WHERE year(cA�o)=@a�o AND cCod_Cont=@cCod_Cont
   	AND left(trim(cCod_Trib),3)=@cCod_Trib) 
BEGIN
INSERT INTO tReclamos
VALUES(@cCod_Cont,@a�o,@cCod_Trib,@motivo) 
PRINT 'INSERCI�N EXITOSA' 
END 
ELSE 
BEGIN 
PRINT 'FALLO LA INSERCI�N' 
END
END


---pruebas 
exec paInsertaReclamos '0002107','2008','007','no puedieron recibir mi tarjeta :v '

	select * 
	from tDeudas 
	where year(cA�o)=2008 and cCod_Cont='0002107' and left(trim(cCod_Trib),3)='007'

	select top 50 d.cCod_Trib,d.cCod_Cont,d.cA�o
	from tDeudas d 
	