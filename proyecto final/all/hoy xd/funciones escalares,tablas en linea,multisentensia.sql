---funciones escalares 

if object_id('fn_subtotal') is not null
	begin
		drop function fn_subtotal
	end


select *
from DETALLE_FACTURA
--FE
--ejm1
create function fn_subtotal(@var numeric(9,3))
returns numeric(9,3)
as 
	begin
		
		return @var*0.12
	end

	select NUM_FAC factura, dbo.fn_subtotal(PRE_VEN) subtotal
	from DETALLE_FACTURA 
--ejm2
--FE
select dbo.fn_distrito('D19')
from DISTRITO

create function fn_distrito(@var char(3))
returns varchar(100)
as
	begin	
		declare @var1 varchar(50),
			@msm varchar(100)

				select @var1=NOM_DIS
				from DISTRITO 
				where COD_DIS=@var

		if exists (select * from DISTRITO where COD_DIS=@var)
			begin 
				set @msm = 'El distrito para el codigo '+ @var +' es : '+@var1
			end
		else 
			begin
				set @msm = 'El distrito buscado no se encontro :c'
			end
		return @msm
	end

--FE

if object_id('fn_date_abc') is not null
	begin
		drop function fn_date_abc
	end

create function fn_date_abc(@var date)
returns char(2)
as 
	begin 
		declare @letra char(2) ='X'
		if exists(select * from FACTURA where FEC_FAC=@var)
			begin  
				select	@letra = case when month(@var)=1 then  'EN' 
								when month(@var)=2 then  'FE' 
								when month(@var)=3 then  'MA' 
								when month(@var)=4 then  'AB' 
								when month(@var)=5 then  'MA' 
								when month(@var)=6 then  'JU' 
								when month(@var)=7 then  'JA' 
								when month(@var)=8 then  'AG' 
								when month(@var)=9 then  'SE' 
								when month(@var)=10 then  'OC' 
								when month(@var)=11 then  'NO' 
								when month(@var)=12 then  'DI' END
				
			end

			RETURN @letra
	end 

SELECT DBO.fn_date_abc(FEC_FAC) FECHA
FROM FACTURA 
--FTL
--RETORNAN UN CONJUNTO DE VALORES 
if object_id('fn_productos') is not null
	begin 
		drop function FN_PRODUCTOS
	end


CREATE FUNCTION fn_productos()
returns table 
as
	return(
		select p.COD_PRO codigo,p.DES_PRO
		from PRODUCTO p
	)

select *
from dbo.fn_productos()

--ejm2 , FTL

CREATE FUNCTION fn_clienteBYdistrito(@cod char(5))
returns table 
as 
	return(
		select c.COD_CLI codigo ,c.RSO_CLI cliente 
		from CLIENTE c 
		where c.COD_DIS =@cod
	)
select *
from DISTRITO

select *
from dbo.fn_clienteBYdistrito('D05')


---tabla multisentencia

create function fn_Mul_distrito()
returns @tabla table(cod char(5), nom varchar(50))
as 
	begin 
		insert into @tabla
		select COD_DIS,NOM_DIS
		from DISTRITO
		return
	end

select *
from  dbo.fn_Mul_distrito()

--
if object_id('fn_info') is not null
	begin 
		drop function fn_info
	end

create function fn_info(@var varchar(10))
returns @tabla table(cod char(5), nombre varchar(50))
as 
	begin 

		IF @var ='DISTRITO' 
			BEGIN 
				insert into @tabla 
				select COD_DIS,NOM_DIS
				from DISTRITO 
			END
		ELSE IF @var ='CLIENTE'  
			BEGIN 
				insert into @tabla 
				select COD_CLI,RSO_CLI
				from CLIENTE 
			END
		ELSE IF @var ='VENDEDOR' 
			BEGIN
				insert into @tabla 
				select COD_VEN,CONCAT_WS(' ',NOM_VEN,APE_VEN) NOMBRES
				from VENDEDOR 
			END
		return
	end

select *
from dbo.fn_info('DISTRITO')
