-- Declarar variables para recorrer los datos
DECLARE @Nombre VARCHAR(50), @Salario DECIMAL(10, 2);

-- Declarar el cursor
DECLARE empleados_cursor CURSOR FOR
SELECT Nombre, Salario FROM Empleados;

-- Abrir el cursor
OPEN empleados_cursor;

-- Recorrer los datos
FETCH NEXT FROM empleados_cursor INTO @Nombre, @Salario;
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Operaciones a realizar con los datos
    PRINT 'Empleado: ' + @Nombre + ', Salario: ' + CAST(@Salario AS VARCHAR(10));

    -- Obtener la siguiente fila
    FETCH NEXT FROM empleados_cursor INTO @Nombre, @Salario;
END

-- Cerrar el cursor
CLOSE empleados_cursor;

-- Liberar recursos del cursor
DEALLOCATE empleados_cursor;
----------------------------------------------------------EJERCICIOS DE TIGRES-------------------------------------------------------------------------



--Elaborar un trigger que cuando se actualice la columna 
--nVal_Tot de la tabla tValuos,actualice nVal_Tot de la tabla tImpuesto 
--sumando o restando el valor con el que se  actualizo en tValuos 
--madeley
create trigger tr_ActualizarValuo
ON tValuos
AFTER update
as
begin
	declare @valorReciente decimal(15,2);
	declare @valorAntiguo decimal(15,2);
	declare @cod char(11);
	declare @año char(4);


	select  @valorReciente = nVal_Tot, @cod=cCod_Cont, @año=cAño
	from inserted 
	
	select @valorAntiguo = nVal_Tot
	from deleted


	if UPDATE(nValTot) begin

			update tImpuesto
			set nVal_Tot =   nVal_Tot +  @valorReciente - @valorAntiguo
			where cCod_Cont = @cod and cAño = @año
		
	end
end;



select *
from timpuesto
where cCod_Cont='0016449' and cAño='2009'
--116503.33
select * from tValuos




--tValuos
select cCod_Cont,nVal_Tot
from tValuos
where cCod_Cont='0016449' and cAño='2009'
--150891.76


--cCod_Cont	nVal_Tot
--0016449    	20873.89
--0016449    	129017.87
--0016449    	1000.00
update tValuos
set nVal_Tot =+400
where cCod_Cont='0016449' and cAño='2009'
--se actualiza en tImpuesto
select nVal_Tot
from timpuesto
where cCod_Cont='0016449' and cAño='2009'

--Elaborar un trigger que cuando se actualice la columna 
--nVal_Tot de la tabla tValuos,actualice nVal_Tot de la tabla tImpuesto 
--sumando o restando el valor con el que se  actualizo en tValuos 

---profesor 
CREATE TRIGGER trValuosImpuesto on tValuos
AFTER UPDATE
AS
BEGIN
	declare @codigo char(11), @año char(4), @valant decimal(15,2), @valnue decimal(15,2)

	IF UPDATE(nVal_Tot)
	begin
		select @codigo=cCod_Cont, @año=cAño, @valnue=nVal_Tot
		from inserted 
		
		select @valant=nVal_Tot
		from deleted

		update tImpuesto
		set nVal_Tot=nVal_Tot+(@valnue-@valant)
		where cCod_Cont=@codigo and cAño=@año
	end	
END
