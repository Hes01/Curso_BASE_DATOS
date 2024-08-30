select  cNombre
from tContribuyente


select trim(left(cNombre, PATINDEX('% %',cNombre))) [APPATERNO],
		trim(right(REPLACE(left(cNombre, PATINDEX('%-%',cNombre)),'-',''),
		PATINDEX('% %',reverse(REPLACE(left(cNombre, PATINDEX('%-%',cNombre)),'-','')))))	[APMATERNO],
		 trim(replace(right(trim(cnombre),patindex('%-%',reverse(trim(cnombre)) )),'-','')) [NOMBRES]
from tContribuyente
where PATINDEX('%-%',cNombre)<>0

select abs(-254)

select round(253.211,1)

select day(getdate()) dia, month(getdate()) mes, year(getdate()) año


select cast(getdate() as varchar) [fecha actual convertida]

select convert(date,getdate())

select convert(bit,'abcd')--lanza error porque no se puede convertir a bit


------------------------------------------------------------------------VISTAS------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------

create view vDeudas
as
	select c.cCod_Cont codigo,cNombre nombre,sum(d.nGasto+d.nInteres+d.nReajuste+d.nTributo) deuda
	from tDeudas d 
	join tContribuyente c on d.cCod_cont=c.cCod_Cont
	group by c.cCod_Cont,cNombre

create view vDeudax ([code],[name],[dtot])
as
	select c.cCod_Cont codigo,cNombre nombre,sum(d.nGasto+d.nInteres+d.nReajuste+d.nTributo) deuda
	from tDeudas d 
	join tContribuyente c on d.cCod_cont=c.cCod_Cont
	group by c.cCod_Cont,cNombre


select codigo,nombre,l.cNombre lugar,ca.cNombre calle,deuda
from vDeudas v 
join tContribuyente c on c.cCod_Cont=v.codigo
join tLugares l on c.cCod_Lug=c.cCod_Lug
join tCalles ca on ca.cCod_Calle= c.cCod_Calle

--falla aqui ver el .bd del profe y corregir
select top 10 d.codigo,d.nombre,di.Direccion,d.deuda
from vDeudas d
join vContrDireccion di on d.codigo= di.codigo

--crear una vista que muestre los siguientes datos
--codigo y nombre de contribuyente
--codigo catastral(cCod_Catas),Uso del predio
--para mostrar el uso del predio usar la columna cUso_Pred
--y la tabla tUsoPredios

----------------------------------------------------------------------------
CREATE VIEW vContrDireccionx
	--es como una tabla virtual pero no esta alojada en la bd					
	--como las que estan en la bd
as  
	select cCod_Cont codigo, c.cNombre nombre, 
	rtrim(l.cNombre) + ' - ' +rtrim(ca.cNombre) + 
	case when cNumero<> '' and cNumero<>0 then 'cNumero'+cNumero else '' end+  --para esto 
	case when cManzana<> '' and cManzana<>0 then 'Manzana: '+cManzana else '' end+ --para esto 
	case when cLote<> '' and cLote<>0 then ' Lote:' +cLote else '' end  
	--y para esto 
	--(case when cNumero<>'' and cnumero <> '0' then ' Numero: '+ cNumero else '' end
	--esto para cdnumero cmanzana y clote)
	Direccion
	from tContribuyente  c 
	inner join tLugares l on c.cCod_Lug=l.cCod_Lug
	inner join tCalles ca on c.cCod_Calle=ca.cCod_Calle


--------------------------COMO USAR EL CASE WHEN--------------------------
--Crear una vista que muestre el codigo, nombre y direccion de los contribuyentes
--eeste ultimo mostrara el nombre de lugares concatenado con un guion con el nombre de calles y concatenado lo siguiente
-- luego si el numero de contribuyente es distinto de vacio y ademas si es diferente de 0 
--mostrara 'cnumero' concatenado con el numero caso contrario no mostrara nada , luego concatenara esto,
--luego si cmanzana es distindo de vacio y manzana es distinto de cero mostrara la palabra manzana contenando cmanzana 
--caso contrario no mostrara nada, luego concatenara esto ,
--luego si clote es distinto de vacio y ademas es distinto de cero entonces mostrara 'lote' concatenado con clote caso 
--contrario no mostrara nada , para estos ultimos use la tabla tcontribuyentes 


