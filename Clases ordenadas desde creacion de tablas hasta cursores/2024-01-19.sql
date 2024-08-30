--TRANSAC SQL 

--CAPTURA DE ERRORES CON SP(STOREDPROCEDURE)

--IF_ELSE
--WHILE 
--DECLARE 
--SET 
--BATCHES 

--DESCRIPCION DE LOTES: EL LOTE TEMINA CON LA INSTRUCCION O TERMINADOR DE LOTE QUE ES GO 

----DECLARACION Y ASIGNACION DE VARIABLES 
--EJM
--DECLARE @ENTERO INT = 3
--TAMBIEN PUEDE SER 

--DECLARE @ENTERO INT
--SET @ENTERO=90 

--BLOQUES IF Y WHILE :REPASAR EL BLOQUE WHILE 
--BREAK, CONTINUE , WAIFOR Y RETURN : REPASAR 

--OBJECT_ID():ESTA FUNCION ES PARA VER SI UNA TABLA EXISTE 

--EL EXISTS ES PARA VER SI POR EJEMPLO DATOS DE UNA TABLA SI EXISTEN 

--============================EJM========================================


SELECT OBJECT_ID('tDeudas')

if exists(select * from tDeudas where cCod_cont='999999')
	print 'existe'
else 
	print 'no existe '

--ejercicio

--calcular el impuesto predial de un año de un contribuyente en una año determinado

--El procedimiento de calculo es el siguiente :
--1.determinar el total de valuos(nVal_Tot) del contribuyente en el año 
--2.determinar el valor de la UIT en ese año 
--3.si la suma de valuos esta entre 0 y 15 UITs aplicar tasa de 0.2%     [0-15]
--	si la suma de valuos es menor a 60 UITs aplicar tasa de 0.6% a la diferencia <15-60>    
--	si la suma de valuos es mayor o igual a 60 uit aplicar tasa 1% tambien a la diferencia <60,60]   

if object_id('pa_contribuyenteXanhio') is not null
	begin 
	drop procedure pa_contribuyenteXanhio
	end

--uit=5150
create procedure pa_contribuyenteXanhio	
							(@cod char(11),@year int,@result numeric(15,2) output )
as 
	begin --declaramos las variables
		 --@uit para obtener el uit segun el año de la tabla tUit 
		 --@valuototal para obtener la suma del valuo total de ese contribuyente 
		 --@uitValuo para sacar el uit segun el total y poder ver el rango en el que se encuentra
		declare @uit numeric(15,2), @valuototal numeric(15,2),@uitValuo numeric(15,2),@uitFinal numeric(15,2)
		-----
		--1.determinamos el total de valuos(nVal_Tot) del contribuyente en el año 
		select @valuototal=sum(v.nVal_Tot)
		from tvaluos v
		--join tContribuyente c on c.cCod_Cont = v.cCod_Cont --que coincidan los contribuyentes 
		where year(v.cAño)=@year and v.cCod_Cont=@cod --ademas solo filtramos donde los de valuos son iguales al codigo 
		group by v.cCod_Cont--agrupamos porque estamos usando una funcion de agregado
		------
		select @uit=nUIT
		from tUIT
		where year(cAño)=@year

		set @uitValuo=@valuototal/@uit

		---almacenamos

		--set @uitFinal=
		--case when @uitValuo between 0 and 15  then (( (15-@uitValuo)*0.2 )/100) 
		--	when @uitValuo between 14 and 59 then (( (15-0)*0.2 )/100)+(( (60-@uitValuo)*0.6 )/100)--14-59
		--	when @uitValuo >= 60 then  ( ((15-0)*0.2) /100)+(( (60-15)*0.6) /100)+( (@uitValuo-60) /100) 
		--end

		if @uitValuo between 0 and 15
			begin
				set @uitFinal= (( (15-@uitValuo)*0.2 )/100)
			end
		else if @uitValuo < 60
			begin 
				set @uitFinal=(( (15-0)*0.2 )/100)+(( (60-@uitValuo)*0.6 )/100)
			end
		else 
			set @uitFinal=( ((15-0)*0.2)*@uit /100)+(( (60-15)*0.6)*@uit /100)+( (@uitValuo-60)*@uit /100) 
		--finalmente el impuesto
		set @result =@uitFinal	
	end 
	--2307.50 con el tcontribuyente 
	

declare @output decimal(15,2)
exec pa_contribuyenteXanhio '0009507',2009,@output output
print @output

select   0.6463350985900*3550.00 

drop procedure pa_contribuyenteXanhio


--===================pruebas========================


--suma de valuos para año 2009 y codigo '0009507'
declare @deci decimal(15,2)
select  @deci = sum(v.nVal_Tot)
		from tvaluos v
		join tContribuyente c on c.cCod_Cont = v.cCod_Cont --que coincidan los contribuyentes 
		where year(v.cAño)=2009 and '0009507' =v.cCod_Cont--ademas solo filtramos donde los de valuos son iguales al codigo 
		group by c.cCod_Cont,v.cCod_Cont--agrupamos porque estamos usando una funcion de agregado
		print @deci --335948.96

		------encontramos el uit para el año 2009
		declare @deci decimal(15,2)
		select  @deci = nUIT
		from tUIT
		where year(cAño)=2009
		print @deci-- 3550.00

		------vemos el rango en el que esta el totalvaluo 
		declare @deci decimal(15,2)
		select  @deci=335948.96/3550.00 
		print @deci--rango del valuo en uit -- = 94.63

		-----finalmente el impuesto es :
		declare @deci decimal(15,2)
		select @deci =( ((15-0)*0.2)*3550.00 /100)+( ( (60-15)*0.6)*3550.00 /100)+( (94.63 -60)*3550.00 /100) 
		print @deci--2294.37

--===========================================


--22-01-2024


--valores default se declaran al final 

--ejm: @param numeric(8,3) default 0;


--validaciones de ciertos datos con el exists 
--
--ejm 
--if not exists(select *form tabla where condicion)


--===================================================================================================================
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
--=================================================================================