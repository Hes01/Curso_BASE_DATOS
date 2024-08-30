
IF OBJECT_ID('CLIENTE')  IS NOT NULL
	BEGIN 
		PRINT 'HOLA'
	END 
ELSE 
	BEGIN
	PRINT 'ADIOS'
	END


IF EXISTS(SELECT * FROM CLIENTE WHERE COD_DIS='D04')
	BEGIN 
		PRINT 'SI EXISTE'
	END
ELSE 
	BEGIN 
		PRINT 'NO EXISTE'
	END



--TRY CATCH 
BEGIN TRY
    SELECT 1/0; -- Esto provocará un error de división por cero
	BEGIN 
		PRINT 'HOLA GENIAL'
	END
END TRY
BEGIN CATCH
    -- Bloque CATCH
    -- Maneja el error capturado en el bloque TRY
    PRINT 'Se ha producido un error: ' + ERROR_MESSAGE(); -- Muestra el mensaje de error
END CATCH;

---practicando 


SP_TABLES

SP_COLUMNS CLIENTE


create procedure pa_top5 
as	
	begin 
		select top 5 *
		from PRODUCTO 
		order by PRE_PRO desc
	end 

exec pa_top5

drop procedure pa_top5


if OBJECT_ID('pa_reporte') is not null
drop procedure pa_reporte

create procedure pa_reporte
as 
	begin 
		select v.COD_DIS CODIGO ,
		CONCAT_WS(' ',V.NOM_VEN,V.APE_VEN) VENDEDOR,
		V.SUE_VEN SUELDO,
		V.FIN_VEN [FECHA DE INICIO],
		D.NOM_DIS DISTRITO
		from VENDEDOR v 
		join DISTRITO d on d.COD_DIS=v.COD_DIS
	end 

EXEC pa_reporte
DROP procedure pa_reporte


create procedure pa_all_clienteXdistrito
as 
	begin 
		select d.NOM_DIS , count(c.COD_CLI) [TOTAL DE CLIENTES]
		from CLIENTE c  
		join DISTRITO d on d.COD_DIS= c.COD_DIS 
		group by d.NOM_DIS
	end 


EXEC pa_all_clienteXdistrito

if object_id('pa_all_clienteXdistrito') is not null
	begin 
		drop procedure pa_all_clienteXdistrito
	end


create procedure pa_producto(
	 @p char(10))
as 
	begin 
		select COD_PRO CODIGO,
			DES_PRO DESCRIPCION
			,PRE_PRO PRECIO,
			SAC_PRO [STOCK ACTUAL],
			SMI_PRO [STOCK MINIMO]
		from PRODUCTO
		WHERE @p=COD_PRO
	end 

exec pa_producto 'P001'

IF OBJECT_ID('pa_producto') is not null
	begin 
		drop procedure pa_producto 
	end 

sp_columns factura

create procedure pa_FacturaXyear(@year char(4))
as 
	begin 
		select year(FEC_FAC) [AÑO],
			COunt(*) [TOTAL DE FACTURAS]
		from FACTURA 
		where @year = year(FEC_FAC)
		GROUP BY year(FEC_FAC)
	end 

EXEC pa_FacturaXyear '2012'
if object_id('pa_FacturaXyear') is not null
	begin 
		drop procedure pa_FacturaXyear 
	end 



CREATE PROCEDURE pa_ClientesxDistrito(@distrito varchar(20))
as 
	begin 
		select c.COD_CLI CODIGO,
			C.RSO_CLI CLIENTE, 
			C.DIR_CLI DIRECCION,
			C.TLF_CLI TELEFONO,
			D.NOM_DIS DISTRITO,
			C.FEC_REG [FECHA DE REGISTRO]
		from CLIENTE c 
		join DISTRITO d on d.COD_DIS = c.COD_DIS
		WHERE @distrito = D.NOM_DIS
	end 


EXEC pa_ClientesxDistrito 'SAN MIGUEL'

IF OBJECT_ID('pa_ClientesxDistrito') IS NOT NULL
	BEGIN 
		DROP PROCEDURE pa_ClientesxDistrito 
	END
	


