--desarrollo de examen =practica calificada 1 

--1. Usando la tabla timpuesto se quieren listar los códigos y nombre de contribuyentes que en el año 2009
--tienen deudas en ese mismo año, pero no tienen deudas en el 2008. Para deudas use la tabla tDeudas

select i.cCod_Cont,c.cNombre
from  tImpuesto i 
join tContribuyente c on c.cCod_Cont=i.cCod_Cont
where year(i.cAño)=2009 and i.cCod_Cont in 
	(select distinct cCod_cont
	from tDeudas 
	where year(cAño)=2009
	)
	and i.cCod_Cont not in
	(select distinct cCod_cont
	from tDeudas 
	where year(cAño)=2008
	)

--2. Listar los códigos de lugares de la tabla tContribuyentes que no están en la tabla tLugares
--y los códigos de lugares de tLugares que no están en tContribuyentes. El resultado se debe mostrar en un solo listado.

--tcontribuyente tlugares 
--codlug			null
--null				codlug
select distinct c.cCod_Lug
from tContribuyente c 
left join tLugares l on c.cCod_Lug=l.cCod_Lug
where l.cCod_Lug is null
union
select distinct l.cCod_Lug
from tContribuyente c 
right join tLugares l on c.cCod_Lug=l.cCod_Lug
where c.cCod_Lug is null

--3. 
--i-Crear una tabla timpuestoValuo, que contenga las siguientes columnas: 
--cCod_Cont, cNombre, Impuesto, valuo. 
--ii-Luego llenar esta tabla con todos los datos de códigos y nombres de tContribuyente, 
--iii-Impuesto con nimp_Pred (timpuesto),
--iv:valuo con la suma de nval_Tot (tValuo), estos dos últimos valores que correspondan al año 2009. 
--En los casos en donde no haya Impuesto o valúo deberá colocar cero.
drop table timpuestoValuo
create table timpuestoValuo(
	codigo char(11) ,
	nombre varchar(100),
	impuesto decimal(15,2) default 0,
	valueo decimal(15,2) default 0
)

insert into timpuestoValuo(codigo,nombre)
select c.cCod_Cont,c.cNombre
from tContribuyente c


update timpuestoValuo
set impuesto = i.nImp_Pred
from timpuesto i 
where year(i.cAño)=2009 and timpuestoValuo.codigo=i.cCod_Cont--actualiza solo aquellos que tienen impuesto 

--tabla tempo y luego ya metemos con libertad xd 
drop table #xd
select i.cCod_Cont,sum(i.nval_Tot) total
into #xd
from timpuesto i 
--join timpuestoValuo v on i.cCod_Cont=v.codigo
where year(i.cAño)=2009
group by i.cCod_Cont



update v
set valueo= total 
from timpuestoValuo v 
join #xd x on x.cCod_Cont=v.codigo


select *
from timpuestoValuo 

--4. Usando la tabla tValuos listar el código, nombre y total de valúo de los contribuyentes que en el año 2009
--tienen deudas en ese mismo año, pero que no tengan ni Intereses ni gastos. Además, sólo debe listar aquellos 
--contribuyentes que tienen más de un predio. (mas de un predio es decir mas de un registro)
select v.cCod_Cont,c.cNombre,sum(nVal_Tot) total
from tValuos v 
join tContribuyente c on c.cCod_Cont = v.cCod_Cont
where year(v.cAño)=2009
	and v.cCod_Cont in(
					select distinct cCod_cont
					from tDeudas 
					where year(cAño)=2009
					group by cCod_cont
					having sum(nTributo+nReajuste+nInteres+nGasto)>0
						)
	and v.cCod_Cont not in (
						select distinct cCod_cont
						from tDeudas 
						where year(cAño)=2009
						group by cCod_cont
						having sum(nInteres+nGasto)=0
						)
group by v.cCod_Cont,c.cNombre
having count(v.cCod_Cont)>1


