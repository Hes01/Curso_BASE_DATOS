--1.Agregar a la tabla tDeudas las siguientes columnas: Id del tipo int, Identity(1,1),
--pTributo, pReajuste, pinteres, pGasto, estas columnas se usarán para el registro de 
--los pagos que se hagan por cada uno de esos conceptos y por defecto tienen valor cero, 
--pagado de tipo bit para indicar si una fila de deuda ya está cancelada por defecto 
--tiene valor cero. Crear una tabla    tPago en la cual se registrarán los pagos de las
--deudas, debe contener las siguientes columnas: Id del tipo identidad, código del 
--contribuyente, año, codTrib, idDeuda (foránea de id de tDeudas), nTributo, nReajuste,
--ninteres, nGasto, numrecibo, fechapago, anulado del tipo bit (1: Anulado, 0: No anulado),
--por defecto cero. Crear una un disparador trPagos en la tabla tPago, el mismo que se 
--ejecuta cuando se hace un insert o update a esa tabla. Funcionará de la siguiente manera.

--a)	Cuando se hace Insert deberá actualizar en la tabla tDeudas los campos pTributo, 
--pReajuste, plnteres, pGasto, sumando los respectivos valores de la tabla tPago. Además 
--se debe verificar si en la tabla tDeudas las suma de nTributo+ninteres+nReajste+nGasto
--es menor o igual a pTributo+pinteres+pReajste+pGasto, deberá cambiar el campo 
--pagado a 1, para indicar que esa deuda ya está pagada.

--b)	Cuando se haga Update: Si el campo anulado cambia a 1 (se anula el recibo),entonces
--en tDeudas deberá restar a las columnas pTributo, plnteres, pReajste, pGasto los valores
--que hay en ese registro del recibo anulado. También debe verificar en la tabla tDeudas
--que si el campo pagado está en 1, volverlo a cero si no se cumple la condición por
--la cual se cambió a 1 en el momento que se hizo la inserción al pago.

use vorkov

CREATE TABLE tDeudas(
	cCod_cont char(11) NOT NULL,
	cAño char(4) NOT NULL,
	cCod_Trib char(7) NOT NULL,
	nTributo numeric(11, 2) NULL,
	nReajuste numeric(11, 2) NULL,
	nInteres numeric(11, 2) NULL,
	nGasto numeric(11, 2) NULL,
	nReajCalculado numeric(9, 2) NULL
)

alter table tDeudas add
id int identity(1,1),
pTributo numeric(11, 2) default 0,
pReajuste numeric(11, 2) default 0,
pInteres numeric(11, 2) default 0,
pGasto numeric(11, 2) default 0,
pagado bit default 0 
--pk
alter table tDeudas add
constraint pk_id_tDeudas primary key clustered (id asc)

create table tPago(--registrar aqui los pagos de las deudas 
	id int identity(1,1) primary key,--PRIMARY KEY
	cCod_Cont char(11) not null,
	cAño char(4) not null,
	codTrib char(7) not null,
	idDeuda int references tDeudas(id),
	nTributo numeric(11, 2) default 0,
	nReajuste numeric(11, 2)default 0 ,
	nInteres numeric(11, 2) default 0,
	nGasto numeric(11, 2)default 0 ,
	numrecibo int,
	fechapago datetime,
	anulado bit default 0 --0:anulado ó 1:no anulado
)


create trigger trPagos 
on tPago 
after insert,update
as 
begin 
	if not exists(select * from deleted )--insert
	begin 
		update tDeudas 
		set pTributo+=d.nTributo,pReajuste+=d.nReajuste,pInteres+=d.nInteres,pGasto+=d.nGasto
		from tDeudas d
		join inserted i on i.idDeuda=d.id--los ultimos son los valores de tpago
		--verificamos la suma de deudas en tdeudas n es menor igual a p
		declare @n numeric(11,2),@p numeric(11,2)


		select @n=d.nTributo+d.nInteres+d.nReajuste+d.nGasto ,
		@p=d.pTributo+d.pInteres+d.pReajuste+d.pGasto
		from tDeudas d
		join inserted i on i.idDeuda=d.id

		if(@n <=@p)
			begin 
				update tDeudas
				set pagado=1
				from tDeudas d 
				join inserted i on i.idDeuda=d.id
			end
	end
	else 
	begin--update  
		declare @anulado bit 
		select @anulado=d.anulado
		from tPago d 
		join deleted i on i.idDeuda=d.idDeuda

		if(@anulado=1)
		begin 
			update tDeudas
			set pTributo-=d.nTributo,pReajuste-=d.nReajuste,pInteres-=d.nInteres,pGasto-=d.nGasto
			from tPago d 
			join inserted i on i.idDeuda=d.idDeuda--los ultimos son los valores de tpago 
		end

		declare @pagado bit 
		select @pagado=pagado
		from tDeudas d 
		join deleted i on i.idDeuda=d.id

		if(@pagado=1)
		begin 
			update tDeudas
			set pagado = 0
			from tDeudas d 
			join inserted i on i.idDeuda=d.id--los ultimos son los valores de tpago 
		end
	end
end



--2.Elaborar un procedimiento almacenado paActualiza Pago que permita hacer 
--la actualización de la tabla tPago. Se pasan como parámetros el id del pago,
--iddeuda, numrecibo, fechapago, pTributo, pinteres, pReajuste, pGasto, anulado.
--Cuando el id del pago es cero entonces quiere decir que se va a hacer  una
--inserción, con el iddeuda se obtienen las otras columnas que se requieren 
--desde la tabla tDeudas. Cuando el id del pago es diferente de cero, quiere 
--decir que se va a hacer una actualización, por un tema de seguridad las 
--actualizaciones sólo se pueden hacer a la columna anulado, entonces se 
--pasará en el parámetro anulado el valor de 1, entonces los únicos parámetros 
--que se requieren son el id de pago y anulado. Todos los parámetros pueden tener
--valores por defecto, 0 para los números, espacio vacío (") 
--para los char y 01/01/1900 para la fecha.
create procedure paActualizaPago(@idPago int=0 , @iddeuda int=0,@numrecibo char(12)='',
	@fechapago date='01-01-1990',@pTributo numeric(11,2)=0,@pInteres numeric(11,2)=0,@pReajuste numeric(11,2)=0,
	@pGasto numeric(11,2)=0,@anulado bit=0)
as 
begin 
	if(@idPago=0)--insercion
	begin 
		insert into tPago
		select cCod_cont,cAño,cCod_Trib,@iddeuda,@pTributo,@pReajuste,d.nInteres,@pGasto,@numrecibo,@fechapago,@anulado
		from tDeudas d
		where @idPago=d.id
	end
	else 
	begin
	if exists(select * from tPago where id=@idPago )---<<<<<<<<<---
	begin 
		update tPago 
		set anulado=@anulado,idDeuda=@idPago 
		from tPago p
		where id=@idPago
	end
	else
	begin 
		raiserror('no se encontro registro para actualizar',1,20)
	end
	end
end