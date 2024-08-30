--14/12/2023
--LISTAR AQUELLOS REGISTROS CUYO nTributo estan entre 100 y 1000 
select *
from tDeudas
where nTributos >=100 and nTributo <=1000

----con BETWEEN 
select *
from tDeudas
where nTributo between 100 and 1000



-------------------------------SUBCONSULTAS-------------------------------

--CONCEPTO: son consultas anidadas

--LISTAR NOMBRES DE LOS CONTRIBUYENTES QUE VIVEN EN AA.HH(es asentamientos humanos)
--ESTOS SON AQUELLOS CUYO NOMBRE DE LUGAR EMPIEZA CON A.H.( asentamiento humano)
SELECT *
FROM tContribuyente
WHERE cCod_Lug IN ( --IN:en , es una lista
	SELECT cCod_Lug
	FROM tLugares
	WHERE cNombre LIKE 'A.H.%' --todos aquellos que empiezan con A.H.
)


--LISTAR LAS DEUDAS DE LOS CONTRIBUYENTES 
--QUE VIVEN EN URBANIZACIONES, AQUELLOS CUYO NOMBRE DE LUGAR 
--DE SU DOMICILIO EMPIEZA CON URB
--Y QUE TRIBUTO SEA MAYOR A 100

SELECT *
FROM tDeudas
WHERE cCod_cont IN(
	SELECT cCod_cont
	FROM tContribuyente
	WHERE cCod_Lug IN (
		SELECT cCod_Lug
		FROM tLugares
		WHERE cNombre LIKE 'URB.%'
		)
)
AND nTributo >100


--LISTAR LAS DEUDAS DE LOS CONTRIBUYENTES 
--QUE VIVEN EN URBANIZACIONES Y AA.HH , AQUELLOS CUYO NOMBRE DE LUGAR 
--DE SU DOMICILIO EMPIEZA CON URB. O A.H.
--Y QUE EN AVENIDA, AQUELLOS CUYO NOMBRE DE CALLE EMPIEZA CON AV.
--Y QUE EL TOTAL DE DEUDA ESTE ENTRE 50 Y 200
SELECT *,nTributo+nReajuste+nInteres+nGasto AS TOTAL --ALIAS: para verificar que este en la condicion dada 
FROM tDeudas
WHERE cCod_cont IN (
    SELECT cCod_cont
    FROM tContribuyente
    WHERE cCod_Lug IN ( 
        SELECT cCod_Lug
        FROM tLugares
        WHERE cNombre LIKE  'URB.%'  OR cNombre LIKE 'A.H.%'  ) AND cCod_Calle IN (
					SELECT cCod_Calle
					FROM tCalles
					WHERE cNombre LIKE 'AV.%'
					)
)AND  (nTributo+nReajuste+nInteres+nGasto) BETWEEN 50 AND 200

--SI ME DICEN : AQUELLOS QUE NO ESTAN EN URB. Y A.H. solo ponemos NOT IN(...
SELECT *,nTributo+nReajuste+nInteres+nGasto AS TOTAL --ALIAS: para verificar que este en la condicion dada 
FROM tDeudas
WHERE cCod_cont  IN (
    SELECT cCod_cont
    FROM tContribuyente
    WHERE cCod_Lug NOT IN (--SOLO CAMBIAMOS AQUI 
        SELECT cCod_Lug
        FROM tLugares
        WHERE cNombre LIKE  'URB.%'  OR cNombre LIKE 'A.H.%'  ) AND cCod_Calle IN (
					SELECT cCod_Calle
					FROM tCalles
					WHERE cNombre LIKE 'AV.%'
					)
)AND  (nTributo+nReajuste+nInteres+nGasto) BETWEEN 50 AND 200




