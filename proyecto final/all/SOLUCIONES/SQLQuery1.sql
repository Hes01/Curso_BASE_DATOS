--1. 
	--Usando la tabla tImpuesto se requieren listar los c�digos y nombre de contribuyentes 
	--que en el a�o 2009 tienen deudas en ese mismo a�o, pero no tienen deudas en el a�o 
	--2008. Para deudas use la tabla tDeudas.

select i.cCod_Cont [codigo],c.cNombre [nombre]
from timpuesto i 
join tContribuyente c on i.cCod_Cont=c.cCod_Cont
where year(i.cA�o)=2009 
	and i.cCod_Cont in(select distinct cCod_cont
						from tDeudas 
						where year(cA�o)=2009)
	and	i.cCod_Cont not in(select distinct cCod_cont
							from tDeudas 
							where year(cA�o)=2008)
--Listar los codigos de lugares de la tabla tContribuyente que no est�n en la tabla tLugares y los c�digos 
--de lugares de tLugares que no est�n en tContribuyente. El resultado se debe mostrar en un solo listado.

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
--datos de c�digos y nombres de tContribuyente, 
--impuesto con nImp_Pred  (tImpuesto),  valuo con la suma de nVal_Tot (tValuo), 
--estos dos �ltimos valores que correspondan al a�o 2009. 
--En los casos en donde no haya impuesto o val�o deber� colocar cero.

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
where year(cA�o)=2009

select cCod_Cont,sum(nVal_Tot) total--(57586 filas afectadas)
into #valuo
from tValuos
where year(cA�o)=2009
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



--4.	Usando la tabla tValuos listar el c�digo, nombre y total de val�o 
--de los contribuyentes que en el a�o 2009 tienen deudas en ese mismo a�o, 
--pero que no tengan ni intereses ni gastos. Adem�s, s�lo debe listar 
--aquellos contribuyentes que tienen m�s de un predio.


select v.cCod_Cont,c.cNombre,sum(v.nVal_Tot) total
from tValuos v 
join tContribuyente c on v.cCod_Cont=c.cCod_Cont 
where year(v.cA�o)= 2009 and v.cCod_Cont in 
(
select cCod_cont 
from tDeudas 
where year(cA�o)=2009
group by cCod_cont
having sum(nTributo+nReajuste+nInteres+nGasto)>0
)
and v.cCod_Cont not in 
(
select cCod_cont
from tDeudas
where year(cA�o)=2009
group by cCod_cont
having sum(nInteres+nGasto)=0
)
group by v.cCod_Cont,c.cNombre
having count(*)>1
order by total desc

 5.	Crear una tabla tmpDeudas que contenga el c�digo, nombre y total de deuda de los contribuyentes en el a�o 2009. 
Luego agregar un campo Tipo. Ese campo tipo actualizarlo de la siguiente manera: Usando la tabla tImpuesto, 
si la suma de nImp_Pred+nLimp_Publ+nPar_Jard+nRell_Sani+nSerenazgo en el a�o 2009 para ese contribuyente
es mayor a 2000 deber� poner PRINICIPAL, si est� entre 500 y 2000 poner MEDIANO en caso contrario poner PEQUE�O.

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
where year(i.cA�o)=2009 
group by i.cCod_Cont 
having sum(i.nImp_Pred+i.nLimp_Publ+i.nPar_Jard+i.nRell_Sani+i.nSerenazgo)>2000
)

update tmpDeudas 
set tipo = 'MEDIANO'
where codigo in (
select i.cCod_Cont
from timpuesto i
where year(i.cA�o)=2009 
group by i.cCod_Cont 
having sum(i.nImp_Pred+i.nLimp_Publ+i.nPar_Jard+i.nRell_Sani+i.nSerenazgo) BETWEEN 500 AND 2000
)


update tmpDeudas 
set tipo = 'PEQUE�O'
where tipo is null

SELECT *
FROM tmpDeudas
where tipo ='PEQUE�O'


--------------------FORMA MAS ELEGANTE METSI

UPDATE tmpDeudas 
SET tipo=
	case when impuestos.total >2000 then 'PRINCIPAL'
	WHEN impuestos.total BETWEEN 500 AND 2000 then 'MEDIANO'
	ELSE 'PEQUE�O' END
FROM tmpDeudas d
join (
	select i.cCod_Cont,sum(nImp_Pred+nLimp_Publ+nPar_Jard+nRell_Sani+nSerenazgo) total
	from timpuesto i
	WHERE YEAR(cA�o)=2009
	group by i.cCod_Cont
	having sum(nImp_Pred+nLimp_Publ+nPar_Jard+nRell_Sani+nSerenazgo)>0
) as impuestos on d.codigo=impuestos.cCod_Cont

UPDATE tmpDeudas 
set tipo = 'PEQUE�O'
WHERE tipo is null


------EXAMEN PARCIAL

1-La tabla tValuos, contiene el valor por a�o de los predios de cada contribuyente, cada predio se identifica por
el c�digo catastral (cCod_Catas) y el valor total del predio est� dado por la columna nVal_Tot. Se requiere
crear una vista (vDeudasPredios) que liste por a�o los c�digos de contribuyentes , su nombre, el lugar donde viven,
la cantidad de predios y el valor total de los mismos en ese a�o, estos �ltimos de la tabla tValuos. Deber� 
filtrar esta informaci�n para que s�lo aparezcan aquellos que tienen deudas y que no tengan su domicilio en
Asentamientos Humanos.

