select * from VENDEDOR


--declaramos el cursor
declare c_vendedor cursor
	for select * from VENDEDOR 
--abrimos el cursor 
open c_vendedor
--mostramos el primer registro 
fetch next from c_vendedor
close c_vendedor --cerramos 
deallocate c_vendedor --liberamos

---imprimir todos los registros de cliente

select *from CLIENTE
sp_columns cliente
declare @rso char(30),@dir varchar(100),@tlf varchar(10)

declare c_cliente cursor 
	for select RSO_CLI,DIR_CLI,TLF_CLI
	from CLIENTE c 
	join DISTRITO d on d.COD_DIS = c.COD_DIS

--abrimos cursor 
open c_cliente 
--obtenemos el primer registro 
fetch c_cliente into @rso,@dir,@tlf
print 'CLIENTE	DIRECCION	TELEFONO'
PRINT '-----------------------------'
--Recorrer el cursor 
while @@FETCH_STATUS =0--si es igual a cero ya no hay filas que recorrer 
begin
	print @rso+space(5)+@dir+space(5)+@tlf
	fetch c_cliente into @rso,@dir,@tlf
end
--cerramos cursor
close c_cliente 
--liberamos
deallocate c_cliente

----	implementar un cursor donde se imprima todos los registros de la tabla PRODUCTO		
----	dependiendo de la unidad 
select * from PRODUCTO 

declare @des varchar(50),@pre_pro decimal(8,2),@uni char(3)
--declaramos el curso
declare c_productos cursor 
	for select DES_PRO,PRE_PRO,UNI_PRO from PRODUCTO where UNI_PRO='CIE'

--ABRIMOS EL CURSOR 
OPEN c_productos 
--almacenamos el primer registro 
fetch c_productos into @des,@pre_pro,@uni
print 'DESCRIPCION	PRECIO	UNIDAD-MEDIDA'
print '----------------------------------'
--recorremos lo demas 
while @@FETCH_STATUS=0--no hay mas 
begin 
	print concat_ws('</>',@des,@pre_pro,@uni)
	fetch c_productos into @des,@pre_pro,@uni
end

--cerramos el cursor
close c_productos 
--liberamos 
deallocate c_productos 


---IMPLEMENTAR UN CURSOR QUE IMPRIMA LOS CLIENTES POR DISTRITO 
SELECT *
FROM CLIENTE C 
JOIN DISTRITO D ON D.COD_DIS=C.COD_DIS
--CALLAO

DECLARE @rso varchar(20), @dir varchar(100), @dis varchar(50), @tlf varchar(20),@cont int=0,@nameDis varchar(50)='CALLAO'
--declaramos el cursor
declare c_clienteXdistrito cursor 
	for select c.RSO_CLI,c.DIR_CLI,d.NOM_DIS,c.TLF_CLI  from CLIENTE c join DISTRITO d on d.COD_DIS = c.COD_DIS where d.NOM_DIS=@nameDis
--abrimos el cursor para almacenar 
open c_clienteXdistrito
--obtenemos el primer registro 
fetch c_clienteXdistrito into @rso,@dir,@dis,@tlf
print 'cliente				direccion				distrito				telefono'
--recorremos 
while @@FETCH_STATUS =0--no hay mas registros
begin 
	set @cont +=1
	print concat_ws('>>>--<<<',@rso,@dir,@dis,@tlf)
	fetch c_clienteXdistrito into @rso,@dir,@dis,@tlf
	
end 
print 'End: para el distrito '+@nameDis +' hay '+cast(@cont as varchar)+' clientes.'
--cerramos el cursor 
close c_clienteXdistrito
--liberamos el cursor 
deallocate c_clienteXdistrito