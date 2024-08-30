--18-12-2023
--Group by 
----consulta que nos permita agruparlos en una sola fila 
select * --- >nos saldra error : porque solo estoy agrupando por una sola columna 
from tDeudas
group by cCod_cont--las columnas que utilice en aqui deben estar en el select 
order by cCod_cont

select cCod_cont --- >nos saldra la consulta
from tDeudas
group by cCod_cont--las columnas que utilice en aqui deben estar en el select 
order by cCod_cont

--otra columna
select cCod_cont,cAño --- >nos saldra la consulta
from tDeudas
group by cCod_cont,cAño--las columnas que utilice en aqui deben estar en el select 
order by cCod_cont,cAño

--otra columna
select cCod_cont,cAño,cCod_Trib --- >nos saldra la consulta
from tDeudas
group by cCod_cont,cAño,cCod_Trib--las columnas que utilice en aqui deben estar en el select 
order by cCod_cont,cAño,cCod_Trib

--group by: se utiliza mayormente con funciones de agregado 

------------------------------	funciones de agregado -----------------------------
--sum:suma
--avg:promedio
--max:maximo
--min:minimo
--count:contar

--total de deudas por contribuyente 
select cCod_cont,sum(nTributo+nReajuste+nInteres+nGasto) as Deuda
from tDeudas
group by cCod_cont
order by cCod_cont

--promedio, maximo ,minimo y cantidad de registros de deudas por contribuyente 
select cCod_cont,
	avg(nTributo+nReajuste+nInteres+nGasto) as Promedio,
	max(nTributo+nReajuste+nInteres+nGasto) as Maximo,
	min(nTributo+nReajuste+nInteres+nGasto) as Minimo,
	COUNT(*) as [Cantidad de deudas por contribuyente]
from tDeudas
group by cCod_cont
order by cCod_cont
--count puedes especificar o ponerle count(*) o count(cCod_cont), es indiferente 

--EJERCICIO:Listar el total de deudas por contribuyente y año

select cCod_cont,cAño as [año],sum(nTributo+nReajuste+nInteres+nGasto) as Deuda
from tDeudas
group by cCod_cont,cAño
order by cCod_cont

--HAVING

--Listar el total de deudas por contribuyente cuyo total de deudas esta entre 500 y 1500, de deudas agrupadas
select cCod_cont,cAño as [año],sum(nTributo+nReajuste+nInteres+nGasto) as Deuda
from tDeudas
group by cCod_cont,cAño
having sum(nTributo+nReajuste+nInteres+nGasto) between 500 and 1500 --
order by cCod_cont

--where :por filas sin agrupar
--having :para listar agrupados, tambien en el having siempre se ponen funciones de agregado, sum min max etc.
--en el having no se ponen columnas no es recomendable, sino funciones agrupadas.

--ejm prof:----Listar el total de deudas por contribuyente cuyo total de deudas esta entre 500 y 1500 de los años 2004,2005,2006,2008,2010
select distinct cAño
from tDeudas
order by cAño

--corrige para que se paresca  a la anterior y tenga los mismos resultados SOLUCION
select cCod_cont,sum(nTributo+nReajuste+nInteres+nGasto) as Deuda
from tDeudas
where cAño IN ('2004','2005','2006','2008','2010')
group by cCod_cont
having sum(nTributo+nReajuste+nInteres+nGasto) between 500 and 1500 
order by cCod_cont



select cCod_cont,sum(nTributo+nReajuste+nInteres+nGasto) as Deuda
from tDeudas
--where cAño IN ('2004','2005','2006','2008','2010')
group by cCod_cont
having sum(nTributo+nReajuste+nInteres+nGasto) between 500 and 1500 
order by cCod_cont
--¿porque salen mas resultados?
--La razon es por el between restringe de 500 y 1500


select sum(nTributo+nReajuste+nInteres+nGasto) as Deuda
from tDeudas
where cCod_cont = '0000132'--se paso, de 500 y 1500 por eso no salia 
and cAño IN ('2004','2005','2006','2008','2010')

--probamos con el año en el having 
--aqui sale error por el hecho de que el having se pone funciones de agrupado mas no columnas 

select cCod_cont,sum(nTributo+nReajuste+nInteres+nGasto) as Deuda
from tDeudas
--where cAño IN ('2004','2005','2006','2008','2010')
group by cCod_cont
having --cAño IN ('2004','2005','2006','2008','2010')and 
sum(nTributo+nReajuste+nInteres+nGasto) between 500 and 1500 
order by cCod_cont

--EJERCICIO:
--Listar los contribuyentes cuyo promedio de deuydas totales 
--es mayor de 100 y que tengan entre 5 y 20 registros 
select cCod_cont as [codigo contribuyente],avg(nTributo+nReajuste+nInteres+nGasto) as [Promedio de deuda]
from tDeudas
group by cCod_cont
having avg(nTributo+nReajuste+nInteres+nGasto) >100 and count(*) between 5 and 20
order by cCod_cont

--Listar los nombre de contribuyentes 
--que deben mas de 1000 soles
select cNombre as nombres
from tContribuyente 
where cCod_Cont in (
	select cCod_cont 
	from tDeudas
	group by cCod_cont
	having sum(nTributo+nReajuste+nInteres+nGasto) >1000 --funcion agrupada 
	--where nTributo+nReajuste+nInteres+nGasto >1000
)
order by cNombre