create view vDeudasPredios([A�O],[CODIGO],[CONTRIBUYENTE],[LUGAR],[CANTIDAD PREDIOS],[VALOR TOTAL])
as
select v.cA�o,c.cCod_Cont codigo,c.cNombre nombre,l.cNombre lugar,count(*) predios ,sum(v.nVal_Tot) valuos
	from tValuos v
	join tContribuyente c on c.cCod_Cont=v.cCod_Cont
	join tLugares l on l.cCod_Lug = c.cCod_Lug
	where c.cCod_Cont in (select cCod_Cont--distinct
						  from tDeudas 
						  where (nTributo+nReajuste+nInteres+nGasto)>0)
		and  l.cNombre not like 'A.H%'
	group by v.cA�o,c.cCod_Cont,c.cNombre,l.cNombre



	2. Crear la tabla tDeudaA�o, que contenga las siguientes columnas: 
	cCod_Cont char(11),cNombre varchar(100),nDeuda2008,nDeuda2009,nDeuda2010, estas
	tres de tipo decimal(9,2). 
	Luego deber� actualizar esta tabla 
	para colocar los datos correspondientes usando la tabla tDeudas y tContribuyente, en las columnas 
	nDeuda2008, nDeuda2009, nDeuda2010, deber� colocar las deudas totales correspondientes a esos 
	a�os. No debe usar PIVOT, sino utilizar tablas temporales en las cuales vaya colocando las deudas 
	de cada a�o y luego actualizar en la tabla creada. Adem�s debe actualizar la tabla de forma tal que no 
	quede ninguna fila en la que hayan columnas con valores NULL.

	create table tDeudaA�o(
		cCod_Cont char(11), 
		cNombre varchar(100),
		nDeudas2008 decimal(9,2) default 0,
		nDeudas2009 decimal(9,2) default 0,
		nDeudas2010 decimal(9,2) default 0
	)
	
	select d.cCod_Cont, sum(d.nTributo+d.nReajuste+d.nInteres+d.nGasto) total
	into #2008
	from tDeudas d
	where year(d.cA�o)=2008
	group by d.cCod_Cont
	
	select d.cCod_Cont, sum(d.nTributo+d.nReajuste+d.nInteres+d.nGasto) total
	into #2009
	from tDeudas d
	where year(d.cA�o)=2009
	group by d.cCod_Cont
	
	select d.cCod_Cont, sum(d.nTributo+d.nReajuste+d.nInteres+d.nGasto) total
	into #2010
	from tDeudas d
	where year(d.cA�o)=2010
	group by d.cCod_Cont


	insert into tDeudaA�o(cCod_Cont)
	select cCod_Cont
	from #2008
	union 
	select cCod_Cont
	from #2009
	union
	select cCod_Cont
	from #2010


	update tDeudaA�o
	set cNombre =c.cNombre 
	from tDeudaA�o d
	join tContribuyente c on c.cCod_Cont=d.cCod_Cont

	update tDeudaA�o
	set nDeudas2008 =a.total
	from tDeudaA�o d
	join #2008 a on d.cCod_Cont=a.cCod_Cont

	update tDeudaA�o
	set nDeudas2009 =a.total
	from tDeudaA�o d
	join #2009 a on d.cCod_Cont=a.cCod_Cont

	update tDeudaA�o
	set nDeudas2010 =a.total
	from tDeudaA�o d
	join #2010 a on d.cCod_Cont=a.cCod_Cont
	


4.Se requiere implementar la posibilidad de que algunos contribuyentes puedan efectuar alg�n reclamo sobre las deudas 
que tienen pendientes. Estos reclamos son presentados por tipo de tributo (3 primero caracteres de cCod_Trib) y por a�o.
Para ello se le solicita a usted crear una tabla (tReclamos), que permita insertar los registros de reclamos. Crear el 
procedimiento almacenado paInsertaReclamos, que permita efectuar la inserci�n de registros, validando adem�s que la deuda
que se est� reclamando exista en tDeudas, si no existe simplemente no hace la inserci�n. A este procedimiento se le pasar�
como par�metro de entrada el c�digo del contribuyente, el a�o, el c�digo de tributo y el motivo de reclamo.

create table tReclamos(
	cCod_Cont char(11),
	a�o char(4),
	cCod_Trib char(3),
	motivo text
)

select *
from tReclamos

create procedure paInsertaReclamos
(@cCod_Cont char(11),@a�o char(4),@cCod_Trib char(3) , @motivo text)
as
	begin 
		
		if exists ( select * from tDeudas where year(cA�o)=@a�o and cCod_Cont=@cCod_Cont and left(trim(cCod_Trib),3)=@cCod_Trib)
			begin 
				insert into tReclamos
				values(@cCod_Cont,@a�o,@cCod_Trib,@motivo)
				print 'INSERCI�N EXITOSA'
			end
		else
			begin 
				print 'FALLO LA INSERCI�N'
			end
	end

	exec paInsertaReclamos '0002107','2008','007','no puedieron recibir mi tarjeta :v '

	select * 
	from tDeudas 
	where year(cA�o)=2008 and cCod_Cont='0002107' and left(trim(cCod_Trib),3)='007'

	select top 50 d.cCod_Trib,d.cCod_Cont,d.cA�o
	from tDeudas d 
	


