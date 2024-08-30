---funciones del sistema---
@@error: devuelve el numero de errores , permite capturar los errores
ejm:si violamos la clave foranea capturamos el error.
0:sino encontro errores .
devuelve numero errores : si encontro errores .

---------
alter table tDeudas add
constraint chk_tributo check(nTributo >=0 )

 
--crear el procedimiento almacenado con
--@@error que permita detectar errores al realizar una insersion

create procedure pa_insertar(@codigo char(11),@a�o char(4),@tributo numeric(11,2),@codTributo char(7))--CODIGO A�O CODIGO TRIBUTO 
as 
	begin 
		if exists( select * from tDeudas where cCod_cont =@codigo and year(cA�o)=@a�o and cCod_Trib=@codTributo)
			begin 
				update tDeudas
				set nTributo=@tributo
				where cCod_cont =@codigo and year(cA�o)=@a�o and cCod_Trib=@codTributo
				declare @contadorFilas int=@@rowcount
				if @@ERROR<>0 --captura el error anterior
					begin 
						print N'error ocurrido al realizar inserci�n, numero de filas afectadas es :' + cast(@contadorFilas as varchar)
						return 99
					end 
				else 
					begin 
						print N'la inserci�n fue exitosa numero de filas afectadas es :' + cast(@contadorFilas as varchar)
					end 
			end
		else 
			begin
				print 'Verifique que:'
				print 'El codigo del contribuyente : ' + cast(@codigo as varchar)
				print '� el codigo del tributo : ' + cast(@codTributo as varchar)
				print '� El a�o : '+cast(@a�o as varchar)+ ' exista para realizar la inserci�n'
			end
	end 
	
drop procedure pa_insertar

		select cCod_cont,cCod_Trib,cA�o
		from tDeudas
		where  year(cA�o)=2009 and cCod_cont='0002107'

	exec pa_insertar '0002107','2009',-10.20,'0010181'

------@@indetity: devuelve numeric(38,0)
definicion: devuelve el valor  ultimo valor de identidad insertado de la columna que es de tipo identidad.
se usa bastante: cuando se hace inserciones de tablas cabeceras o tabla detalles 
------@@rowcount 



---BEGIN TRANSACTION :transacciones 

definicion: 
ejm: tranferencias entre cuentas dinero de la cuenta a, a la cuenta b
primero : retiro de a 1000
luego: actualizo donde esta la cuenta para restar 
cuenta b: lo sumo 
tTranferencias: actualizar 




