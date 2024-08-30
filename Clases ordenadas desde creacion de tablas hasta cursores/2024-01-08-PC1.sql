--08/01/2024

--DESARROLLO DE LA PC1


--1. Usando la tabla timpuesto se quieren listar los códigos y nombre de contribuyentes que en el año 2009
--tienen deudas en ese mismo año, pero no tienen deudas en el 2008. Para deudas use la tabla tDeudas
SELECT i.cCod_Cont,c.cNombre
FROM tImpuesto i
join tContribuyente c on i.cCod_Cont= c.cCod_Cont
where i.cAño='2009' 
and c.cCod_cont in (
		select distinct  cCod_cont
		from tDeudas 
		where cAño ='2009'
) and c.cCod_cont not in (
		select distinct  cCod_cont
		from tDeudas 
		where cAño ='2008'
)

--2. Listar los códigos de lugares de la tabla tContribuyentes que no están en la tabla tLugares
--y los códigos de lugares de tLugares que no están en tContribuyentes. El resultado se debe mostrar en un solo listado.

select  c.cCod_Lug
from tContribuyente c
left join tLugares l on c.cCod_Lug= l.cCod_Lug
where l.cCod_Lug is null

union 

select  l.cCod_Lug
from tContribuyente c
right join tLugares l on c.cCod_Lug= l.cCod_Lug
where c.cCod_Lug is null

--3. Crear una tabla timpuestoValuo, que contenga las siguientes columnas: 
--cCod_Cont, cNombre, Impuesto, valuo. Luego llenar esta tabla con todos los datos de códigos y nombres de tContribuyente, 
--Impuesto con nimp_Pred (timpuesto), valuo con la suma de nval_Tot (tValuo), estos dos últimos valores que correspondan 
--al año 2009. En los casos en donde no haya Impuesto o valúo deberá colocar cero.

---copiar de script 

create table #tImpuestoValuo(--aqui la crea fisicamente 
	cCod_cont char(11),
	cNombre varchar(100),
	impuesto numeric(15,2), 
	valuo numeric(15,2)
)

select *
from #tImpuestoValuo

insert into #tImpuestoValuo(cCod_Cont,cNombre)
select cCod_Cont,cNombre
from tContribuyente


select *
from tImpuesto
where cAño='2009'


update #tImpuestoValuo 
set impuesto = i.nImp_Pred
from tImpuesto i
where i.cAño='2009' and #tImpuestoValuo.cCod_cont =i.cCod_Cont


select cCod_Cont,sum(nVal_Tot)
into #valtot
from tValuos
where cAño='2009'
group by cCod_Cont




update #tImpuestoValuo 
set impuesto = valuoTot
from #valtot 
where cAño='2009' and #tImpuestoValuo.cCod_cont =tImpuesto.cCod_Cont

--4. Usando la tabla tValuos listar el código, nombre y total de valúo de los contribuyentes que en el año 2009
--tienen deudas en ese mismo año, pero que no tengan ni Intereses ni gastos. Además, sólo debe listar aquellos 
--contribuyentes que tienen más de un predio. (mas de un predio es decir mas de un registro)

--1163 result ,copiar profe 

select v.cCod_Cont,c.cNombre,sum(v.nVal_Tot)
from tValuos v 
join tContribuyente c on v.cCod_Cont=c.cCod_Cont
where v.cAño= '2009'
and v.cCod_Cont not in (
	select cCod_cont
	from tDeudas
	where cAño='2009'
	group by cCod_cont
	having sum(nTributo+nReajuste)= 0 
)
group by v.cCod_Cont,c.cNombre


--5. Crear una tabla tmpDeudas que contenga el código, nombre y total de deuda de los contribuyentes en el año 2009.
create table tmpDeudas(
	cCod_Cont char(11),
	cNombre varchar(100),
	total numeric(15,2)
)

select c.cCod_Cont,c.cNombre,sum(d.nGasto+d.nInteres+d.nReajuste+d.nTributo)  
from tDeudas d
join tContribuyente c on d.cCod_cont=c.cCod_Cont
where year(d.cAño)=2009
group by c.cCod_Cont


---
insert into tmpDeudas(cCod_Cont,cNombre,total)
select c.cCod_Cont,c.cNombre,sum(d.nGasto+d.nInteres+d.nReajuste+d.nTributo)  
from tDeudas d
join tContribuyente c on d.cCod_cont=c.cCod_Cont
where year(d.cAño)=2009
group by c.cCod_Cont,c.cNombre
--

--Luego agregar un campo Tipo, 
alter table tmpDeudas add
tipo char(20)

---Ese campo tipo actualizarlo de la sigulente manera: 
--Usando la tabla timpuesto, si la suma de nimp_Pred+nLimp_Publ+nPar_Jard+nRell_Sani+nSerenazgo 
--en el año 2009 para ese contribuyente es mayor a 2000
--deberá poner PRINICIPAL, si está entre 500 y 2000 poner MEDIANO en caso contrario poner PEQUEÑO.

select *
from tmpDeudas
--sum > 2000 principal
--sum between 500 y 2000 mediano
--sum<500 pequeño

UPDATE tmpDeudas
SET tipo = 'PRINCIPAL'
WHERE cCod_Cont IN (
  SELECT i.cCod_Cont
  FROM tImpuesto i
  WHERE year(i.cAño) = '2009'
  GROUP BY i.cCod_Cont
  HAVING SUM(i.nImp_Pred + i.nLimp_Publ + i.nPar_Jard + i.nRell_Sani + i.nSerenazgo) > 2000
)

UPDATE tmpDeudas
SET tipo = 'MEDIANO'
WHERE cCod_Cont IN (
  SELECT i.cCod_Cont
  FROM tImpuesto i
  WHERE year(i.cAño) = '2009'
  GROUP BY i.cCod_Cont
  HAVING SUM(i.nImp_Pred + i.nLimp_Publ + i.nPar_Jard + i.nRell_Sani + i.nSerenazgo) between 500 and 2000
)

UPDATE tmpDeudas
SET tipo = 'PEQUEÑO'
WHERE cCod_Cont IN (
  SELECT i.cCod_Cont
  FROM tImpuesto i
  WHERE year(i.cAño) = '2009'
  GROUP BY i.cCod_Cont
  HAVING SUM(i.nImp_Pred + i.nLimp_Publ + i.nPar_Jard + i.nRell_Sani + i.nSerenazgo) <500
)