create view vContrDireccion ([CODIGO CONTRIBUYENTE ],[NOMBRE CONTRIBUYENTE],[ DIRECCION CONTRIBUYENTE])
as	
	select c.cCod_Cont codigo, c.cNombre nombre,
	(concat_ws('-',trim(l.cNombre),trim(ca.cNombre)) +
	case when c.cNumero <>'' and c.cNumero <> '0' then concat('numero ',c.cNumero) else '' end +
	case when c.cManzana <> '' and c.cManzana <> '0' then concat('manzana ',c.cManzana) else '' end+
	case when c.cLote <> ''  and c.cLote<>'0' then concat('lote ',c.cLote) else '' end ) [direccion]
	from tContribuyente c 
	join tLugares l on l.cCod_Lug=c.cCod_Lug
	join tCalles ca on c.cCod_Calle=ca.cCod_Calle

	select *
	from vContrDireccion

drop view vContrDireccion

-----------------------------------------------------------------------------------------------------------

--Categorización de Contribuyentes:
--Crea una consulta que muestre el código y nombre de los contribuyentes, 
--y agrega una columna llamada 'Categoria' que indique si el contribuyente es 'Individual'
--si tiene 'cTip_Cont' igual a '01', o 'Empresa' si tiene 'cTip_Cont' igual a '11'.
create view CategorizarContribuyentes([CODIGO DE CONTRIBUYENTE ],[ NOMBRE DE CONTRIBUYENTE ],[ CATEGORIA DE CONTRIBUYENTE ])
as	
	select c.cCod_Cont, c.cNombre, 
	case when cTip_Cont ='01' then ' Individual '  
		 when cTip_Cont ='11' then ' Empresa ' else ' Desconocido ' end
	from tContribuyente c 

SELECT *
FROM CategorizarContribuyentes
WHERE [ CATEGORIA DE CONTRIBUYENTE ] = ' Empresa '


--Estado de Deudas:
--Crea una consulta que muestre el código del contribuyente y una columna llamada 'Estado_Deuda'
--que indique 'Al Dia' si la suma de las deudas (nTributo + nReajuste + nInteres + nGasto) 
--es igual a 0, 'Pendiente' si la suma es mayor que 0, y 'Exonerado' si no tiene deudas.

CREATE VIEW EstadoDeudas ([CODIGO DE CONTRIBUYENTE ],[ESTADO DE DEUDA DE CONTRIBUYENTE])
as 
	select c.cCod_Cont, 
	(case 
		when sum(d.nTributo + d.nReajuste + d.nInteres + d.nGasto)=0 then 'Al Dia'
		when sum(d.nTributo + d.nReajuste + d.nInteres + d.nGasto)>0 then 'Pendiente'
		else 'Exonerado' end) [ESTADO DE DEUDA]
	from tContribuyente c 
	join tDeudas d on d.cCod_cont=c.cCod_Cont
	group by c.cCod_Cont
	HAVING sum(d.nTributo + d.nReajuste + d.nInteres + d.nGasto)>0

SELECT *
FROM EstadoDeudas

--Clasificación de Calles:
--Crea una consulta que muestre el código y nombre de las calles, y una columna llamada 'CNOMBRE'
--que indique 'AVENIDA' si la calle tiene 'AV.%' igual a 'AVENIDA', 'CALLE'
--si tiene 'cMotivo' igual a 'CA.%', y 'DESCONOCIDO' si no tiene motivo.
CREATE VIEW ClasificacionCalles([CODIGO DE CALLE],[TIPO DE CALLE ])
as	
	select c.cCod_Calle, 
			case
				when cNombre like 'AV.%' then 'AVENIDA' 
				WHEN cNombre LIKE 'CA.%' THEN 'CALLE' ELSE 'DESCONOCIDO' END TIPO_CALLE
	from tCalles c
	
	select   *
	from ClasificacionCalles 

