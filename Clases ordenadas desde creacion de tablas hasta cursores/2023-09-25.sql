--clase 25 de setiembre del 2023

--intereses tabla contribuyente
--deuda:ntributo,nReajuste,nInteres,nGasto
--predio:casa, edificio, etc : esto dice a que uso se le esta dando a ese predio

--SELECT 

select * from tDeudas

select top 1000 * from tDeudas --top primeras n filas especificadas

select cCod_cont,cAño from tDeudas --solo muestra el codigo y año

select cCod_cont as codigo,cAño  as año, nTributo+nReajuste+nInteres+nGasto as "Deuda total " from tDeudas --alias con as

select cCod_cont as codigo,cAño  as año, nTributo+nReajuste+nInteres+nGasto as "Deuda total " from tDeudas 
where nTributo+nReajuste+nInteres+nGasto >500 

select cCod_cont as codigo,cAño  as año, nTributo+nReajuste+nInteres+nGasto as "Deuda total " from tDeudas 
where nTributo+nReajuste+nInteres+nGasto >500 and cAño='2003' --agregando and ,or,not etc

--ordenar con order by se ordena con el alias

select cCod_cont as codigo,cAño  as año, nTributo+nReajuste+nInteres+nGasto as "Deuda total " from tDeudas 
where nTributo+nReajuste+nInteres+nGasto >500 and cAño='2003'
order by "Deuda total " --alias para ordenar

select cCod_cont as codigo,cAño  as año, nTributo+nReajuste+nInteres+nGasto as "Deuda total " from tDeudas 
where nTributo+nReajuste+nInteres+nGasto >500 and cAño='2003'
order by 1,3 --indica la columna cCod_cont,cCod_Trib