-- 5.	Crear una tabla tmpDeudas que contenga el código, nombre y total de deuda de los contribuyentes en el año 2009. 
--Luego agregar un campo Tipo. Ese campo tipo actualizarlo de la siguiente manera: Usando la tabla tImpuesto, 
--si la suma de nImp_Pred+nLimp_Publ+nPar_Jard+nRell_Sani+nSerenazgo en el año 2009 para ese contribuyente
--es mayor a 2000 deberá poner PRINICIPAL, si está entre 500 y 2000 poner MEDIANO en caso contrario poner PEQUEÑO.

if object_id('tmpDeudas') is not null
	begin 
	drop table tmpDeudas
	end

create table tmpDeudas (
	codigo char(11),
	nombre varchar(100),
	totaldeuda decimal(15,2)
)

select c.cCod_Cont, sum(d.nGasto+d.nInteres+d.nReajuste+d.nTributo) total
into #tmpxd
from tContribuyente c 
join tDeudas d on d.cCod_cont=c.cCod_Cont
where year(d.cAño)=2009
group by c.cCod_Cont

insert into tmpDeudas(codigo,nombre,totaldeuda)
select c.cCod_Cont,c.cNombre , x.total
from tContribuyente c 
join #tmpxd x on x.cCod_Cont=c.cCod_Cont

alter table tmpDeudas add --agregamos la columna tipo 
tipo varchar(20)

select distinct tipo from tmpDeudas

update tmpDeudas
set tipo = 'PRINCIPAL'
WHERE codigo in(
	select i.cCod_Cont
	from timpuesto i
	where year(i.cAño)=2009
	group by i.cCod_Cont
	having sum(i.nImp_Pred+i.nLimp_Publ+nPar_Jard+i.nRell_Sani+i.nSerenazgo)>2000
)

update tmpDeudas
set tipo = 'MEDIANO'
WHERE codigo in(
	select i.cCod_Cont
	from timpuesto i
	where year(i.cAño)=2009
	group by i.cCod_Cont
	having sum(i.nImp_Pred+i.nLimp_Publ+nPar_Jard+i.nRell_Sani+i.nSerenazgo) BETWEEN 500 AND 2000
)

update tmpDeudas
set tipo = 'PEQUEÑO'
WHERE tipo is  null


--


--1

select c.cCod_Cont, c.cNombre,l.cNombre, (d.nInteres +d.nReajuste+d.nTributo) total
from tContribuyente c 
join tDeudas d on d.cCod_cont=c.cCod_Cont
join tLugares l  on c.cCod_Lug=l.cCod_Lug
where (d.cCod_Trib like '007%' or d.cCod_Trib like '008%' OR d.cCod_Trib like '022%') 
		and l.cNombre like 'A.H.%' and not (d.nInteres +d.nReajuste+d.nTributo)=0

--2
select *
into #tmpDeudas
from tDeudas 

select *
from #tmpDeudas

alter table #tmpDeudas 
add nAjuste decimal(9,2)

update #tmpDeudas
set nAjuste = (d.nInteres +d.nReajuste+d.nTributo)*(0.2/100)
from tDeudas d
where (d.nInteres +d.nReajuste+d.nTributo) >500


--3
	select *
	from timpuesto i 
	join tCalles c on i.cCod_Calle=c.cCod_Calle
	join tLugares l on l.cCod_Lug=i.cCod_Lug
	where c.cNombre like 'AV.%'
	and i.nVal_Afecto<i.nVal_Tot
	and i.nNum_Pred<3 
	and year(i.cAño)=2009
	and (
	l.cNombre like 'URB.%'
	OR l.cNombre like 'AG.V.%'
	OR l.cNombre like 'C.H.%'
	)

--4
select c.cNombre ,count(c.cCod_Cont) [numero de predios] 
from tContribuyente c 
join tValuos v on c.cCod_Cont =v.cCod_Cont
where year(v.cAño)=2009
group by  c.cNombre
having count(*)>1
--5

select l.cNombre
from tContribuyente c 
join tLugares l on l.cCod_Lug =c.cCod_Lug
join tDeudas d on d.cCod_cont=c.cCod_Cont
join timpuesto i on i.cCod_Cont= c.cCod_Cont
where year(d.cAño)=2009 and  d.cCod_cont in(
select cCod_cont
from timpuesto
where year(cAño)=2009
)
group by l.cNombre
order by 1