CREATE PROCEDURE pa_facturas_xMesYear(@anhio int ,   @mes int ) 
as 
	--begin
		select F.NUM_FAC NUMERO,
			F.FEC_FAC [FECHA FACTURADA],
			C.RSO_CLI CLIENTE, 
			F.FEC_CAN [FECHA CANCELACION],
			F.EST_FAC ESTADO,
			CONCAT_WS(' ',V.NOM_VEN,V.APE_VEN) VENDEDOR
		from FACTURA F
		JOIN CLIENTE C ON C.COD_CLI=F.COD_CLI
		JOIN VENDEDOR V ON v.COD_VEN=f.COD_VEN
		WHERE YEAR(F.FEC_FAC)=@anhio AND MONTH(F.FEC_FAC)=@mes
	--end
		
EXEC pa_facturas_xMesYear 2010,4


if object_id('pa_facturas_xMesYear') is not null
	begin 
	drop procedure pa_facturas_xMesYear
	print 'exito' 
	end




create procedure pa_register_clientS(
	@cod char(5),@rso char(30),@dir varchar(100),@tlf varchar(9),@ruc char(11),@cod_dis char(3),
	@fec_reg date,@tip_cli varchar(10), @con_cli varchar(30)
)
as 
	begin
		BEGIN TRY
			if exists(select * from DISTRITO where COD_DIS=@cod_dis)
				begin  
						insert into CLIENTE
						values(@cod,@rso,@dir,@tlf,@ruc,@cod_dis,@fec_reg,@tip_cli,@con_cli)
						PRINT 'CLIENTE REGISTRADO CORRECTAMENTE!'
				end
			ELSE 
				BEGIN 
					PRINT 'ERROR ESE CODIGO ' + CAST(@cod_dis as varchar) + ' no existe!'
				END 
		END TRY 
		BEGIN CATCH
			BEGIN 
				PRINT 'ERROR al registrar!'
			END 
		END CATCH

	end

IF OBJECT_ID('pa_register_clientS') IS NOT NULL
	BEGIN 
		DROP PROCEDURE pa_register_clientS 
	END 

EXEC pa_register_clientS 'C021','TAI LOY','AV. UNIVERSITARIA 3424','4529636','51551585745','D01',
						'25/10/2017','1','JUAN GARCIA'
SELECT *
FROM CLIENTE
where COD_CLI ='C021 '



select * from DISTRITO 
sp_columns distrito

if object_id('pa_registerNewDistrict') is not null
	begin 
		drop procedure pa_registerNewDistrict
	end 









---------------------------------------------
--pa que permita registrar un nuevo distrito; el 
--codigo del nuevo distrito debe generarse automaticamente
--y mostrar un mensaje de error si el distrito ya se encuentra
--registrado en la tabla

create procedure pa_newDistrito(
	@nombre varchar(30)
)
as 
BEGIN 
	
	set rowcount 1 --afectamos o devolvemos una sola fila 
	declare @cod char(5) 
	select @cod=RIGHT(trim(COD_DIS),2)--recortamos los digitos del codigo 
	from DISTRITO 
	order by COD_DIS desc
	declare @newCod char(5) = 'D' + cast(@cod+1 as char(3))--armamos el codigo
	if not exists (select * from DISTRITO where @nombre=NOM_DIS)--comprobamos si no existe el distrito
		begin
			insert into DISTRITO
			values(@newCod,@nombre)--registramos
			print 'DISTRITO REGISTRADO CORRECTAMENTE. ' 
		end
	else 
		begin 
			print 'error: el distrito ya esta registrado. ' --sino esta 
		end
END		

exec pa_newDistrito 'nuevo laredo'

if object_id('pa_newDistrito') is not null
	begin 
	 drop procedure pa_newDistrito
	end 


delete
from DISTRITO
where COD_DIS='D38'
--------------------------------------------------------------------------------



create procedure pa_totalFacturasXyear(
@year int, @total int output 
)
as 
	begin 
		
		if exists(select * from FACTURA where year(FEC_FAC)=@year)
			begin 
				select @total= count(*)
				from FACTURA 
				WHERE YEAR(FEC_FAC)=@year
				GROUP BY YEAR(FEC_FAC)
				PRINT 'EL TOTAL DE FACTURAS REGISTRADAS EN EL AÑO '+CAST(@year AS VARCHAR)+
				' ES '+CAST(@total as varchar)
			end
		else 
			print 'EL AÑO NO EXISTE! '
	end

declare @retorno int 
exec pa_totalFacturasXyear 2012,@retorno output 

select *
from FACTURA







--ejercicio

--calcular el impuesto predial de un año de un contribuyente en una año determinado

