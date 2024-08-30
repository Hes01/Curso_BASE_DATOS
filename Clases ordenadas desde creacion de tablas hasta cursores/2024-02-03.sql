-----------------------------------------------------------------------------------------------
--------------------------FUNCIONES-----------------------------------------------------------
-----------------------------------------------------------------------------------------------

--00000000000000000000
---funciones escalares:devuelve un solo valor
--00000000000000000000

create FUNCTION [dbo].[fncDeudaContribuyente] 
(
	-- Add the parameters for the function here
	@codigo char(11), @año char(4)
)
RETURNS decimal(9,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @deuda decimal(9,2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @deuda = sum(nTributo+nReajuste+nInteres+nGasto)
	from tDeudas
	where cCod_cont = @codigo and caño = @año

	set @deuda = ISNULL(@deuda, 0.00)--se asigna el valor de deuda sino es nulo y si es nulo se asigna cero 
	
	RETURN @deuda-- Return the result of the function
END

--Probamos la función
select  distinct d.cCod_cont,  c.cNombre, d.cAño,
dbo.fncDeudaContribuyente(d.cCod_cont, d.cAño) Deuda
from tDeudas d
inner join tContribuyente c on d.cCod_cont = c.cCod_Cont 
where c.cCod_Cont = '0002107'    

select *
from tDeudas


--00000000000000000000
---funciones tabla en linea---:devuelve un conjunto de valores 
--00000000000000000000
create function fncMostrar(@codCont char(11))
returns table 
as 
return (
	select c.cNombre,sum(nTributo+nReajuste+nInteres+nGasto) deuda
	from tContribuyente c 
	join tDeudas d on c.cCod_Cont=d.cCod_cont 
	where c.cCod_Cont=@codCont
	group by c.cNombre
	)

select * from fncMostrar ('0002107')
	--que me devuelva el nombre de lugar y la deuda 
	--por año parametro 
create function fncMostrar_deudaxlugar(@año char(4))
returns table 
as 
return (
	
	select l.cNombre lugar, sum (d.nGasto+d.nInteres+d.nTributo+d.nReajuste) deuda
	from tContribuyente c
	join tLugares l on l.cCod_Lug=c.cCod_Lug
	join tDeudas d on d.cCod_cont = c.cCod_Cont
	where d.cAño=@año
	group by l.cNombre
	)

select * 
from fncMostrar_deudaxlugar ('2009')



--00000000000000000000
---funciones multisentencia---:devuelve una tabla
--00000000000000000000

create function fncMostrarDeudaOtro_multisentencia(@año char(11))
returns @resultaoCliente table (lugar varchar(100) ,deuda decimal(9,2))
as 
begin
	insert @resultaoCliente(lugar ,deuda)
	select l.cNombre lugar, sum (d.nGasto+d.nInteres+d.nTributo+d.nReajuste) deuda
	from tContribuyente c
	join tLugares l on l.cCod_Lug=c.cCod_Lug
	join tDeudas d on d.cCod_cont = c.cCod_Cont
	where d.cAño=@año
	group by l.cNombre
	return
end 


select *
from fncMostrarDeudaOtro_multisentencia ('2009')


------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--------------------------TRIGGERS-:desencadenan un procedimiento
------------------------------------------------------------------------------------------

--triger dml : manipulacion de datos tabla o vista 
--tigre ddl : lenguaje de definicion de datos 

--lo mas comun es dml : lo que veremos 
--uso: para temas de auditoria por ejm cuando se hacen modificaciones de datos 
--disparador para registrar por ejm : quien registro cambios o hizo cambios en una tabla






------TRIGER DML: se dispara cuando alguien hace un dml , insert delete o update 
--borrado logico : cambiar el estado del usuario por ejem: de a a i: de activo a inactivo 

--la sintaxis es:


--create trigger 


--tablas del sistema : inserted y deleted que son ?

--inserted: solo para insert y update ,cuando haga el cambio despues que haga el cambio despues se modifican 
--deleted: antes
--inserted : despues 

--no hay deleted porque hacer un update es como borrar primero y luego insertar 

--en el update se reflejan en deleted y inserted 

--en el delete solo se refleja en delete 
--y para el insert se refleja en inserted 

-------ejm: gaba un historico de saldos cada vez que se modifica un saldo de la tabla cuentas 

--create trigger tr_cuentas
--on cuentas 
--after update 
--as 
--begin 

--	set nocount on 
--	insert into hco_saldos(idcuenta,saldo,fxsaldo)
--	selectidcuenta, saldo ,getdate()
--	from inserted

--end


--como lo desencadenamos ?
--con un update 

--update cuentas
--set saldo= saldo +10
--where idcuenta=1

--si no afecta o hay error igualmente se ejecuta 


--con el traiger tambien se puede especificar para que columnas se disparan por ejm si se modifica la columna deuda entonces que se dispare

--create trigger tr_cuentas
--on cuentas 
--after update 
--as 
--begin 
	
--	set nocount on 
--	if update (saldo)--solo para la columna saldo se dispara 
--	begin
--		insert into hco_saldos(idcuenta,saldo,fxsaldo)
--		selectidcuenta, saldo ,getdate()
--		from inserted
--	end

--end


--dentro de nuestro trigger puede ponerse commandos de transacciones como rollback 

--ejm

--create trigger tr_cuentas
--on cuentas 
--after update 
--as 
--begin 
	 
	
--		insert into hco_saldos(idcuenta,saldo,fxsaldo)
--		selectidcuenta, saldo ,getdate()
--		from inserted
--		rollback 

--end

----causara errror: se anulo por lote 


--desabilitar un trigger
--				nombre_trigger	nombre tabla 
--disable trigger tr_cuentas on cuentas 

--activar 
--enable trigger tr_cuentas on cuentas 


--nota: en una tabla puedo tener varios triggers por necesidad no hay limites para diferentes situasiones
--ojo: a mayor de trigers mas lentitud pero es necesario 

	
--desactivar todos los triger de una tabla 
--			nombre_tabla
--alter table cuentas disable trigger all

--activar todos los trigger de una tabla 


--alter table cuentas enable trigger all


-------vamos a crear un trigger-------
--cada vez que modifique valtor que se guarde la hora el valorq ue se modifico

		create table AuditValuo (
		id int identity(1,1) primary key,
		cCod_cont char(11),
		cCod_Catas char(11),
		cNum_PU char(8),
		cAño char(4),
		valuo_ant decimal(15,2),
		valuo_nue decimal(15,2),
		usuario varchar(50),
		fecha datetime
	)



	create trigger tr_AuditValuo on tValuos 
	after update --despues de la insercion se dispara xd 
	as 
		begin 
			set nocount on --para evitar dialogos

			if update (nVal_Tot)
				begin 
					insert into AuditValuo
					select i.cCod_Cont,i.cCod_Catas,i.cNum_PU,i.cAño,d.nVal_Tot,i.nVal_Tot,system_user,getdate()
					from inserted i 
					join deleted d on i.cAño +i.cNum_PU=d.cAño+d.cNum_PU 
					
				end 
		end 

/*probamos con valores
para nVal_Tot=18000 para actualizar al codigo 0009507 y codigo de catas 01089401041 y 
num pu 00068958 y año 2009*/

--ahi le habia puesto 18000 pero como la jodi :v le arregle porque el verdadero valor es 13709.09
update tValuos
set nVal_Tot=13709.09
where cCod_Cont='0009507' and cCod_Catas='01089401041' and cNum_PU ='00068958' and cAño='2009'

truncate table AuditValuo 
select *from AuditValuo 