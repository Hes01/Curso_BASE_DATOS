--procedimientos almacenados 
--estan almacenados fisicamente en la bd
---devuelvem un dato 
--su ejecucion
--sirven para llamarlos desde un programa por ejemplo para actualizar tablas

------------formato-------------------------------------------------------------

--se pone lo de abajo para saber sobre el procedimiento 
--============================
--autor: elvis
--fecha:<18-01-2024,si hubiera una modificaci�n,-->
--Descripcion:procedimiento para actualizar la tabla tUit
--============================
CREATE PROCEDURE [paActualizarUit] (@a�o char(4),@uit decimal(11,2) , @tipo char(1))
AS
	BEGIN --inicio del procedimiento 

		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
	
		-- Insert statements for procedure here
		if @tipo ='I'
		--begin --cuando voy a ejecutar varias lineas o sentencias 
			insert into tUIT (cA�o,nUIT)
			values (@a�o,@uit) 
		--end --cierre begin
		else 
		--clave primaria es el a�o por que el a�o no se puede repetir para el uit
			update tUIT  --para insertar como para modificar
			set nUIT =@uit 
			where cA�o = @a�o --para actualizar un a�o
	END --fin del procedimiento

drop procedure paActualizarUit --eliminar el procedimiento


execute   paActualizarUit '2024',5200,'A' --ejecutar el procedimiento almacenado 

select * from tUIT --vemos el la tabla tUit la Actualizaci�n 

sp_helptext paActualizarUit --para ver lo que contiene el procedimiento almacenado

--============================================================================================
--IMPLEMENTAR EL SIGUIENTE PROCEDIMIENTO ALMACENADO pa (paCalculaNuevoReaj) QUE HAGA LO SIGUIENTE 

--0000000000000000000000000000000000000000000000000000000000000000000
alter table tdeudas add --agregamos una columna a la tabla tdeudas 
nReajCalculado numeric(9,2) default 0
--0000000000000000000000000000000000000000000000000000000000000000000

--Actualizar nReajCalculado de la siguiente manera
--si la suma de deuda ntributo+nreajuste+ninteres+ngasto>n1
--el valor sera el p1% de esa suma
--si la suma de deuda esta entre n1 y n2
--el valor sera el p2% de esa suma 
--en caso contrario sera el p3%
--n1=500, n2=100,
--p1=1% 
--p2=0.5%
--p3=0.2%

--============================
--autor: elvis
--fecha:<18-01-2024,si hubiera una modificaci�n,-->
--Descripcion:procedimiento para actualizar la columna nReajCalculado de la tabla tDeudas segun la suma las deudas 
--============================
create procedure paActualizarnReajCalculado (@p1 decimal(11,2), @p2 decimal(11,2) ,@p3 decimal(11,2) ,@n1 decimal(11,2) ,@n2 decimal(11,2))
as 
	begin

	update tDeudas 
	set nReajCalculado=
	case when (nGasto+nInteres+nReajuste+nTributo) >@n1 then  (nGasto+nInteres+nReajuste+nTributo)*(@p1/100)
		 when (nGasto+nInteres+nReajuste+nTributo) between @n2 and @n1 then (nGasto+nInteres+nReajuste+nTributo)*(@p2/100)
	else 
			 (nGasto+nInteres+nReajuste+nTributo)*(@p3/100)	
	end

end

drop procedure paActualizarnReajCalculado
exec paActualizarnReajCalculado 1.0,0.5,0.2,500,100

select *,(nGasto+nInteres+nReajuste+nTributo) suma
from tDeudas
where (nGasto+nInteres+nReajuste+nTributo) between 100 and 500

--============================




	
		

	
	
