--30/12/2023
--joins: se comportan como si fueran una tabla porque en si agrupan
--registros

--Listar las deudas por nombres de lugares 
--de los años mayores al 2005 
--y que sean mayores a 2000
use TRIBUTOS

select l.cNombre, sum(nTributo+nInteres+nGasto+nReajuste) Deuda
from tDeudas d
inner join tContribuyente c on d.cCod_cont= c.cCod_Cont
inner join tLugares l on c.cCod_Lug= l.cCod_Lug
where d.cAño > '2005'  
group by l.cNombre 
having sum(d.nTributo+d.nInteres+d.nGasto+d.nReajuste) >2000
order by Deuda desc

--con inner :no los muestra 
--con lef, rigth,full los pone en null

----------------------	tablas temporales ----------------------	
--se almacenan en la ram despues de eso desaparecen si apagamos el pc

--guardado en tabla fisica

select l.cNombre, sum(nTributo+nInteres+nGasto+nReajuste) Deuda
into tDeudasLugares --crea una tabla fisica con esa data (aqui se pone la tabla a crear)
from tDeudas d
inner join tContribuyente c on d.cCod_cont= c.cCod_Cont
inner join tLugares l on c.cCod_Lug= l.cCod_Lug
where d.cAño > '2005'  
group by l.cNombre --dos lugares con mismo nombre con codlugar diferente
having sum(d.nTributo+d.nInteres+d.nGasto+d.nReajuste) >2000
order by Deuda desc

select *
from tDeudasLugares --tabla fisica creada 

--eliminamos esa tabla fisica

drop table tDeudasLugares

--ahora con tablas temporales 
select l.cCod_Lug,l.cNombre, sum(nTributo+nInteres+nGasto+nReajuste) Deuda
into #tDeudasLugares --crea una tabla temporal con esa data (aqui se pone la tabla a crear)
from tDeudas d
inner join tContribuyente c on d.cCod_cont= c.cCod_Cont
inner join tLugares l on c.cCod_Lug= l.cCod_Lug
where d.cAño > '2005'  
group by l.cCod_Lug,l.cNombre --salen mas por que puede que sea un codigo de piura el otro de sechura
--dos lugares con mismo nombre pero ubicados en departamentos o distritos diferences 
having sum(d.nTributo+d.nInteres+d.nGasto+d.nReajuste) >2000
order by Deuda desc

select *
from #tDeudasLugares 


select * 
from tImpuesto

--juntas esos resultados para que sume el impuesto de esos contribuyentes para que sume
--nimp_pred de todos los años de esos lugares

select d.cCod_Lug,d.cNombre,Deuda ,sum(nImp_Pred) Impuesto
from tImpuesto i 
join #tDeudasLugares d on i.cCod_Lug= d.cCod_Lug--pueden ser pk y fk o que simplemente coincidan
group by d.cCod_Lug,d.cNombre,Deuda

--150114007	MIRAFLORES   	21755.00	22988.80

select d.cCod_Lug,d.cNombre ,sum(nImp_Pred) Impuesto,sum(Deuda) Deuda
from tImpuesto i 
join #tDeudasLugares d on i.cCod_Lug= d.cCod_Lug--pueden ser pk y fk o que simplemente coincidan
group by d.cCod_Lug,d.cNombre--solo coumnas no funciones agrupadas
order by 1
--150114007	MIRAFLORES   	22988.80	391590.00 --muestra mas por que solo le digo que agrupe el impuesto



select d.cCod_Lug lugar, i.cCod_Lug impuesto,d.cNombre,Deuda,i.cAño,i.nImp_Pred impuesto
from tImpuesto i 
join #tDeudasLugares d on i.cCod_Lug= d.cCod_Lug
where d.cCod_Lug = '150114007' 

--#tmp para una sola sesion
--##tmp para mas sesiones

select l.cCod_Lug,l.cNombre, sum(nTributo+nInteres+nGasto+nReajuste) Deuda
into ##tDeudasLugares --crea una tabla temporal con esa data (aqui se pone la tabla a crear)
from tDeudas d
inner join tContribuyente c on d.cCod_cont= c.cCod_Cont
inner join tLugares l on c.cCod_Lug= l.cCod_Lug
where d.cAño > '2005'  
group by l.cCod_Lug,l.cNombre --salen mas por que puede que sea un codigo de piura el otro de sechura
--dos lugares con mismo nombre pero ubicados en departamentos o distritos diferences 
having sum(d.nTributo+d.nInteres+d.nGasto+d.nReajuste) >2000
order by Deuda desc

select *
from ##tDeudasLugares --para distintas sesiones

---UNION: es unir dos resultados
--ejm:
sp_helpconstraint 'tDeudas' --no tiene integridad por eso se repiten
select distinct cCod_cont --2092
from tDeudas
union--unir resultados no suma sino elimina resultados repetidos
select distinct cCod_cont --62322
from tImpuesto

select 2092+62322 --64414

--ejm

--{
--(1,2,3) 
--(1)
--(2)}
--RESULTADO DE UNION ES 1,2,3 SOLO 3 RESULTADOS		


select distinct nInteres 
from tDeudas
union--unir resultados no suma sino elimina resultados repetidos
select distinct cCod_cont 
from tImpuesto
--ERRROR: Error de desbordamiento aritmético al convertir varchar al tipo de datos numeric. 
--QUIERE DECIR :  que no se puede unir distintos tipos de datos
