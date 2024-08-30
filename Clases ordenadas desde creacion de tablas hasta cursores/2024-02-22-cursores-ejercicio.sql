codigo nombre 
año totalDeuda


sp_columns tcontribuyente
sp_columns tdeudas


declare @codigo char(11),@nombre varchar(100)
declare c_tcontribuyente cursor --aqui 
for 
select distinct top 100  c.cCod_Cont,d.cNombre
from tDeudas  c
join 
	( 
	select distinct cCod_cont,cNombre
	from  tContribuyente
	) d on d.cCod_cont =c.cCod_Cont
open c_tcontribuyente --abrimos el cursor 
fetch c_tcontribuyente into @codigo ,@nombre--el primer registro  
while @@FETCH_STATUS = 0 --recorremos para c_tcontribuyente ,si aqui <> 0
begin 
	print 'codigo: '+@codigo +space(5) +'nombre: '+@nombre 
	print replicate('-',71)
	declare @año char(4),@total_deuda decimal(11,2)
	declare c_tdeudas cursor 
	for 
		--select d.cAño,d.total
		--from tContribuyente c--esta demas tcontribuyente 
		--join 
		--( 
		select  cAño, SUM(nTributo+nReajuste+nInteres+nGasto) total
		from tDeudas 
		where cCod_cont =@codigo
		group by cAño
		--) d on d.cCod_cont =c.cCod_Cont
		--where d.cCod_cont =@codigo
	open c_tdeudas 
	fetch c_tdeudas into @año , @total_deuda
	print 'año     total de deuda'
	while @@FETCH_STATUS =0
	begin 
		
		print @año+space(5)+cast(@total_deuda as varchar(50))
		fetch c_tdeudas into @año , @total_deuda
	end 
	fetch c_tcontribuyente into @codigo ,@nombre 
	close c_tdeudas
	deallocate c_tdeudas 
	print ''
end
close c_tcontribuyente
deallocate c_tcontribuyente 
---------------------profesor ----------------------------------------------------
codigo : nombre: añoimpuesto: totalImpuesto : , nimpre caño


 