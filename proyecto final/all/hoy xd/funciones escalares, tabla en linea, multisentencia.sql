select @@LANGUAGE lenguaje,@@SERVERNAME nombreServidor,@@VERSION versionn,SYSDATETIME() fechaActual

select year(getdate()) año,month(getdate()) mes,day(getdate()) dia 



select ascii('j') [valor ascii entero]

---funciones : no se puede modificar la bd pero si se pueden llamar para consultar,lo bueno esque se pueden llamar desde consultas 
--a diferencia de las vistas que son tablas virtuales , o los procedimientos almacenados el cual si permite modificaciones en la bd 
--FUNCIONES ESCALARES(1 VALOR:DEVOLUCION)

CREATE FUNCTION FN_CALCULADESCUENTO(@SUBTOTAL MONEY)
RETURNS MONEY
AS 
	BEGIN 
		RETURN @SUBTOTAL*0.12
	END 

SELECT DBO.FN_CALCULADESCUENTO(1500) DESCUENTO

SELECT D.NUM_FAC FACTURA,
	D.CAN_VEN*D.PRE_VEN SUBTOTAL, DBO.FN_CALCULADESCUENTO(D.CAN_VEN*D.PRE_VEN) DESCUENTO
FROM DETALLE_FACTURA  D


--FUNCION ESCALAR MUESTRA DISTRITO A PARTIR DEL CODIGO 
SELECT *
FROM DISTRITO
CREATE FUNCTION FN_DISTRITO_CODIGO(@CODIGO CHAR(3))--FUNCION ESCALAR 
RETURNS VARCHAR(100) 
AS 
	BEGIN 
	DECLARE @NOMBRE VARCHAR(100)
	SELECT @NOMBRE= NOM_DIS
	FROM DISTRITO
	WHERE COD_DIS=@CODIGO
	RETURN @NOMBRE
	END
	
	
SELECT C.RSO_CLI CLIENTE, DBO.FN_DISTRITO_CODIGO((COD_DIS)) DISTRITO
FROM CLIENTE C

SELECT DATENAME(DAY,GETDATE()) DIA ,DATENAME(MONTH,GETDATE()) MES,DATENAME(YEAR,GETDATE()) AÑO

CREATE FUNCTION FN_DEFECTO()
RETURNS DATE 
AS 
	BEGIN 
	DECLARE @FECHA DATE
	SELECT @FECHA=CAST(GETDATE() AS DATE)
	RETURN @FECHA
	END

SELECT DBO.FN_DEFECTO() FECHA--FUNCION ESCALAR SI PARAMETROS 

--FUNCIONES DE TABLA EN LINEA : DEVUELVEN UN CONJUNTO DE REGISTROS(TABLE)

--FUNCION QUE PERMITE LISTAR LOS PRODUCTOS 

CREATE FUNCTION FN_LISTAR_PRODUCTOS()
RETURNS TABLE 
AS 
	RETURN (
		SELECT *
		FROM PRODUCTO
	)--SIN PARAMETROS 

SELECT *
FROM DBO.FN_LISTAR_PRODUCTOS()

CREATE FUNCTION FN_LISTAR_PRODUCTOS_PARAMETRO(@IMP_PRO CHAR(1))
RETURNS TABLE 
AS 
	RETURN (
		SELECT COD_PRO,DES_PRO,PRE_PRO,SAC_PRO,SMI_PRO,UNI_PRO,LIN_PRO,IMP_PRO
		FROM PRODUCTO
		WHERE IMP_PRO=@IMP_PRO
	)--CON PARAMETROS 

SELECT * FROM DBO.FN_LISTAR_PRODUCTOS_PARAMETRO('V') --TRAE LOS DATOS TIENEN COMO V EN IMP_PRO: FUNCION TABLA EN LINEA 


--FUNCION TABLA EN LINEA 
CREATE FUNCTION FN_LISTADO_CLIENTE_POR_DISTRITO(@DISTRITO VARCHAR(50))
RETURNS TABLE 
AS 
	RETURN(
		SELECT C.*
		FROM CLIENTE C
		JOIN DISTRITO D ON D.COD_DIS=C.COD_DIS 
		WHERE D.NOM_DIS=@DISTRITO
		)

SELECT * FROM FN_LISTADO_CLIENTE_POR_DISTRITO('SURCO')
--FUNCIONES MULTISENTENCIA 

--crear la funcion multisentencia que retorne los codigo y nombre de distrito 
create function fn_datos_cliente_por_tip_cli(@TIP_CLI INT)
returns @tabla table(COD CHAR(5), NOM VARCHAR(40))
AS 
	BEGIN 
		INSERT INTO @tabla
		select c.COD_CLI,c.RSO_CLI
		from CLIENTE c  
		where c.TIP_CLI =@TIP_CLI
	return
	END


select *
from fn_datos_cliente_por_tip_cli(1) 


--funcion multisentencia 
--que permite mostrar dos columna de la tabla, DISTRITO, CLIENTE , VENDEDOR desde una sola funcion


create function fn_columnas_segun_tabla(@tabla varchar(30))
returns @matriz table(cod char(10),nombre varchar(50))
as 
	begin 
	if @tabla ='CLIENTE' 
		BEGIN 
			INSERT INTO @matriz 
			select c.COD_CLI,c.RSO_CLI
			from CLIENTE c 
		END 
	else if @tabla ='DISTRITO'
		begin 
			INSERT INTO @matriz 
			SELECT D.COD_DIS, D.NOM_DIS 
			FROM DISTRITO D 
		end 
	ELSE IF @tabla ='VENDEDOR'
		BEGIN 
			INSERT INTO @matriz
			SELECT V.COD_DIS CODIGO , CONCAT_WS(' ',V.NOM_VEN,V.APE_VEN) NOMBRE
			FROM VENDEDOR V
		END
	RETURN 

	end

SELECT *
FROM DBO.fn_columnas_segun_tabla('CLIENTE')

SELECT *
FROM DBO.fn_columnas_segun_tabla('DISTRITO')

SELECT *
FROM DBO.fn_columnas_segun_tabla('VENDEDOR')

--MULTISENTENCIA SIN PARAMETROS 
create function fn_datos_cliente_X()
returns @tabla table(COD CHAR(5), NOM VARCHAR(40),DIR VARCHar(100))
AS 
	BEGIN 
		INSERT INTO @tabla
		select c.COD_CLI,c.RSO_CLI,C.DIR_CLI
		from CLIENTE c  
	return
	END

select *
from fn_datos_cliente_X()