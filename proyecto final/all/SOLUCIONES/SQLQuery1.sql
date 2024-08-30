--1. 
	--Usando la tabla tImpuesto se requieren listar los códigos y nombre de contribuyentes 
	--que en el año 2009 tienen deudas en ese mismo año, pero no tienen deudas en el año 
	--2008. Para deudas use la tabla tDeudas.

select i.cCod_Cont [codigo],c.cNombre [nombre]
from timpuesto i 
join tContribuyente c on i.cCod_Cont=c.cCod_Cont
where year(i.cAño)=2009 
	and i.cCod_Cont in(select distinct cCod_cont
						from tDeudas 
						where year(cAño)=2009)
	and	i.cCod_Cont not in(select distinct cCod_cont
							from tDeudas 
							where year(cAño)=2008)
--Listar los codigos de lugares de la tabla tContribuyente que no están en la tabla tLugares y los códigos 
--de lugares de tLugares que no están en tContribuyente. El resultado se debe mostrar en un solo listado.

--tContribuyente	--tLugares
--codlug				null
--null					codlug

select c.cCod_Lug
from tContribuyente c 
left join tLugares l on c.cCod_Lug=l.cCod_Lug
where  l.cCod_Lug is null
union 
select l.cCod_Lug 
from tContribuyente c 
right join tLugares l on c.cCod_Lug =l.cCod_Lug
where c.cCod_Lug is null

--3.	Crear una tabla tImpuestoValuo, que contenga las siguientes columnas:
--cCod_Cont, cNombre, impuesto, valuo. Luego llenar esta tabla con todos 
--datos de códigos y nombres de tContribuyente, 
--impuesto con nImp_Pred  (tImpuesto),  valuo con la suma de nVal_Tot (tValuo), 
--estos dos últimos valores que correspondan al año 2009. 
--En los casos en donde no haya impuesto o valúo deberá colocar cero.

create table tImpuestoValuo(
	cCod_Cont char(11),
	cNombre varchar(100),
	impuesto decimal(15,2) default 0,
	valuo decimal(15,2) default 0
)

insert into timpuestoValuo(cCod_Cont,cNombre)--(269858 filas afectadas)
select cCod_Cont,cNombre
from tContribuyente 

select cCod_Cont,nImp_Pred--(57583 filas afectadas)
into #impuesto
from timpuesto
where year(cAño)=2009

select cCod_Cont,sum(nVal_Tot) total--(57586 filas afectadas)
into #valuo
from tValuos
where year(cAño)=2009
group by cCod_Cont

update i--(57581 filas afectadas)
set impuesto = nImp_Pred
from #impuesto v
join timpuestoValuo i on i.cCod_Cont=v.cCod_Cont

update i 
set valuo=total
from #valuo  v
join timpuestoValuo i on i.cCod_Cont=v.cCod_Cont--(57586 filas afectadas)


select *
from timpuestoValuo
where cCod_Cont ='70102876403'



--4.	Usando la tabla tValuos listar el código, nombre y total de valúo 
--de los contribuyentes que en el año 2009 tienen deudas en ese mismo año, 
--pero que no tengan ni intereses ni gastos. Además, sólo debe listar 
--aquellos contribuyentes que tienen más de un predio.


select v.cCod_Cont,c.cNombre,sum(v.nVal_Tot) total
from tValuos v 
join tContribuyente c on v.cCod_Cont=c.cCod_Cont 
where year(v.cAño)= 2009 and v.cCod_Cont in 
(
select cCod_cont 
from tDeudas 
where year(cAño)=2009
group by cCod_cont
having sum(nTributo+nReajuste+nInteres+nGasto)>0
)
and v.cCod_Cont not in 
(
select cCod_cont
from tDeudas
where year(cAño)=2009
group by cCod_cont
having sum(nInteres+nGasto)=0
)
group by v.cCod_Cont,c.cNombre
having count(*)>1
order by total desc

 5.	Crear una tabla tmpDeudas que contenga el código, nombre y total de deuda de los contribuyentes en el año 2009. 
