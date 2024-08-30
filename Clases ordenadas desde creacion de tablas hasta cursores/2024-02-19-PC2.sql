----PRACTICA CALIFICADA N°2
---------================================================================
alter table tDeudas add id int identity(1,1), 
pTributo numeric(11,2) default 0, pReajuste numeric(11,2) default 0, 
pInteres numeric(11,2) default 0, pGasto numeric(11,2) default 0,
pagado bit default 0

alter table tDeudas add constraint PK_tDeudas primary key (id)

drop table tPago
create table tPago 
(id int identity(1,1) primary key, 
cCod_cont char(11) not null,
cAño char(4) not null,
cCod_Trib char(7) not null,
idDeuda int not null,
nTributo numeric(11,2) default 0,
nReajuste numeric(11,2) default 0,
nInteres numeric(11,2) default 0,
nGasto numeric(11,2) default 0,
numRecibo int,
fechaPago datetime,
anulado bit default 0, 
constraint FK_tPago_tDeudas foreign key (idDeuda)
references tDeudas (id)
)



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER tr_Pagos
   ON  tPago 
   AFTER  INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @pTributo numeric(11,2), @pReajuste numeric(11,2),
	@pInteres numeric(11,2), @pGasto numeric(11,2),
	@idDeuda int, @anulado bit
    -- Insert statements for trigger here
	select @idDeuda = idDeuda, @pTributo = nTributo,
	@pReajuste = nReajuste, @pInteres = nInteres,
	@pGasto = nGasto
	from inserted
	IF NOT EXISTS(select * from deleted)	--Inserción
	BEGIN


		update tDeudas
		set pTributo = pTributo+ @pTributo, pReajuste = pReajuste+ @pReajuste,
		pInteres = pInteres+ @pInteres, pGasto = pGasto+ @pGasto
		where id = @idDeuda

		update tDeudas
		set pagado = 1
		where id = @idDeuda and 
		(nTributo+nReajuste+nInteres+nGasto) <= (pTributo+pReajuste+pInteres+pGasto)
	END
	ELSE
	BEGIN
		IF UPDATE(anulado)
		BEGIN
			select @anulado = anulado from inserted
			IF @anulado = 1 
			BEGIN
				update tDeudas
				set pTributo = pTributo- @pTributo, pReajuste = pReajuste- @pReajuste,
				pInteres = pInteres- @pInteres, pGasto = pGasto- @pGasto
				where id = @idDeuda

				update tDeudas
				set pagado = 0
				where id = @idDeuda and 
				(nTributo+nReajuste+nInteres+nGasto) >= (pTributo+pReajuste+pInteres+pGasto)
	
			END
		END
	END
END
GO

select top 100 * from tDeudas

create procedure paActualizaPago 
@idPago int=0, @idDeuda int=0, @numrecibo int=0, @fechaPago datetime='1900-01-01',
@pTributo numeric(11,2)=0, @pReajuste numeric(11,2)=0,
@pInteres numeric(11,2)=0, @pGasto numeric(11,2)=0, @anulado bit=0
AS
BEGIN
	IF @idPago = 0		--Inserción
		INSERT INTO [dbo].[tPago]
           ([cCod_cont],[cAño],[cCod_Trib],[idDeuda],[nTributo]
           ,[nReajuste],[nInteres],[nGasto],[numRecibo]
           ,[fechaPago])
		select cCod_cont, cAño, cCod_Trib, @idDeuda, @pTributo,
		@pReajuste, @pInteres, @pGasto, @numrecibo, @fechaPago
		from tDeudas
		where id = @idDeuda
	ELSE		--Actualizacion
		update tPago
		set anulado = @anulado
		where id = @idPago
END
select getdate()
2024-02-19 18:11:18.543
select cast('19-02-2024' as datetime)

select top 100 * from tDeudas

exec paActualizaPago 0, 5, 1, '19-02-2024 18:11:18.543', 
30, 0, 5, 7

select * from tPago

exec paActualizaPago 1, 0, 0, '01-01-1900', 
0, 0, 0, 0, 1
---------================================================================
--NOTA: SOBRE CURSORES----


--implementar pa_actualizacion:insercionl:update,tr:ver que tipo de triger voy a necesitar ,vistas: si necesito vistas,
--consultas que voy a realizar a menudo , y los cursores 


---CURSORES : Son como una especie de tablas que se cargan un conjunto de registros en una tabla 
--y puedo recorrerlos por eso el cursor se carga con un conjunto de datos obtenidos de un select 

--SINTAXIS 
--DECLARE CURSOR	NAME_CURSOR 
--FOR SELECT SENTENCIAS 


--insensitive: copiar temporal de datos 

--select_statement : es un select cualquiere que puede tener joins wheres...

--read only: cursor de solo lectura . No puedes hacer referencia de update delete 
----where current of : me da el registro actual donde yo estoy 

--local: el ambito del cursor es global o local 

--forward_only: especifica que solo el cursro se puede desplzar de la primera a la ultima fila.
----Fetch next es la unica opcion de captura admitida

--la instruccion OPEN: llena el conjunto de resultados 
--cada vez que se llena un cursor es necesario llenarlo , un cursor utiliza recursos de memoria 

--warning : el uso de cursores es solo para casos especiales porque utiliza recursos 


Ejm 1 : 
declare ven_cursor cursor 
for select * from Purchasing.vendor 
open ven_cursor --aqui se llena el cursor
fetch next from vend_cursor--la primera vez un registro 

Ejm 2:--los cursores tambien se pueden anidar para elaborar informes complejos 

declare @vendor id int , @vendor name nvarchar(50),@message varchar(80),@product nvarchar(50)

declare vendor_cursor cursor for 
select vendorID, Name 
from puvhcasing.vendor 
where preferredVendroStatus=1
order by vendorId;

open vendor_cursor

fetch next from vendro_cursor ---primer elemento 
into @ven--toma por cada fila del cursor un dato con el cual trabajar

0:correcto 
-1 o -2 : ya llegue al ultimo ya encontre fila o no habia una fila 