--El procedimiento de calculo es el siguiente :
--1.determinar el total de valuos(nVal_Tot) del contribuyente en el año 
--2.determinar el valor de la UIT en ese año 
--3.si la suma de valuos esta entre 0 y 15 UITs aplicar tasa de 0.2%     [0-15]
--	si la suma de valuos es menor a 60 UITs aplicar tasa de 0.6% a la diferencia <15-60>    
--	si la suma de valuos es mayor o igual a 60 uit aplicar tasa 1% tambien a la diferencia <60,60]   

create procedure pa_contribuyenteXanhio(
	@cod_cont char(11), @year int,@salida decimal(15,2) OUTPUT
)
as 
	begin 
		--varibles
		declare @uit decimal(15,2),
				@totalValuo decimal(15,2),@uitcal decimal(15,2)
		--1.determinar el total de valuos(nVal_Tot) del contribuyente en el año 
		if exists(select * from tValuos where cCod_Cont=@cod_cont and year(cAño)=@year ) 
			begin 
						select @totalValuo=sum(nVal_Tot)--calculamos el total para aquel contribuyente 
						from tValuos 
						where cCod_Cont=@cod_cont and year(cAño)=@year 
						group by cCod_Cont

						if exists(select * from tUIT where year(cAño)=@year)
						begin 
							select @uit=nUIT--calculamos el valor del uit para ese año
							from tUIT
							where year(cAño)=@year

							begin try 
					
								set @uitcal= @totalValuo / @uit

				
								if @uitcal between 0 and 15 
									begin
										set @salida = (( 15-@uitcal)*@uit*0.2)/100
									end 
								else if @uitcal < 60 
									begin 
										set @salida =(( 15-0)*@uit*0.2)/100  + (( 60-@uitcal)*@uit*0.6)/100
									end 
								else 
									begin
									set @salida =(( 15-0)*@uit*0.2)/100  + (( 60-15)*@uit*0.6)/100+
												(( @uitcal - 60)*@uit*1)/100		
									end

								print 'el impuesto a pagar para el contribuyente ' +cast(@cod_cont as varchar)+' en el año '+cast(@year as varchar)+' es de '+cast(@salida as varchar)


							end try 
							begin catch
						
								print 'Error :'+error_message()

							end catch
					
				end
				
			end 
		else 
			begin 
				print 'Erro!: no existen registros en el año o contribuyente mensionado! '
			end 
		
	end

declare @salida decimal (15,2)
exec pa_contribuyenteXanhio  '0009507',2009,@salida OUTPUT 




if object_id('pa_contribuyenteXanhio') is not null
	begin 
		drop procedure pa_contribuyenteXanhio
	end 

--================================================================================
create view v_vendedoreXMolina
as	
	select v.COD_VEN CODIGO,
			CONCAT_WS(' ',V.NOM_VEN,V.APE_VEN) NOMBRE,
			V.SUE_VEN SUELDO,
			V.FIN_VEN [FECHA DE INICIO],
			D.NOM_DIS DISTRITO
	from VENDEDOR v
	join DISTRITO d on d.COD_DIS=v.COD_DIS
	where d.NOM_DIS ='La Molina'

SELECT * FROM  v_vendedoreXMolina


IF OBJECT_ID('v_vendedoreXMolina') IS NOT NULL
	BEGIN 
		DROP VIEW v_vendedoreXMolina
	END 

CREATE VIEW v_facturacion 
as 
	select F.NUM_FAC NUMERO,c.RSO_CLI CLIENTE,
			P.DES_PRO PRODUCTO,
			(D.CAN_VEN*D.PRE_VEN) SUBTOTAL
	from FACTURA f 
	join CLIENTE c on f.COD_CLI=c.COD_CLI
	join DETALLE_FACTURA d on d.NUM_FAC = f.NUM_FAC
	join PRODUCTO p on d.COD_PRO=p.COD_PRO


SELECT *
FROM v_facturacion
WHERE CLIENTE ='COREFO'

SELECT *
FROM PRODUCTO



SELECT top 20 cCod_Cont codigo,
	cNombre nombre
into ##virtual
FROM tContribuyente


create table contribuyentes(
	codigo char(11),
	nombre varchar(100)

)


insert into contribuyentes(codigo,nombre) --tdestino
select codigo,nombre
from ##virtual


select *
from contribuyentes