--Categorización de Tributos:
--Crea una consulta que muestre el código y nombre de los tributos, y agrega una columna llamada 
--'Categoria' que indique 'Impuesto' si 'cTipo_Trib' es igual a 'MP', 'Tasa' si es igual a 'TA',
--y 'Contribución' si es igual a 'TR'.
create view CategorizarTributos ([CODIGO DE TRIBUTO],[NOMBRE DE TRIBUTO],[CATEGORIA DE TRIBUTO])
as	
	select t.cCod_Trib, t.cNombre,
	case	
		when t.cTipo_Trib ='MP' THEN 'IMPUESTO'
		WHEN T.cTipo_Trib='TA' THEN 'TASA' ELSE
		'CONTRIBUCION' END CATEGORIA
	from tTributos t

SELECT *
FROM CategorizarTributos



--Cálculo de Impuestos:
--Crea una consulta que muestre el código del contribuyente y el año, y agrega una columna llamada 'Impuesto_Total'
--que calcule el total de impuestos sumando 'nImp_Pred', 'nLimp_Publ', 'nPar_Jard', 'nRell_Sani', y 'nSerenazgo'
--y clasifica como si es mayor a 5000 'Alto', si es igual 'Medio' o  si es menor 'Bajo' según el rango de la suma.
CREATE VIEW	CalculoImpuesto([CODIGO CONTRIBUYENTE ],[ AÑO IMPUESTO],[DEUDA TOTAL])
as 
	select c.cCod_Cont,i.cAño,
	case 
		when sum(i.nImp_Pred+i.nLimp_Publ+i.nPar_Jard+i.nRell_Sani+i.nSerenazgo) >5000 then 'Alto' 
		when sum(i.nImp_Pred+i.nLimp_Publ+i.nPar_Jard+i.nRell_Sani+i.nSerenazgo) =5000 then 'Medio' 
		else 'Bajo' end IMPUESTO_TOTAL
	from tContribuyente c 
	join tImpuesto i on i.cCod_Cont=c.cCod_Cont
	group by c.cCod_Cont,i.cAño
	
SELECT *
FROM CalculoImpuesto



-----------------------------------------------------------------------------------------------------

--Crear una vista que muestre los siguientes datos
--Codigo y nombre de contribuyente
--De la tabla tValuos en el año 2009
--Codigo Catastral (cCod_Catas), Uso del predio
--Para mostrar el uso del predio usar la columna cUso_Pred 
--y la tabla tUsoPredios
--Notas :
--cUso_Pred no esta en tUsoPredios sino en tValuos

create view Informacion_contribuyente([CODIGO CONTRIBUYENTE],[NOMBRE CONTRIBUYENTE],[CODIGO CATASTRAL],[USO PREDIOS])
as
	select c.cCod_Cont,cNombre nombre, --REPLACE(RIGHT(trim(c.cNombre),patindex('%-%',reverse(trim(c.cNombre)))),'-','') nombre,
	V.cCod_Catas , V.cUso_Pred
	from tContribuyente c 
	join tValuos v on v.cCod_Cont=c.cCod_Cont
	where year(v.cAño)=2009 
	
DROP VIEW Informacion_contribuyente
--
SELECT *
FROM Informacion_contribuyente

	select cNombre --cantidad: 247 675
	from tContribuyente
	where PATINDEX('%-%',cNombre) <> 0

                                       

	select cNombre --cantidad:22 183
	from tContribuyente
	where PATINDEX('%-%',cNombre) = 0
                                                          

	--total:269 858
---------------------------------------------------------------------------------------------------------


