USE TRIBUTOS


--join juntura
--inner join(interno)
--right join
--full outer join


--join interno: se apreciara coincidencias de ambas tablas
select * 
from tContribuyente c 
inner join tLugares l on c.cCod_Lug=l.cCod_Lug

-----------------------------LEFT JOIN-------------------------
select * 
from tContribuyente c --tabla izq
left join tLugares l on c.cCod_Lug=l.cCod_Lug
--datos de codigo de lugar que estan en contribuyentes pero no 
--en la tabla lugares
select * 
from tContribuyente c --tabla izq
left join tLugares l on c.cCod_Lug=l.cCod_Lug
where l.cCod_Lug is null--contributes que no se relacionan con lugares 
--y cualquiera de las columnas de lugares funciona para esta consulta 
--ejm:
select *
from tContribuyente c --tabla izq
left join tLugares l on c.cCod_Lug=l.cCod_Lug
where l.cNombre is null--contributes que no se relacionan con lugares
--diferencia entre join y left si la bd tiene integridad referencial
--es que no hay ninguna diferencia porque todos los registros coinciden 
--porque estan las fk y pk relacionadas 

--en el left solo mostrara los datos de la tabla izq pero los de la
--derecha estaran en null ademas si esta la fk en null todos las demas columnas
--estaran en null

--CURIOSIDAD--
select distinct c.cCod_Lug --COD que no estan en  contribuyentes pero si en lugares
from tContribuyente c --tabla izq
left join tLugares l on c.cCod_Lug=l.cCod_Lug
where l.cNombre is null


select distinct c.cCod_Lug --aqui no importa si poner c.codlugar o l.codlugar porque ninguno 
--se juntara en la condicion de juntura
from tContribuyente c --tabla izq
inner join tLugares l on c.cCod_Lug=l.cCod_Lug
where l.cNombre is null

--OJO: el sql no valida las condiciones de juntura por eso aqui no sale error 

select distinct c.cCod_Lug --aqui no importa si poner c.codlugar o l.codlugar porque ninguno 
--se juntara en la condicion de juntura
from tContribuyente c --tabla izq
inner join tLugares l on c.cNombre=l.cCod_Lug
--where l.cNombre is null

-----------------------------RIGTH JOIN-------------------------
--OJO : si se muestran mas registros de lo normal puede que en lugares hayan registros 
--que no se relacionan con los registros de contribuyentes
select *
from tContribuyente c --tabla 
RIGHT join tLugares l on c.cCod_Lug=l.cCod_Lug


--lugares no estan en la tabla contribuyentes 
select *
from tContribuyente c --tabla 
RIGHT join tLugares l on c.cCod_Lug=l.cCod_Lug
where c.cCod_Lug is null --para ver los registros nulos de la tabla izq
--osea: aqui se muestran todos los coincidentes de la derecha aun si en la derecha tienes
--registros que no se relacionan con los contribuyentes, los contribuyentes 
--que no se relacionan salen como null todos sus datos porque la integridad es dominante
--woooooo :D

select *
from tLugares
--6784-
--3323
--3461 codigos que si estan en lugares 

select distinct l.cCod_Lug --muestra 3323 porque cod_lug es pk no se repite
from tContribuyente c --tabla 
RIGHT join tLugares l on c.cCod_Lug=l.cCod_Lug
where c.cCod_Lug is null --los que estan en lugares 

select distinct l.cCod_Lug --3461   ---los que no estan en lugares 
from tContribuyente c --tabla 
RIGHT join tLugares l on c.cCod_Lug=l.cCod_Lug
where c.cCod_Lug is not null --esta condicion solo muestra aquellos que coinciden
--es decir muestra los datos que estan en la tabla izq pero que no estan en 
--la derecha 



select distinct l.cCod_Lug --3461
from tContribuyente c --tabla 
inner join tLugares l on c.cCod_Lug=l.cCod_Lug
where c.cCod_Lug is not null  --esta condicion solo muestra aquellos que coinciden
--es decir muestra los datos que estan en la tabla izq pero que no estan en 
--la derecha 
--partiendo que los join muestran coincidencias salen las premisas

select distinct l.cCod_Lug --3461
from tContribuyente c --tabla 
left join tLugares l on c.cCod_Lug=l.cCod_Lug
where l.cCod_Lug is not null

select * --6784
from tLugares




--Averiguar : determinar la cantidad de lugares bucando los que no estan en contribuyentes
--con los que estan y me deberia salir lo mismo

select 3323+3461 --6784


--registros de lugares que no estan en la tabla contribuyentes 
--
select distinct l.cCod_Lug --3466 
from tContribuyente l --t derecha 
left join tLugares c on c.cCod_Lug=l.cCod_Lug
where c.cCod_Lug is not null
----------------------FULL JOIN-----------------------------------
--es como juntar el left con el join muestra los de la derecha como los de la izquierda
--sino encuentra en una le pone null 

select *  --3323
from tContribuyente c --t iza
full join tLugares l on c.cCod_Lug=l.cCod_Lug
where c.cCod_Lug is null



select *  --273181
from tContribuyente c 
full join tLugares l on c.cCod_Lug=l.cCod_Lug
order by l.cCod_Lug--si pones c se ordena por contribuyente pero si pones l por lugares
