--21/12/2023
--sabado a las cuatro

------------------------------------JOINS(juntura)---------------------------
-----------------------------------------------------------------------------
--INNER JOIN
--LEFT JOIN
--RIGHT
--OUTER JOIN
--FULL OUTER JOIN
--ejem:
	--select *
	--from tabla1 
	--inner join tabla2 on tabla1.columna_fk=tabla2.columna.fk

select a.cCod_Cont,a.cNombre,b.cNombre
from tContribuyente as a
join tLugares as b on a.cCod_Lug=b.cCod_Lug

--ejm:Listar aquellos contribuyentes que no estan en lugares de urbanizacion(URB.) ni asientos humanos(A.H.)
--CON PUNTO 'A.H.%'
Select  *
from tContribuyente as a
inner join tLugares as b on a.cCod_Lug=b.cCod_Lug
where not (b.cNombre LIKE  'URB.%'  OR b.cNombre LIKE 'A.H.%')
--SIN PUNTO 'A.H%'
Select  *
from tContribuyente as a
inner join tLugares as b on a.cCod_Lug=b.cCod_Lug
where not (b.cNombre LIKE  'URB.%'  OR b.cNombre LIKE 'A.H%')


--Listar los lugares de aquellos contribuyentes 
-- que no viven en URB. ni A.H.

Select  b.cNombre
from tContribuyente as a
inner join tLugares as b on a.cCod_Lug=b.cCod_Lug
where not (b.cNombre LIKE  'URB.%'  OR b.cNombre LIKE 'A.H.%')
order by 1--acepta alias 


--Listar el codigo, nombre y total de deuda
--de los contribuyentes que viven en URB y 
--que su deuda total este entre 500 y 1000

select a.cCod_Cont,a.cNombre ,sum(c.nTributo+c.nReajuste+c.nInteres+c.nGasto) total
from tContribuyente as a
inner join tLugares as b on a.cCod_Lug=b.cCod_Lug
inner join tDeudas as c on a.cCod_cont=c.cCod_cont
where b.cNombre LIKE  'URB.%'  
group by a.cCod_Cont,a.cNombre
having  sum(c.nTributo+c.nReajuste+c.nInteres+c.nGasto) between 500 and 1000 
order by a.cCod_Cont