Luego agregar un campo Tipo. Ese campo tipo actualizarlo de la siguiente manera: Usando la tabla tImpuesto, 
si la suma de nImp_Pred+nLimp_Publ+nPar_Jard+nRell_Sani+nSerenazgo en el año 2009 para ese contribuyente
es mayor a 2000 deberá poner PRINICIPAL, si está entre 500 y 2000 poner MEDIANO en caso contrario poner PEQUEÑO.

create table tmpDeudas(
	codigo char(11),
	nombre varchar(100),
	totalDeuda decimal(15,2) default 0
)
insert into tmpDeudas(codigo,nombre,totalDeuda)
select c.cCod_Cont,c.cNombre,sum(d.nGasto+d.nInteres+d.nReajuste+d.nTributo) [Total Deuda]
from tContribuyente c 
join tDeudas d on c.cCod_Cont = d.cCod_cont
group by c.cCod_Cont,c.cNombre

alter table tmpDeudas add 
tipo varchar(20)

update tmpDeudas 
set tipo = 'PRINCIPAL'
where codigo in (
select i.cCod_Cont
from timpuesto i
where year(i.cAño)=2009 
group by i.cCod_Cont 
having sum(i.nImp_Pred+i.nLimp_Publ+i.nPar_Jard+i.nRell_Sani+i.nSerenazgo)>2000
)

update tmpDeudas 
set tipo = 'MEDIANO'
where codigo in (
select i.cCod_Cont
from timpuesto i
where year(i.cAño)=2009 
group by i.cCod_Cont 
having sum(i.nImp_Pred+i.nLimp_Publ+i.nPar_Jard+i.nRell_Sani+i.nSerenazgo) BETWEEN 500 AND 2000
)


update tmpDeudas 
set tipo = 'PEQUEÑO'
where tipo is null

SELECT *
FROM tmpDeudas
where tipo ='PEQUEÑO'


--------------------FORMA MAS ELEGANTE METSI

UPDATE tmpDeudas 
SET tipo=
	case when impuestos.total >2000 then 'PRINCIPAL'
	WHEN impuestos.total BETWEEN 500 AND 2000 then 'MEDIANO'
	ELSE 'PEQUEÑO' END
FROM tmpDeudas d
join (
	select i.cCod_Cont,sum(nImp_Pred+nLimp_Publ+nPar_Jard+nRell_Sani+nSerenazgo) total
	from timpuesto i
	WHERE YEAR(cAño)=2009
	group by i.cCod_Cont
	having sum(nImp_Pred+nLimp_Publ+nPar_Jard+nRell_Sani+nSerenazgo)>0
) as impuestos on d.codigo=impuestos.cCod_Cont

UPDATE tmpDeudas 
set tipo = 'PEQUEÑO'
WHERE tipo is null


------EXAMEN PARCIAL

1-La tabla tValuos, contiene el valor por año de los predios de cada contribuyente, cada predio se identifica por
el código catastral (cCod_Catas) y el valor total del predio está dado por la columna nVal_Tot. Se requiere
crear una vista (vDeudasPredios) que liste por año los códigos de contribuyentes , su nombre, el lugar donde viven,
la cantidad de predios y el valor total de los mismos en ese año, estos últimos de la tabla tValuos. Deberá 
filtrar esta información para que sólo aparezcan aquellos que tienen deudas y que no tengan su domicilio en
Asentamientos Humanos.

