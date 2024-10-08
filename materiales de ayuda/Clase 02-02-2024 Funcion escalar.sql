
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

	set @deuda = ISNULL(@deuda, 0.00)
	-- Return the result of the function
	RETURN @deuda

END

--Probamos la función
select  distinct d.cCod_cont,  c.cNombre, d.cAño,
dbo.fncDeudaContribuyente(d.cCod_cont, d.cAño) Deuda
from tDeudas d
inner join tContribuyente c on d.cCod_cont = c.cCod_Cont 
where c.cCod_Cont = '0002107'    

select *
from tDeudas
