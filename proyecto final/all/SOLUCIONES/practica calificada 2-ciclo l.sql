--------practica n°02-----2023-1
create view vImpuestos
as 
	select 
		c.cCod_Cont CODIGO,
		case when c.cNumero is not null and TRIM(c.cNumero) <> '' then
			TRIM(l.cNombre)+' ' +TRIM(ca.cNombre)+' ' + TRIM(c.cNumero)+' ' + TRIM(c.cManzana)+' ' + TRIM(c.cLote)+' ' end DIRECCION,
			i.totImpuesto [total impuesto],i.totLimpieza [total de limpieza]
	from tContribuyente c
	join (select cCod_Cont,sum(nImp_Pred) totImpuesto, sum(nLimp_Publ) totLimpieza
			from tImpuesto
			group by cCod_Cont	) as i on c.cCod_Cont=i.cCod_Cont
	join tLugares l on c.cCod_Lug=l.cCod_Lug
	join tCalles ca on c.cCod_Calle=ca.cCod_Calle
	--join tDeudas d  on c.cCod_Cont= d.cCod_cont --ojo
	where c.cCod_Cont 
			in
			(select cCod_cont
			from tDeudas
			group by cCod_cont
			having sum(nTributo)>0 and sum(nInteres+nReajuste+nGasto)=0
			)
			and  l.cNombre not like 'URB.%'
	
	DROP VIEW vImpuestos
SELECT *
FROM vImpuestos
--2

SELECT distinct  c.cCod_Cont,c.cNombre
FROM tContribuyente C 
join tValuos v on c.cCod_Cont=v.cCod_Cont
join  tImpuesto i on i.cCod_Cont =c.cCod_Cont
group by c.cCod_Cont,c.cNombre
having count(v.cCod_Cont)=0 and count(i.cCod_Cont)>=1

--3

repetida.

--4
create table #tImpuesto(
	cCod_Cont char(11),
	cNombre varchar(100),
	impuesto decimal(15,2) default 0,
	valuo decimal(15,2) default 0)

	insert into #tImpuesto(cCod_Cont,cNombre)
	select distinct cCod_Cont,cNombre
	from tContribuyente 

	
	select cCod_Cont,sum(nImp_Pred) [total impuesto]
	into #nImp_pred
	from tImpuesto 
	where year(cAño)=2008
	group by cCod_Cont

	select cCod_Cont,sum(nVal_Tot) [total valuo]
	into #nVal_tot
	from tValuos
	where year(cAño)=2008
	group by cCod_Cont

	insert into #tImpuesto(impuesto)
	select i.[total impuesto]
	from #nImp_pred i
	join #tImpuesto im on im.cCod_Cont=i.cCod_Cont

	insert into #tImpuesto(impuesto)
	select i.[total valuo]
	from #nVal_tot i
	join #tImpuesto im on im.cCod_Cont=i.cCod_Cont


---5
select cCod_Cont,sum(nVal_Tot) totalValuos
into #totValuos
from tValuos
where year(cAño)=2008
group by cCod_Cont

update timpuesto
set nVal_Tot = a.totalValuos
from #totValuos a
join timpuesto i on i.cCod_Cont = a.cCod_Cont 