create view vDeudasPredios([AÑO],[CODIGO],[CONTRIBUYENTE],[LUGAR],[CANTIDAD PREDIOS],[VALOR TOTAL])
as
select v.cAño,c.cCod_Cont codigo,c.cNombre nombre,l.cNombre lugar,count(*) predios ,sum(v.nVal_Tot) valuos
	from tValuos v
	join tContribuyente c on c.cCod_Cont=v.cCod_Cont
	join tLugares l on l.cCod_Lug = c.cCod_Lug
	where c.cCod_Cont in (select cCod_Cont--distinct
						  from tDeudas 
						  where (nTributo+nReajuste+nInteres+nGasto)>0)
		and  l.cNombre not like 'A.H%'
	group by v.cAño,c.cCod_Cont,c.cNombre,l.cNombre



	2. Crear la tabla tDeudaAño, que contenga las siguientes columnas: 
	cCod_Cont char(11),cNombre varchar(100),nDeuda2008,nDeuda2009,nDeuda2010, estas
	tres de tipo decimal(9,2). 
	Luego deberá actualizar esta tabla 
	para colocar los datos correspondientes usando la tabla tDeudas y tContribuyente, en las columnas 
	nDeuda2008, nDeuda2009, nDeuda2010, deberá colocar las deudas totales correspondientes a esos 
	años. No debe usar PIVOT, sino utilizar tablas temporales en las cuales vaya colocando las deudas 
	de cada año y luego actualizar en la tabla creada. Además debe actualizar la tabla de forma tal que no 
	quede ninguna fila en la que hayan columnas con valores NULL.

	create table tDeudaAño(
		cCod_Cont char(11), 
		cNombre varchar(100),
		nDeudas2008 decimal(9,2) default 0,
		nDeudas2009 decimal(9,2) default 0,
		nDeudas2010 decimal(9,2) default 0
	)
	
	select d.cCod_Cont, sum(d.nTributo+d.nReajuste+d.nInteres+d.nGasto) total
	into #2008
	from tDeudas d
	where year(d.cAño)=2008
	group by d.cCod_Cont
	
	select d.cCod_Cont, sum(d.nTributo+d.nReajuste+d.nInteres+d.nGasto) total
	into #2009
	from tDeudas d
	where year(d.cAño)=2009
	group by d.cCod_Cont
	
	select d.cCod_Cont, sum(d.nTributo+d.nReajuste+d.nInteres+d.nGasto) total
	into #2010
	from tDeudas d
	where year(d.cAño)=2010
	group by d.cCod_Cont


	insert into tDeudaAño(cCod_Cont)
	select cCod_Cont
	from #2008
	union 
	select cCod_Cont
	from #2009
	union
	select cCod_Cont
	from #2010


	update tDeudaAño
	set cNombre =c.cNombre 
	from tDeudaAño d
	join tContribuyente c on c.cCod_Cont=d.cCod_Cont

	update tDeudaAño
	set nDeudas2008 =a.total
	from tDeudaAño d
	join #2008 a on d.cCod_Cont=a.cCod_Cont

	update tDeudaAño
	set nDeudas2009 =a.total
	from tDeudaAño d
	join #2009 a on d.cCod_Cont=a.cCod_Cont

	update tDeudaAño
	set nDeudas2010 =a.total
	from tDeudaAño d
	join #2010 a on d.cCod_Cont=a.cCod_Cont
	


4.Se requiere implementar la posibilidad de que algunos contribuyentes puedan efectuar algún reclamo sobre las deudas 
que tienen pendientes. Estos reclamos son presentados por tipo de tributo (3 primero caracteres de cCod_Trib) y por año.
Para ello se le solicita a usted crear una tabla (tReclamos), que permita insertar los registros de reclamos. Crear el 
procedimiento almacenado paInsertaReclamos, que permita efectuar la inserción de registros, validando además que la deuda
que se está reclamando exista en tDeudas, si no existe simplemente no hace la inserción. A este procedimiento se le pasará
como parámetro de entrada el código del contribuyente, el año, el código de tributo y el motivo de reclamo.

create table tReclamos(
	cCod_Cont char(11),
	año char(4),
	cCod_Trib char(3),
	motivo text
)

select *
from tReclamos

create procedure paInsertaReclamos
(@cCod_Cont char(11),@año char(4),@cCod_Trib char(3) , @motivo text)
as
	begin 
		
		if exists ( select * from tDeudas where year(cAño)=@año and cCod_Cont=@cCod_Cont and left(trim(cCod_Trib),3)=@cCod_Trib)
			begin 
				insert into tReclamos
				values(@cCod_Cont,@año,@cCod_Trib,@motivo)
				print 'INSERCIÓN EXITOSA'
			end
		else
			begin 
				print 'FALLO LA INSERCIÓN'
			end
	end

	exec paInsertaReclamos '0002107','2008','007','no puedieron recibir mi tarjeta :v '

	select * 
	from tDeudas 
	where year(cAño)=2008 and cCod_Cont='0002107' and left(trim(cCod_Trib),3)='007'

	select top 50 d.cCod_Trib,d.cCod_Cont,d.cAño
	from tDeudas d 
	


