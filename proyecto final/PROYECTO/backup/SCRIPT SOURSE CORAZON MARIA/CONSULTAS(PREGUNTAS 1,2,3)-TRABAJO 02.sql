--1. Procedimientos almacenados para la inserción y modificación de las tablas del sistema,
--dichos procedimientos deberán tener como nombre paActualizaTabla, donde Tabla es
--el nombre de cada una de las tablas. Tener en cuenta que un mismo procedimiento se
--usará para Insert y Update.

---1.PersonaNatural

CREATE PROCEDURE paActualizaPersonaNatural--update si existe y sino insert
(
    @idPersonaNatural SMALLINT,
    @idPersona SMALLINT,
    @nombre VARCHAR(100),
    @apPat VARCHAR(50),
    @apMat VARCHAR(50),
    @dni CHAR(8)
)
AS
BEGIN
	--comprobamos que exista persona por su idPersona 
	IF EXISTS ( select 1 from Persona where idPersona = @idPersona) 
	begin
		--Comprobamos que no exista una referencia de persona en persona natural
		IF NOT EXISTS ( select 1 from PersonaNatural where idPersona = @idPersona) 
		BEGIN
			--Comprobamos que en persona natural exista un registro con @idPersonaNatural
			 IF EXISTS (select 1 from PersonaNatural where idPersonaNatural = @idPersonaNatural)
			 --Si existe entonces se realiza actualización
			 BEGIN
				--Actualización
				UPDATE PersonaNatural
				SET 
				 idPersona = @idPersona,
				 nombre = @nombre,
				 apPat = @apPat,
				 apMat = @apMat,
				 dni = @dni
				WHERE idPersonaNatural = @idPersonaNatural
			 END
			 ELSE 
			--Sino existe se realiza inserción
			 BEGIN
			 --Inserción
				INSERT INTO PersonaNatural(idPersona, nombre, apPat, apMat, dni)
				VALUES (@idPersona, @nombre, @apPat, @apMat, @dni);
			 END
		END
		--Existe registro con idPersona
		ELSE
		BEGIN
			PRINT 'Ya se registro el idPersona pasado como parámetro, utilice otro'
		END
	END
		PRINT 'idPersona pasado como parámetro no se encuentra en la tabla Persona'
END


---2.Persona Juridica

CREATE PROCEDURE paActualizaPersonaJuridica--update si existe sino insert
(
    @idPersJuridica SMALLINT,
    @idPersona SMALLINT,
    @razonSocial VARCHAR(150)
)
AS
BEGIN
	--comprobamos si existe persona
	IF EXISTS (select 1 from Persona where idPersona = @idPersona)
	BEGIN
		--comprobamos, si no existe persona que sea persona juridica
		IF NOT EXISTS ( select 1 from PersonaJuridica where idPersona = @idPersona)
		BEGIN	--comprobamos si existe persona juridica
				IF EXISTS (select 1 from PersonaJuridica where idPersJuridica = @idPersJuridica)
				BEGIN
					--ACTUALIZACIÓN
					UPDATE PersonaJuridica
					SET 
						  idPersona = @idPersona,
						  razonSocial = @razonSocial
					WHERE idPersJuridica = @idPersJuridica;
				END
				--sino existe insertar
				ELSE
				BEGIN
					--INSERCIÓN
					INSERT INTO PersonaJuridica(idPersona, razonSocial)
					VALUES (@idPersona, @razonSocial)
				END
		END
		ELSE 
		--si existe persona que sea persona juridica
		BEGIN
			PRINT 'Ya se existe ese idPersona en la tabla'
		END
	END 
	--sino existe dicha persona
	ELSE 
	BEGIN
		PRINT 'No existe idPersona en Persona'
	END
END


---3.Telefono
CREATE PROCEDURE paActualizarTelefono --update si existe , insert si no existe
	@id smallint,
	@numtelefono char(9)
as
begin
	DECLARE @numtelefonoA varchar(40)
	--si existe telefono se hace UPDATE
	IF EXISTS (select 1 from Telefono where idTelefono = @id) 
		begin
			select @numtelefonoA = numeroTelefono
			from Telefono 
			where idTelefono = @id
			--Actualización cuando sea distinto
			IF @numtelefono <> @numtelefonoA  
			BEGIN
				--Actualizamos
				Update Telefono
				set numeroTelefono = @numTelefono
				where idTelefono = @id
			END
		END
	ELSE
		--sino existe insertamos 
		BEGIN
			--Insertamos
			Insert into Telefono(numeroTelefono)
			values (@numTelefono)
		END
END

DROP PROCEDURE paActualizarTelefono

---4. Persona
CREATE PROCEDURE paActualizaPersona
    @idPersona SMALLINT,
    @idTelefono SMALLINT,
    @email VARCHAR(50),
    @direccion VARCHAR(150),
    @ruc CHAR(11)
as
begin
	--verificamos que telefono exista
	IF EXISTS(select 1 from Telefono where idTelefono=@idTelefono) 
	begin
		--si no existe telefono asignado a persona
		IF NOT EXISTS(select 1 from Persona where idTelefono=@idTelefono) --el telefono es not null si existe siempre
		begin
				--si existe persona
				IF EXISTS(select 1 from Persona where idPersona=@idPersona)
				begin
						---Actualizar, asignando telefono a esa persona
						UPDATE Persona
						SET idTelefono=@idTelefono,
							email=@email,
							direccion=@direccion,
							ruc=@ruc
						WHERE idPersona=@idPersona
				END
				--sino existe persona insertamos y le asignamos telefono
				ELSE
						BEGIN
							---Inserción
							INSERT INTO Persona
							VALUES(@idTelefono,@email,@direccion,@ruc)
						END
		END
		--si existe telefono asignado a persona
		ELSE BEGIN
				
				PRINT 'YA SE ENCUENTRA DICHA PERSONA'
		END
	END
	ELSE BEGIN
		PRINT 'ERROR, VERIFIQUE LA EXISTENCIA DE REGISTRO DE TELEFONO!'
	END
END


---5.Tipo Proveedor
CREATE PROCEDURE paActualizaTipoProveedor
	@id tinyint,
	@nombre  varchar(40)
as
begin
	DECLARE @nombreA varchar(40)
	IF EXISTS (select 1 from tipoProveedor where idtipoProveedor = @id) 
	BEGIN
		select @nombreA = nombre
		from tipoProveedor 
		where idtipoProveedor = @id
		--Actualización
		IF @nombre <> @nombreA
		BEGIN
			UPDATE tipoProveedor
			set nombre = @nombre
			where idtipoProveedor = @id
		END
	ELSE
	BEGIN
		--Inserción
		IF NOT EXISTS (select 1 from tipoProveedor where nombre = @nombre) 
		BEGIN
			insert into tipoProveedor (nombre)
			values(@nombre)
		END
		ELSE
		BEGIN
			PRINT'Ya se ha registrado ese tipo de proveedor'
		END
	END
END

===========================================================
---6.Proveedor
CREATE PROCEDURE paActualizaProveedor
	@idProveedor smallint,
	@idPersona smallint,
	@idtipoProveedor tinyint
as
begin
	declare @idPersonaA smallint, @idtipoProveedorA tinyint
	
		--Se verifica la existencia de idPersona en Persona
		IF EXISTS (select 1 from Persona where idPersona = @idPersona ) 
		BEGIN
			--Se verifica la existencia de idtipoProveedor en Proveedor
			IF EXISTS (select 1 from tipoProveedor where idtipoProveedor = @idtipoProveedor) 
			BEGIN
						--Se verifica que el idPersona, no se encuentre en la tabla Proveedor
						--Ya que por cada proveedor, tendrá distinto idPersona
						IF NOT EXISTS (SELECT 1 FROM PROVEEDOR WHERE idPersona = @idPersona) 
						BEGIN
								---Comprobamos la existencia del id, si existe, se trataria de una actualización
								IF EXISTS (select 1 from Proveedor where idProveedor = @idProveedor)
								BEGIN
									--Se realiza la actualizacion
									UPDATE Proveedor
									SET idPersona = @idPersona,
									idtipoProveedor = @idtipoProveedor
									WHERE idProveedor = @idProveedor
								END
								ELSE
								BEGIN
									insert into Proveedor (idPersona, idtipoProveedor)
									values (@idPersona, @idtipoProveedor)
								END
						END
						ELSE
						BEGIN
							PRINT 'YA SE ENCUENTRA REGISTRADO ESE idPersona'
						END
			END
			ELSE
			BEGIN
				PRINT 'El idtipoProveedor pasado como parámetro, no se encuentra registrado en tipoProveedor'
			END
		END
		ELSE
		BEGIN
			PRINT 'El idPersona pasado como parámetro, no se encuentra registrado en Persona' 
		END
END


---7. CARGO
CREATE PROCEDURE paActualizaCargo
	@idCargo tinyint,
	@nombre varchar(50)
as
begin
	IF EXISTS (select 1 from Cargo where idCargo = @idCargo) 
		--Actualizacion
		UPDATE Cargo
		SET nombre = @nombre
		WHERE idCargo = @idCargo
	ELSE
		IF NOT EXISTS(select 1 from Cargo where nombre = @nombre) 
		BEGIN
			insert into Cargo (nombre)
			values(@nombre)
		END
		ELSE
		BEGIN
			PRINT 'El nombre del cargo, ya se encuentra registrado'
		END
END

---8.EMPLEADO
CREATE PROCEDURE paActualizaEmpleado
	@idEmpleado SMALLINT,
   	@idCargo TINYINT,
   	@idPersona SMALLINT,
   	@fechaIngreso DATE,
   	@fechaCese DATE,
   	@estado CHAR(1) 
as
begin
	IF EXISTS(select 1 from Cargo where idCargo = @idCargo )
	BEGIN
		IF EXISTS(select 1 from Persona where idPersona = @idPersona) 
		BEGIN
			IF NOT EXISTS(select 1 from Empleado where idPersona = @idPersona) 
			BEGIN
				IF EXISTS(select 1 from Empleado where idEmpleado = @idEmpleado)
				BEGIN
					--Actualización
					UPDATE Empleado
					SET idCargo = @idCargo,
						idPersona = @idPersona,
						fechaIngreso = @fechaIngreso,
						fechaCese = @fechaCese,
						estado = @estado
					WHERE idEmpleado = @idEmpleado
				END
				ELSE
				BEGIN
					INSERT INTO Empleado(idCargo,idPersona,fechaIngreso,fechaCese,estado)
					VALUES(@idCargo,@idPersona,@fechaIngreso,@fechaCese,@estado)
				END
			END
			ELSE
			BEGIN
				PRINT 'Ya se encuentra registrado el idPersona pasado como parámetro en Empleado'
			END
		END
		ELSE
		BEGIN
			PRINT 'idPersona NO REGISTRADO en Persona'
		END
	END
	ELSE
	BEGIN
		PRINT 'idCargo NO REGISTRADO en Cargo'
	END
END


---9.PAGOS
CREATE PROCEDURE paActualizaPago 
	@idPagos SMALLINT,
   	@idEmpleado SMALLINT,
   	@monto NUMERIC(7,2),
   	@fecha DATE 
as
begin
	IF EXISTS(select 1 from Empleado where idEmpleado = @idEmpleado) 
	BEGIN
		IF EXISTS(select 1 from Pagos where idPagos = @idPagos) 
		BEGIN
			---Actualización
			UPDATE Pagos
			SET idEmpleado = @idEmpleado,
				monto = @monto,
				fecha = @fecha
			WHERE idPagos = @idPagos
		END
		ELSE
		BEGIN
			INSERT INTO Pagos(idEmpleado, monto, fecha)
			VALUES(@idEmpleado, @monto,@fecha)
		END
	END
	ELSE
	BEGIN
		PRINT 'idEmpleado pasado como parámetro, no registrado en Empleado'
	END
END

---10.CategoriaMateriaPrima 
CREATE PROCEDURE paActualizaCategoriaMP
	@idCategoriaMateriaPrima tinyint,
	@nombre varchar(50)
as
begin
	IF EXISTS (select 1 from CategoriaMateriaPrima where idCategoriaMateriaPrima=@idCategoriaMateriaPrima) 
	BEGIN
		--Actualizar
		UPDATE CategoriaMateriaPrima
		SET nombre = @nombre
		WHERE  idCategoriaMateriaPrima=@idCategoriaMateriaPrima
	END
	ELSE
	BEGIN
		IF NOT EXISTS (select 1 from CategoriaMateriaPrima where nombre = @nombre) 
		BEGIN
			INSERT INTO CategoriaMateriaPrima(nombre)
			VALUES (@nombre)
		END
		ELSE
		BEGIN
			PRINT 'Nombre de la categoria, ya se encuentra registrada'
		END
	END
END
==================================================

---11.Materia Prima
CREATE PROCEDURE paActualizaMateriaPrima
	@idMateriaPrima SMALLINT,
    @idCategoriaMateriaPrima TINYINT,
    @nombre VARCHAR(150)
as
begin
	IF EXISTS(select 1 from CategoriaMateriaPrima where idCategoriaMateriaPrima = @idCategoriaMateriaPrima) 
	BEGIN
		IF EXISTS(select 1 from MateriaPrima where idMateriaPrima = @idMateriaPrima) 
		BEGIN
			IF NOT EXISTS(select 1 from MateriaPrima where nombre = @nombre) 
			BEGIN
				--Actualización
				UPDATE MateriaPrima
				SET idCategoriaMateriaPrima = @idCategoriaMateriaPrima,
					nombre = @nombre
				WHERE idMateriaPrima = @idMateriaPrima
			END
			ELSE
			BEGIN
				PRINT 'YA SE REGISTRÓ DICHA MATERIA PRIMA'
			END
		END
		ELSE
		BEGIN
			INSERT INTO MateriaPrima(idCategoriaMateriaPrima, nombre)
			VALUES(@idCategoriaMateriaPrima,@nombre)
		END
	END
	ELSE
	BEGIN
		PRINT 'idCategoriaMateriaPrima no tiene registro en CategoriaMateriaPrima'
	END
END

---12.TipoArticulo
CREATE PROCEDURE paActualizaTipoArticulo
	@idTipoArticulo tinyint,
	@nombre varchar(40)
as
begin
	IF EXISTS(select 1 from TipoArticulo where idTipoArticulo=@idTipoArticulo) BEGIN
		--Actualización
		UPDATE TipoArticulo
		SET nombre = @nombre
		where idTipoArticulo=@idTipoArticulo
	END
	ELSE
	BEGIN
		IF NOT EXISTS (select 1 from TipoArticulo where nombre = @nombre)
			--Inserción
			INSERT INTO TipoArticulo(nombre)
			VALUES (@nombre)
		ELSE
			PRINT 'Ya existe ese tipo de articulo'
	END
END

---13.Articulo
CREATE PROCEDURE paActualizaArticulo
    @idArticulo INT,
    @idTipoArticulo TINYINT,
    @nombre VARCHAR(40),
    @precioUnitario NUMERIC(7,2)
as
begin
	IF EXISTS(select 1 from TipoArticulo where idTipoArticulo = @idTipoArticulo) BEGIN
		--Actualización
		UPDATE Articulo
		SET idTipoArticulo = @idTipoArticulo,
			nombre = @nombre,
			precioUnitario = @precioUnitario
		WHERE idTipoArticulo = @idTipoArticulo
	END
	ELSE
	BEGIN
		--Inserción
		INSERT INTO Articulo(idTipoArticulo,nombre,precioUnitario)
		VALUES (@idTipoArticulo,@nombre,@precioUnitario)
	END
END

---14.InventarioMaeriaPrima
CREATE PROCEDURE paActualizaInventarioMateriaPrima
	@idInventarioMateriaPrima INT,
    @idMateriaPrima SMALLINT,
    @entradaMateria SMALLINT,
    @salidaMateria SMALLINT 
as
begin
	IF EXISTS(select 1 from MateriaPrima where idMateriaPrima = @idMateriaPrima) BEGIN
			IF EXISTS(select 1 from InventarioMateriaPrima where idInventarioMateriaPrima = @idInventarioMateriaPrima) BEGIN
				--Actualización
				UPDATE InventarioMateriaPrima
				SET idMateriaPrima = @idMateriaPrima,
					entradaMateria = @entradaMateria,
					salidaMateria = @salidaMateria
				WHERE idInventarioMateriaPrima = @idInventarioMateriaPrima
			END
			ELSE
			BEGIN
				INSERT INTO InventarioMateriaPrima(idMateriaPrima,entradaMateria,salidaMateria)
				VALUES (@idMateriaPrima,@entradaMateria,@salidaMateria)
			END
	END
	ELSE
	BEGIN
		PRINT 'idMateriaPrima no registrado en MateriaPrima'
	END
END
				
---15.Inventario Producto
CREATE PROCEDURE paActualizaInventarioProducto
	@idInventarioProducto int,
	@idArticulo INT,
    @entrada SMALLINT,
    @salida SMALLINT
as
begin
	IF EXISTS(select 1 from Articulo where idArticulo = @idArticulo) BEGIN
		IF EXISTS(select 1 from InventarioProducto where idInventarioProducto = @idInventarioProducto) BEGIN
			--Actualización
			UPDATE InventarioProducto
			SET idArticulo = @idArticulo,
				entrada = @entrada,
				salida = @salida
			WHERE idInventarioProducto = @idInventarioProducto
		END
		ELSE
		BEGIN
			--Inserción
			INSERT INTO InventarioProducto(idArticulo,entrada,salida)
			VALUES(@idArticulo,@entrada,@salida)
		END
	END
	ELSE
	BEGIN
		PRINT 'idArticulo no registrado en Articulo'
	END
END

---16.Categoria
CREATE PROCEDURE paActualizaCategoria
    @idCategoria TINYINT, 
    @nombre VARCHAR(50),
    @descripcion VARCHAR(100)
as
begin
		IF NOT EXISTS(select 1 from Categoria where nombre = @nombre) BEGIN
			IF EXISTS(select 1 from Categoria where idCategoria = @idCategoria) BEGIN
				--Actualización 
				UPDATE Categoria
				SET nombre = @nombre,
					descripcion = @descripcion
				WHERE idCategoria = @idCategoria
			END
			ELSE
			BEGIN
				INSERT INTO Categoria(nombre,descripcion)
				VALUES (@nombre,@descripcion)
			END
		END
		ELSE
		BEGIN	
			PRINT 'Dicha categoria ya se encuentra registrada'
		END
END

---17.Cliente
CREATE PROCEDURE paActualizaCliente
	@idCliente SMALLINT,
    @idCategoria TINYINT,
    @idPersona SMALLINT
as
begin
	IF EXISTS(select 1 from Categoria where idCategoria = @idCategoria) BEGIN
		IF EXISTS(select 1 from Persona where idPersona = @idPersona) BEGIN
			--Cada cliente, esta relacionado con un idPersona
			IF NOT EXISTS (SELECT 1 from Cliente where idPersona = @idPersona) BEGIN
				IF EXISTS(SELECT 1 FROM Cliente where idCliente = @idCliente) BEGIN
					--Actualización
					UPDATE Cliente
					SET idCategoria =@idCategoria,
						idPersona=@idPersona
					WHERE idCliente = @idCliente
				END
				ELSE 
				BEGIN
					INSERT INTO Cliente(idCategoria,idPersona)
					VALUES(@idCategoria,@idCliente)
				END
			END
		END
		ELSE BEGIN
			PRINT 'idPersona NO REGISTRADO en Persona'
		END
	END
	ELSE BEGIN
		PRINT 'idCategoria, NO REGISTRADO en categoria'
	END
END

---18.Solicitud
CREATE PROCEDURE paActualizaSolicitud
    @idSolicitud SMALLINT,
    @idCliente SMALLINT,
    @idEmpleado SMALLINT,
    @fechaHora DATETIME,
    @descripcion VARCHAR(250)
as
begin
	IF EXISTS(select 1 from Cliente where idCliente = @idCliente) BEGIN
		IF EXISTS(select 1 from Empleado where idEmpleado = @idEmpleado)BEGIN
			IF EXISTS(select 1 from Solicitud where idSolicitud = @idSolicitud) BEGIN
				--Actualización
				UPDATE Solicitud
				SET idCliente = @idCliente,
					idEmpleado  = @idEmpleado,
					fechaHora = @idEmpleado,
					descripcion = @descripcion
				WHERE idSolicitud = @idSolicitud
			END
			ELSE
			BEGIN
				INSERT INTO Solicitud(idCliente, idEmpleado,fechaHora,descripcion)
				VALUES(@idCliente,@idEmpleado,@fechaHora,@descripcion)
			END
		END
		ELSE BEGIN PRINT 'idEmpleado no registrado en Empleado'
		END
	END BEGIN PRINT 'idCliente no registrado en Cliente'
	END
END

---19.TIPOsERVICIO

CREATE PROCEDURE paAcualizaTipoServicio
	@idTipoServicio tinyint,
	@nombre varchar(100)
as
begin
	IF NOT EXISTS ( SELECT 1 FROM TipoServicio where nombre = @nombre) BEGIN
		IF EXISTS(select 1 from TipoServicio where idTipoServicio=@idTipoServicio) BEGIN
			--Actualización
			UPDATE TipoServicio
			SET nombre = @nombre
			WHERE idTipoServicio=@idTipoServicio
		END
		ELSE
		BEGIN
			--Inserción
			INSERT INTO TipoServicio(nombre)
			VALUES(@nombre)
		END
	END 
	ELSE BEGIN PRINT 'Ya se encuentra registrado ese tipo de servicio'
	END
END

---20.SolicitudServicio
CREATE PROCEDURE paActualizaSolicitudServicio
    @idSolicitudServicio SMALLINT,
    @idSolicitud SMALLINT,
    @idTipoServicio TINYINT 
as
begin
	IF EXISTS(SELECT 1 FROM Solicitud WHERE idSolicitud = @idSolicitud) BEGIN
		IF EXISTS(SELECT 1 FROM TipoServicio WHERE idTipoServicio = @idTipoServicio) BEGIN
			IF EXISTS(SELECT 1 FROM SolicitudServicio WHERE idSolicitudServicio = @idSolicitudServicio) BEGIN
				--Actualización
				UPDATE SolicitudServicio
				SET idSolicitud = @idSolicitud,
					idTipoServicio = @idTipoServicio
				WHERE idSolicitudServicio = @idSolicitudServicio
			END
			ELSE
			BEGIN
				INSERT INTO SolicitudServicio(idSolicitud,idTipoServicio)
				VALUES(@idSolicitud,@idSolicitudServicio)
			END
		END
		ELSE BEGIN PRINT 'idTipoServicio NO REGISTRADO en TipoServicio' END
	END
	ELSE BEGIN PRINT 'idSolicitud NO REGISTRADA en Solicitud' END
END
==============================================0

---21.Propuesta
CREATE PROCEDURE paActualizaPropuesta
	@idPropuesta SMALLINt,
    @idSolicitud SMALLINT,
    @fecha DATE,
    @hora TIME,
    @costo NUMERIC(7,2)
as
begin
	IF EXISTS(SELECT 1 from Solicitud where idSolicitud = @idSolicitud) BEGIN
		IF EXISTS(SELECT 1 FROM Propuesta WHERE idPropuesta=@idPropuesta) BEGIN
			--Actualización
			UPDATE Propuesta
			SET idSolicitud = @idSolicitud,
				fecha = @fecha,
				hora = @hora,
				costo = @costo
			WHERE idPropuesta=@idPropuesta
		END
		ELSE
		BEGIN
			INSERT INTO Propuesta(idSolicitud,fecha,hora,costo)
			VALUES(@idSolicitud,@fecha,@hora,@costo)
		END
	END
	ELSE BEGIN PRINT 'idSolicitud NO REGISTRADA EN Solicitud' END
END

---22.Detalle Articulo propuesta
CREATE PROCEDURE paActualizaDAP
	@idDetalleArticuloPropuesta SMALLINT,
    @idPropuesta SMALLINT,
   	@idArticulo INT,
   	@dimensiones VARCHAR(50),
   	@cantidad SMALLINT,
   	@precioVenta NUMERIC(7,2)
as
begin
	IF EXISTS(SELECT 1 FROM Propuesta where idPropuesta = @idPropuesta) BEGIN
		IF EXISTS(SELECT 1 FROM Articulo where idArticulo = @idArticulo) BEGIN
			IF EXISTS(SELECT 1 FROM DetalleArticuloPropuesta where idDetalleArticuloPropuesta = @idDetalleArticuloPropuesta) BEGIN
				--Actualización
				UPDATE DetalleArticuloPropuesta
				SET idPropuesta = @idPropuesta,
					idArticulo = @idArticulo,
					dimensiones = @dimensiones,
					cantidad = @cantidad,
					precioVenta = @precioVenta
				WHERE  idDetalleArticuloPropuesta = @idDetalleArticuloPropuesta
			END
			ELSE
			BEGIN
				INSERT INTO DetalleArticuloPropuesta(idPropuesta,idArticulo,dimensiones,cantidad,precioVenta)
				VALUES(@idPropuesta,@idArticulo,@dimensiones,@cantidad,@precioVenta)
			END
		END 
		ELSE BEGIN PRINT 'idArticulo NO REGISTRADO en ARTICULO' END
	END BEGIN PRINT 'idPropuesta NO REGISTRADO en Propuesta' END
END

---23.Articulo Materia Prima
CREATE PROCEDURE paActualizaArticuloMP
		@idArticuloMateriaPrima SMALLINT,
		@idArticulo INT,
   		@idMateriaPrima SMALLINT,
   		@cantidadMateriaPrima INT,
   		@unidadMedida char(10)
as
begin
	IF EXISTS(SELECT 1 FROM Articulo where idArticulo = @idArticulo ) BEGIN
		IF EXISTS(SELECT 1 FROM MateriaPrima where idMateriaPrima = @idMateriaPrima) BEGIN
			IF EXISTS (SELECT 1 from ArticuloMateriaPrima where idArticuloMateriaPrima = @idArticuloMateriaPrima ) BEGIN
				--Actualizacion
				UPDATE ArticuloMateriaPrima
				SET idArticulo = @idArticulo,
					idMateriaPrima = @idMateriaPrima,
					cantidadMateriaPrima = @cantidadMateriaPrima,
					unidadMedida = @unidadMedida
				WHERE idArticuloMateriaPrima = @idArticuloMateriaPrima
			END
			ELSE 
			BEGIN
				INSERT INTO ArticuloMateriaPrima(idArticulo, idMateriaPrima, cantidadMateriaPrima, unidadMedida)
				VALUES(@idArticulo,@idMateriaPrima,@cantidadMateriaPrima,@unidadMedida)
			END
		END ELSE BEGIN PRINT 'idMateriaPrima NO REGISTRADA en MateriaPrima'
		END
	END
	ELSE BEGIN PRINT 'idArticulo NO REGISTRA EN Articulo'
	END
END

--24.TipoComprobante
CREATE PROCEDURE paActualizaTipoComprobante
	@idTipoComprobante tinyint,
	@nombre varchar(50)
as
begin
	IF NOT EXISTS(SELECT 1 FROM TipoComprobante WHERE nombre = @nombre) BEGIN
		IF EXISTS(SELECT 1 FROM TipoComprobante WHERE idTipoComprobante = @idTipoComprobante ) BEGIN
			--Actualizar
			UPDATE TipoComprobante
			SET nombre = @nombre
			where idTipoComprobante = @idTipoComprobante 
		END
		ELSE
		BEGIN
			INSERT INTO TipoComprobante(nombre)
			VALUES(@nombre)
		END
	END
END
	
---25.TipoContrato
CREATE PROCEDURE paActualizaTipoContrato
	@idTipoContrato TINYINT,
	@nombre VARCHAR(30) 
as
begin
	IF NOT EXISTS(SELECT 1 FROM TipoContrato WHERE nombre = @nombre) BEGIN
		IF EXISTS(SELECT 1 FROM TipoContrato WHERE idTipoContrato = @idTipoContrato ) BEGIN
			--Actualizar
			UPDATE TipoContrato
			SET nombre = @nombre
			where idTipoContrato = @idTipoContrato 
		END
		ELSE
		BEGIN
			--Inserción
			INSERT INTO TipoContrato(nombre)
			VALUES(@nombre)
		END
	END
END

---26.Contrato
CREATE PROCEDURE paActualizaContrato
    @idContrato SMALLINT,
    @idPropuesta SMALLINT,
    @idTipoContrato TINYINT,
    @idEmpleado SMALLINT,
    @fechaHora DATETIME,
    @montoContrato NUMERIC(5,2),
    @montoAdelanto NUMERIC(5,2),
    @tiempoRealizar TINYINT,
    @descripcion VARCHAR(250),
    @estado CHAR(1)
AS
BEGIN
	if exists(select 1 from Propuesta where idPropuesta=@idPropuesta) begin
		if exists(select 1 from TipoContrato where idTipoContrato=@idTipoContrato) begin
			if exists(select 1 from Empleado where idEmpleado=@idEmpleado) begin
				if not exists(select 1 from Contrato where idPropuesta = @idPropuesta) begin
					if exists(select 1 from Contrato where idContrato=@idContrato) begin
					---Actualizacion
					UPDATE Contrato
					SET idPropuesta = @idPropuesta, 
						idTipoContrato=@idTipoContrato,
						idEmpleado=@idEmpleado,
						fechaHora=@fechaHora,
						montoContrato=@montoContrato,
						montoAdelanto=@montoAdelanto,
						tiempoRealizar=@tiempoRealizar,
						descripcion=@descripcion,
						estado=@estado
					WHERE idContrato=@idContrato
					END
					ELSE
					BEGIN
					---Inserción
						INSERT INTO Contrato
						VALUES(@idPropuesta,@idTipoContrato,@idEmpleado,@fechaHora,@montoContrato,@montoAdelanto,@tiempoRealizar,@descripcion,'A')
					END
				END
				PRINT 'idPropuesta NO REGISTRADO EN LA TABALA PROPUESTA'
			END
			PRINT 'idEmpleado NO REGISTRADO EN LA TABLA EMPLEADO'
		END
		PRINT 'idContrato NO REGISTRADO EN LA TABLA CONTRATO'
	END
	PRINT 'idPropuesta NO REGISTRADA EN LA TABLA PROPUESTA'
END
				
---27.Comprobante
CREATE PROCEDURE paActualizaComprobante
	@idComprobante INT,
    @idContrato SMALLINT,
   	@idTipoComprobante TINYINT,
   	@nSerie CHAR(4),
   	@nComprobante CHAR(8),
   	@fecha DATE,
   	@hora TIME,
   	@subtotal NUMERIC(7,2),
   	@igv NUMERIC(7,2),
   	@total NUMERIC(7,2)
as
begin
	if exists(select 1 from Contrato where idContrato=@idContrato) begin
		if exists(select 1 from TipoComprobante where idTipoComprobante=@idTipoComprobante) begin
			if not exists(select 1 from Comprobante where idContrato=@idContrato) begin
				if exists(select 1 from Comprobante where idComprobante=@idComprobante) begin
					---Actualizacion
					UPDATE Comprobante
					SET idContrato=@idContrato,
						idTipoComprobante=@idTipoComprobante,
						nSerie=@nSerie,
						nComprobante=@nComprobante,
						fecha=@fecha,
						hora=@hora,
						subtotal=@subtotal,
						igv=@igv,
						total=@total
					WHERE idComprobante=@idComprobante
				END
				ELSE BEGIN 
					---Insercion
					INSERT INTO Comprobante
					VALUES(@idContrato,@idTipoComprobante,@nSerie,@nComprobante,@fecha,@hora,@subtotal,@igv,@total)
				END
			END
			ELSE BEGIN 
				PRINT 'Ya se registro el comprobante de ese contrato'
			END
		END
		ELSE BEGIN
			PRINT 'idTipoComprobante NO REGISTRADO EN TipoComprobante'
		END
	 END
	 ELSE BEGIN
			PRINT 'idContrato NO REGISTRADO EN Contrato(NO EXISTE ESE CONTRATO'
	END
END

---28.DetalleComprobante
CREATE PROCEDURE paActualizaDetalleComprobante
	@idDetalleComprobante INT,
   	@idArticulo INT,
   	@idComprobante INT,
   	@cantidad SMALLINT,
   	@precioVenta NUMERIC(7,2),
   	@subtotal NUMERIC(7,2)
AS
BEGIN	
	IF EXISTS(select 1 from DetalleComprobante where idDetalleComprobante=@idDetalleComprobante) begin
		---Actualizacion
		UPDATE DetalleComprobante
		SET idArticulo=@idArticulo,
			idComprobante=@idComprobante,
			cantidad=@cantidad,
			precioVenta=@precioVenta,
			subtotal=@subtotal
		WHERE  idDetalleComprobante=@idDetalleComprobante
	END
	ELSE
	BEGIN
		--Inserción
		INSERT INTO DetalleComprobante
		VALUES(@idArticulo,@idComprobante,@cantidad,@precioVenta,@subtotal,@idDetalleComprobante)
	END
END

---29.TipoPago
CREATE PROCEDURE paActualizaTipoPago
	@idTipoPago tinyint,
	@nombre varchar(50)
as
begin
	IF NOT EXISTS(select 1 from TipoPago where nombre=@nombre) BEGIN
		IF EXISTS(select 1 from TipoPago where idTipoPago=@idTipoPago) begin
			---Actualización
			UPDATE TipoPago
			SET nombre = @nombre
			WHERE idTipoPago=@idTipoPago
		END
		ELSE
		BEGIN
			INSERT INTO TipoPago
			VALUES(@nombre)
		END
	END
	ELSE 
	BEGIN
		PRINT 'Ya se encuentra registrado dicho TipoPago'
	END
END

---30.DetalleComprobanteTipoPago
CREATE PROCEDURE paActualizaDetalleComprobanteTipoPago
	@idDetalleComprobanteTipoPago SMALLINT,
    @idComprobante INT,
   	@idTipoPago TINYINT,
   	@monto NUMERIC(7,2) 
AS
BEGIN
	IF EXISTS(select 1 from Comprobante where idComprobante = @idComprobante) Begin
		IF EXISTS(select 1 from TipoPago  where idTipoPago=@idTipoPago) begin
			IF EXISTS(select 1 from DetalleComprobanteTipoPago where idDetalleComprobanteTipoPago=@idDetalleComprobanteTipoPago) begin
				---Actualización
				UPDATE DetalleComprobanteTipoPago
				SET idComprobante=@idComprobante,
					idTipoPago=@idTipoPago,
					monto=@monto
				WHERE idDetalleComprobanteTipoPago=@idDetalleComprobanteTipoPago
			END
			ELSE
			BEGIN
				---Inserción
				INSERT INTO DetalleComprobanteTipoPago
				VALUES(@idComprobante,@idTipoPago,@monto)
			END
		END
		ELSE BEGIN
			PRINT 'Tipo de pago -NO EXISTE'
		END
	END
	ELSE
		PRINT 'Comprobante -NO EXISTE'
	END
END 
==================================================
---31.ContratoEmpleado
CREATE PROCEDURE paActualizaContratoEmpleado
	@idContratoEmpleado SMALLINT,
    @idContrato SMALLINT,
    @idEmpleado SMALLINT
as
begin
	IF EXISTS(select 1 from Contrato where idContrato=@idContrato) begin
		IF EXISTS(select 1 from Empleado where idEmpleado=@idEmpleado) begin
			IF EXISTS(select 1 from ContratoEmpleado where idContratoEmpleado=@idContratoEmpleado) begin
				--Actualizacion
				UPDATE ContratoEmpleado
				SET idContrato=@idContrato,
					idEmpleado=@idEmpleado
				WHERE idContratoEmpleado=@idContratoEmpleado
			END
			ELSE
			BEGIN
				--Inserción
				INSERT INTO ContratoEmpleado
				VALUES(@idContrato,@idEmpleado)
			END
		END
		ELSE BEGIN
			PRINT 'ERROR, VERIFIQUE LA EXISTENCIA DE LOS DATOS'
		END
	END
	ELSE BEGIN
		PRINT 'ERROR, VERIFIQUE LA EXISTENCIA DE LOS DATOS'
	END
END

---32.Anulacion
CREATE PROCEDURE paActualizaAnulacion
    @idAnulacion SMALLINT,
    @fecha DATE,
    @hora TIME,
    @idContrato SMALLINT,
    @idEmpleado SMALLINT
as
begin
	IF EXISTS(select 1 from Contrato where idContrato=@idContrato) begin
		IF EXISTS(select 1 from Empleado where idEmpleado=@idEmpleado) begin
			IF NOT EXISTS(select 1 from Anulacion where idContrato=@idContrato) begin
				IF EXISTS(select 1 from Anulacion where idAnulacion=@idAnulacion) begin
				---Actualizacion
					UPDATE Anulacion
					SET fecha=@fecha,
						hora=@hora,
						idContrato=@idContrato,
						idEmpleado=@idEmpleado
					WHERE idAnulacion=@idAnulacion
				END
				ELSE
				BEGIN
					--inserción
					INSERT INTO Anulacion
					VALUES(@fecha,@hora,@idContrato,@idEmpleado)
				END
			END
			ELSE BEGIN
				PRINT 'CONTRATO YA HA SIDO ANULADO'
			END
		END
		ELSE BEGIN
			PRINT 'ERROR, VERIFIQUE LA EXISTENCIA DE LOS DATOS'
		END
	END
	ELSE BEGIN
			PRINT 'ERROR, VERIFIQUE LA EXISTENCIA DE LOS DATOS'
	END
END
				
---33.ProveedorMateriaPrima
CREATE PROCEDURE paActualizaProveedorMateriaPrima
	@idProveedorMateriaPrima INT,
    @idProveedor SMALLINT,
    @idMateriaPrima SMALLINT,
    @precioMateriaPrima NUMERIC(5,2),
    @fechaCompra DATE,
    @cantidad SMALLINT,
    @unidadMedida VARCHAR(20) 
as
begin
	IF EXISTS(select 1 from Proveedor where idProveedor=@idProveedor) begin
		IF EXISTS(select 1 from MateriaPrima where idMateriaPrima=@idMateriaPrima) begin
			IF EXISTS(select 1 from ProveedorMateriaPrima where idProveedorMateriaPrima=@idProveedorMateriaPrima) begin
				--Actualizacion
				UPDATE ProveedorMateriaPrima
				SET idProveedor=@idProveedor,
					idMateriaPrima=@idMateriaPrima,
					precioMateriaPrima=@precioMateriaPrima,
					fechaCompra=@fechaCompra,
					cantidad=@cantidad,
					unidadMedida=@unidadMedida
				WHERE idProveedorMateriaPrima=@idProveedorMateriaPrima
			END
			ELSE
			BEGIN
				---Inserción
				INSERT INTO ProveedorMateriaPrima
				VALUES(@idProveedor,@idMateriaPrima,@precioMateriaPrima,@fechaCompra,@cantidad,@unidadMedida)
			END
		END
		ELSE BEGIN
			PRINT 'ERROR, VERIFIQUE LA EXISTENCIA DE LOS DATOS'
		END
	END
	ELSE BEGIN
		PRINT 'ERROR, VERIFIQUE LA EXISTENCIA DE LOS DATOS'
	END
END

------------------------2. Dos funciones escalares, deberá describir cuál es su funcionalidad agregando
------------------------comentarios dentro de la función.

---Obtener los datos completos de un cliente a partir de su ID
CREATE FUNCTION dbo.datosCliente(@idCliente smallint)
RETURNS VARCHAR(MAX)
AS
BEGIN
  -- Declaración de variables
  DECLARE @nombre VARCHAR(50), @apellidoPaterno VARCHAR(50), @apellidoMaterno VARCHAR(50), @idPersona smallint,@mensaje varchar(50);
  ---Verificamos la existencia del cliente
  IF EXISTS(select 1 from Cliente where idCliente = @idCliente) begin
  ---Se establece mensaje de cliente encontrado
	set @mensaje = 'CLIENTE ENCONTRADO';
	---Se guarda el idPersona del cliente que coincida con el idCliente pasado como parametro
	Select @idPersona=idPersona
	from Cliente
	where idCliente = @idCliente
	----En caso exista ese idPersona en la tabla PersonaNatural
	---Entonces, se toman dichos datos
	  IF EXISTS(select 1 from PersonaNatural where idPersona=@idPersona)  begin
		SELECT @nombre = nombre, @apellidoPaterno = apPat, @apellidoMaterno = apMat
		FROM PersonaNatural
		WHERE idPersona = @idPersona;
	  END
	  ---Caso contrario no existe, quiere decir que es una persona juridica
	  ---Por tanto se toman dichos datos
	  ELSE
	  BEGIN
		SELECT @nombre = razonSocial
		FROM PersonaJuridica
		WHERE idPersona = @idPersona;
	  END
  END
  ---Caso contrario, no exista el cliente, se establecerá un mensaje para el usuario
  ELSE BEGIN
	set @mensaje = 'CLIENTE NO ENCONTRADO';
  END
  -- Concatenar los datos para obtener los datos completos
  RETURN CONCAT(@mensaje, ': ',@nombre, ' ', @apellidoPaterno, ' ', @apellidoMaterno);
END;


--Obtener el total de ventas por día
CREATE FUNCTION dbo.TotalVentasPorDia(@fecha DATE)
RETURNS DECIMAL(10,2)
AS
BEGIN
  -- Declarar una variable para almacenar el total
  DECLARE @totalVentas DECIMAL(10,2);

  -- Selecciona la suma del 'total' de la tabla Comprobante y guárdala en la variable
  SELECT @totalVentas = SUM(c.total)
  FROM Comprobante c
  --Filtrandolo para cuando las fechas coincidan
  WHERE c.fecha = @fecha;

  -- Retorna el valor almacenado en la variable, es decir, retorna el total de ventas
  RETURN @totalVentas;
END;


--3. Dos vistas en las que use JOIN. Igual agregar comentarios al script en el cual expliquen
--la utilidad de las vistas.
---Muestra los contratos que se encuentran vigentes (estado = 'A')
---Función: poder visualizar los contratos que se encuentran activos, para tener un mejor 
------------manejo de la información,además se considera que es mucha ayuda.

CREATE VIEW vContratosVigentes
AS
SELECT
  ---Se mostrará el idContrado, la fechaHora del contrato, el monto del contrato y la descripcion
  c.idContrato,
  c.fechaHora,
  c.montoContrato,
  c.descripcion,
  ---Además mostrará
  ---Con el case when, se evalua si existe el idPersona en la tabla PersonaNatural, entonces obtenemos el nombre del cliente y lo mostramos
  ---De lo contrario quiere decir que es una persona Juridica, por tanto se obtiene la razon social y se muestra
  CASE 
    WHEN EXISTS(select 1 from PersonaNatural pn where idPersona = p.idPersona) THEN 
	----Aqui se obtiene el nombre de la persona
	(SELECT pn.nombre FROM PersonaNatural pn WHERE pn.idPersona = p.idPersona)
	WHEN EXISTS(select 1 from PersonaJuridica pj where idPersona = p.idPersona) THEN 
	---Aqui se obtiene la razon social
	(SELECT pj.razonSocial FROM PersonaJuridica pj WHERE pj.idPersona = p.idPersona)
  END AS 'Cliente'
FROM Contrato c
---Se realizan los inner join entre las tablas a traves de los campos por el cual se relacionan
INNER JOIN Empleado e   ON e.idEmpleado = c.idEmpleado
INNER JOIN Propuesta pp on pp.idPropuesta= c.idPropuesta
INNER JOIN Solicitud s  on pp.idSolicitud = s.idSolicitud
INNER JOIN Cliente cc    on cc.idCliente = s.idCliente
INNER JOIN Persona p    on p.idPersona = cc.idPersona
---Se filtra, para que muestre solo los contratos que tengan el estado 'A' de activo
WHERE c.estado = 'A'

select * from vContratosVigentes
drop view vContratosVigentes

---Función: mostrar el detalle de articulos que se tienen por contrato,
------------ayuda a visualizar que articulos que más se han vendido.
CREATE VIEW vDetalleArticulosPorContrato
AS
SELECT
 --Se mostrará el nombre del articulo, y la cantidad vendida del mismo
 a.nombre AS 'Nombre del artículo',
 SUM(dc.cantidad) AS 'Cantidad vendida'
---Los datos se obtendrán de la tabla DetalleComprobante
FROM DetalleComprobante dc
---Se realizan los inner joins correspondientes
INNER JOIN Comprobante c ON c.idComprobante = dc.idComprobante
INNER JOIN Articulo a ON a.idArticulo = dc.idArticulo
---Se agrupa por nombre
GROUP BY a.nombre


---Se ordenan los resultados de la consulta por la columna Cantidad vendida en orden descendente
SELECT *
FROM vDetalleArticulosPorContrato
ORDER BY "Cantidad vendida" DESC;


---------------------------------------------------------------------------------------------------------------
--4. En dos tablas que consideren críticas crear para cada una de ellas una tabla de
--Auditoría que contenga los datos de dos columnas que también considere críticas en
--las cuales se guardarán los valores antiguos y los valores nuevos, 
--agregar también las otras columnas que consideren necesarias para una adecuada auditoría de los
--cambios. Luego generar un desencadenador (Trigger) para cada una de las tablas y que
--se dispare cuando se haga Update a esas tablas críticas. También debe tener en cuenta
--que las inserciones a las tablas de auditoría se harán sólo si se hacen cambios a esas
--columnas que identificó como críticas.


-------
---Columna critica → precioUnitario del articulo
------------------------------------------------
---Columna critica → precioUnitario del articulo
create table tAuditoriaArticulo(
	id int,
	idArticulo int,
	fechaCambio date,
	precioNuevo numeric,
	precioAntiguo numeric,
	Usuario varchar(50)
)
CREATE TRIGGER tr_Articulo
ON Articulo
AFTER UPDATE
AS
BEGIN
	declare @idArticulo int, @precioNuevo numeric,@precioAntiguo numeric;
	select @idArticulo = i.idArticulo, @precioAntiguo = d.precioUnitario, @precioNuevo = i.precioUnitario
	from inserted i
	inner join deleted d on i.idArticulo = d.idArticulo

	IF update(precioUnitario) BEGIN
		insert into tAuditoriaArticulo 
		values(@idArticulo, GETDATE(), @precioNuevo,@precioAntiguo,SYSTEM_USER())
END
		--updateen inventario materia prima 
		--a inventario solo se le insertara el idMateriaPrima y idPersona el cual puede ser null
		--es decir que idPersona sera a quien se le destino esa materia prima para el articulo ,
		--si tiene idPersona quiere decir que es salida 



---Columna critica → monto de la tabla Pagos
create table tAuditoriaPagos(
	id int,
	idPago int,
	idEmpleado smallint,
	montoNuevo numeric,
	montoAntiguo numeric,
	fecha numeric,
	Usuario varchar(50)
)
CREATE TRIGGER tr_Pagos
ON Pagos
AFTER UPDATE
AS
BEGIN
	declare @idPago int, @idEmpleado numeric,@montoNuevo numeric,@montoAntiguo numeric ;
	select @idPago = i.idPago, @montoNuevo = i.monto, @montoAntiguo = d.monto, @idEmpleado =i.idEmpleado
	from inserted i
	inner join deleted d on i.idPago = d.idPago

	IF update(monto) BEGIN
		insert into tAuditoriaPagos 
		values(@idPago,@idEmpleado ,@montoNuevo, @monotoAntiguo,GETDATE(),SYSTEM_USER())
END
--5. Crear también dos triggers que considere importantes y explicar en qué consisten 
--y porqué es importante implementarlos.

--actualiza entrada de InventarioMateriaPrima

CREATE TRIGGER Actualizar_entrada_InventarioMateriaPrima
ON [ProveedorMateriaPrima]
AFTER Insert
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted i)
    BEGIN
        -- El artículo no ha sido vendido, actualizamos el inventario sumando la cantidad de entrada
		declare @cantidad smallint,@idMateriaPrima smallint 

		select @cantidad = i.cantidad,
				@idMateriaPrima=i.idMateriaPrima
		from inserted i

		if exists ( select 1  from InventarioMateriaPrima where idMateriaPrima=@idMateriaPrima)--si existe entonces actualizacion 
		begin 
			UPDATE ip
			SET ip.entradaMateria + =@cantidad
			FROM InventarioMateriaPrima ip
			join inserted d on d.idInventarioMateriaPrima=ip.idInventarioMateriaPrima
		end 
		else--sino existe ese idMateriaPrima en inventario entonces lo que hacemos es realizar insert 
		begin	
			insert into InventarioMateriaPrima(idMateriaPrima,entradaMateria)
			values (@idMateriaPrima,@cantidad)
		end  
    END;
END;

---actualiza salida de inventario materia prima

CREATE TRIGGER tr_DetalleComprobante
ON DetalleComprobante
AFTER Insert 
AS
BEGIN
	declare @idArticulo int,@cantidad smallint,@cantidadMateriaPrima int,@idMateriaPrima smallint,
	@cant int,@id smallint;
	select @idArticulo=idArticulo,@cantidad=cantidad
	from inserted


	DECLARE cursor_articulo CURSOR FOR 
	SELECT idMateriaPrima, cantidadMateriaPrima 
	FROM ArticuloMateriaPrima 
	WHERE idArticulo = @idArticulo

	OPEN cursor_articulo
	FETCH NEXT FROM cursor_articulo 
	INTO @idMateriaPrima, @cantidadMateriaPrima
 

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @id = @idMateriaPrima, @cant = @cantidadMateriaPrima
			FETCH NEXT FROM cursor_articulo 
			INTO @idMateriaPrima, @cantidadMateriaPrima

			UPDATE InventarioMateriaPrima
			set salida = salida + @cantidadMateriaPrima
			where idMateriaPrima = @idMateriaPrima

			FETCH NEXT FROM cursor_articulo 
			INTO @idMateriaPrima, @cantidadMateriaPrima
		END
	CLOSE cursor_articulo
	DEALLOCATE cursor_articulo
END


--6. Identificar un proceso en el cual se requiera usar una transacción y elaborar un
--procedimiento almacenado que lo implemente. Por ejemplo, si el proceso es transferir
--productos de un almacén a otro, la transacción debe incluir la salida del producto 
--de un almacén y la entrada al otro, por lo cual ambas operaciones deberán estar 
--incluidas en una transacción.

--idea es que :

tengo un comprobante para ese comprobante cuando se crea y se le terminan de asignar detalles entonces 
el estado del contrato se actualiza a 'i' que inactivo  o finalizado 

luego como sabemos que ya finalizo si se crea un nuevo comprobante entonces este se crea por default ello quiere decir 
que a este comprobante se le pasaran el idContrato para saber de que contrato es ese comprobante tambien el tipoComprobante,
el nserie ,ncomprobante, la fecha se obtiene de getdate(), al igual que la hora , el subtotal inicia en 0, el igv si se lo pasa,
y el total tambien en 0. 

luego cuando agreguemos un detalle de comprobante el cual tiene id, idArticulo, idComprobante, cantidad, precioventa,subtotal

algunos de estos campos se sumaran arriba para obtener el comprobante entonces sabremos que termino la insercion de detalles cuando 
se crea nuevos comprobantes los cuales se crean con algunos valores por defecto los cuales se crean con cero los demas solo se obtienen al
momento de insertar con getdate(),para ello se realizara transacciones es decir si todo sale bien y se crea un nuevo comprobante entonces 
este lo que hara es actualizar el estado de contrato a i que es finalizado que significa que ya se vendio 

CREATE PROCEDURE pa_GenerarComprobanteYActualizarEstadoContrato
(
    @idTipoComprobante TINYINT,
    @nSerie CHAR(4),
    @nComprobante CHAR(8),
    @igv NUMERIC(7, 2),
    @detallesComprobante TABLE (
	idArticulo INT,cantidad SMALLINT,
	precioVenta NUMERIC(7, 2),subtotal NUMERIC(7, 2)
	)
)
AS
BEGIN
    DECLARE @idContrato INT
    DECLARE @idComprobante INT
    DECLARE @idContratoAnterior INT
    DECLARE @subtotal NUMERIC(7, 2)
    DECLARE @total NUMERIC(7, 2)

    -- Iniciar una transacción
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Obtener el último idContrato insertado
        SELECT @idContrato = MAX(idContrato) FROM Contrato;

        -- Obtener el idContrato del último comprobante
        SELECT TOP 1 @idContratoAnterior = idContrato
        FROM Comprobante
        ORDER BY idComprobante DESC;

        -- Verificar si hay comprobantes para este contrato
        IF EXISTS (SELECT 1 FROM Comprobante WHERE idContrato = @idContrato)
        BEGIN
            -- Insertar detalles del comprobante existente
            INSERT INTO DetalleComprobante (idArticulo, idComprobante, cantidad, precioVenta, subtotal)
            SELECT idArticulo, c.idComprobante, cantidad, precioVenta, subtotal
            FROM @detallesComprobante dc
            INNER JOIN Comprobante c ON dc.idComprobante = c.idComprobante
            WHERE c.idContrato = @idContrato;

            -- Actualizar subtotal y total del comprobante
            SELECT @subtotal = ISNULL(SUM(subtotal), 0), @total = ISNULL(SUM(subtotal) + @igv, 0)
            FROM DetalleComprobante
            WHERE idComprobante IN (SELECT idComprobante FROM @detallesComprobante);

            UPDATE Comprobante
            SET subtotal = @subtotal, total = @total
            WHERE idComprobante IN (SELECT idComprobante FROM @detallesComprobante);
        END
        ELSE
        BEGIN
            -- Actualizar el estado del contrato anterior a 'I' (Inactivo) solo si el idContrato es diferente al del último comprobante generado
            IF @idContrato <> @idContratoAnterior
            BEGIN
                UPDATE Contrato 
                SET estado = 'I' 
                WHERE idContrato = @idContratoAnterior;
            END

            -- Insertar un nuevo comprobante con los valores proporcionados
            INSERT INTO Comprobante (idContrato, idTipoComprobante, nSerie, nComprobante, fecha, hora, subtotal, igv, total)
            VALUES (@idContrato, @idTipoComprobante, @nSerie, @nComprobante, GETDATE(), GETDATE(), 0, @igv, 0);

            -- Obtener el id del comprobante recién insertado
            SET @idComprobante = SCOPE_IDENTITY();

            -- Insertar detalles del comprobante
            INSERT INTO DetalleComprobante (idArticulo, idComprobante, cantidad, precioVenta, subtotal)
            SELECT idArticulo, @idComprobante, cantidad, precioVenta, subtotal
            FROM @detallesComprobante;

            -- Actualizar subtotal y total del comprobante
            SELECT @subtotal = ISNULL(SUM(subtotal), 0), @total = ISNULL(SUM(subtotal) + @igv, 0)
            FROM DetalleComprobante
            WHERE idComprobante = @idComprobante;

            UPDATE Comprobante
            SET subtotal = @subtotal, total = @total
            WHERE idComprobante = @idComprobante;
        END

        -- Confirmar la transacción
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Si ocurre algún error, hacer rollback de la transacción
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        -- Manejar el error
        PRINT 'Error al generar el comprobante y actualizar el estado del contrato.';
    END CATCH
END



las insersiones serian 


DECLARE @detallesComprobante TABLE (
    idArticulo INT,
    cantidad SMALLINT,
    precioVenta NUMERIC(7, 2),
    subtotal NUMERIC(7, 2)
);

INSERT INTO @detallesComprobante (idArticulo, cantidad, precioVenta, subtotal)
VALUES
    (1, 2, 50.00, 100.00),
    (2, 1, 75.00, 75.00);

EXEC pa_GenerarComprobanteYActualizarEstadoContrato
    @idTipoComprobante = 2,
    @nSerie = 'B002',
    @nComprobante = '00000002',
    @igv = 10.00,
    @detallesComprobante = @detallesComprobante;


--7. Elaborar un procedimiento almacenado que incluya el uso de cursores, justificar
--con comentarios dentro del procedimiento en el que se explique porqué es necesario 
--usar el cursor en el cual se va recorriendo fila por fila y no hacerlo
--en un solo comando Transact-SQL.

---------------------------cursor que muestra---------------------------------------------------------------
CREATE PROCEDURE ActualizarInventarioMateriaPrima
AS
BEGIN
--muestra stock

    -- Declarar variables para almacenar los datos de cada fila
    DECLARE @idMateriaPrima INT, @entradaMateria SMALLINT, @salidaMateria SMALLINT

    -- Declarar el cursor para recorrer las filas de la tabla InventarioMateriaPrima
    DECLARE curInventario CURSOR FOR
        SELECT idMateriaPrima, entradaMateria, salidaMateria
        FROM InventarioMateriaPrima

    -- Abrir el cursor
    OPEN curInventario

    -- Inicializar variables para almacenar la suma de las entradas y salidas de materia prima
    DECLARE @totalEntrada INT, @totalSalida INT
    SET @totalEntrada = 0
    SET @totalSalida = 0

    -- Recorrer el cursor
    FETCH NEXT FROM curInventario INTO @idMateriaPrima, @entradaMateria, @salidaMateria
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Actualizar el total de entradas y salidas de materia prima
        SET @totalEntrada = @totalEntrada + @entradaMateria
        SET @totalSalida = @totalSalida + @salidaMateria

        -- Obtener la siguiente fila
        FETCH NEXT FROM curInventario INTO @idMateriaPrima, @entradaMateria, @salidaMateria
    END

    -- Cerrar el cursor
    CLOSE curInventario
    DEALLOCATE curInventario
END

--si va 
create procedure pa_muestra_Articulo_xComprobante(	@fecha date)--por mes
as 
begin 
		if exists ( select 1 from comprobante where MONTH(fecha)=MONTH(@fecha) )
		begin

			declare @nombre varchar(100),@precio numeric(7,2) 
			declare c_articulo cursor 
			for
			select a.nombre,a.precio
			from DetalleComprobante c 
			join Comprobante d on d.idComprobante=c.idComprobante
			join Articulo a on a.idArticulo =d.idArticulo
			where MONTH(d.fecha)=MONTH(@fecha)
			open c_articulo 
			fetch c_articulo into @nombre,@precio 
			while @@fetch_status=0
			begin
				print 'Articulo: '+@nombre +'precio: '+cast(@precio as varchar(50))
				fetch c_articulo into @nombre,@precio 
			end
			close c_articulo 
			deallocate c_articulo

		end
		else 
		begin
			print 'No se encontraron Articulo vendidos para el comprobante '+cast(@fecha as varchar(10))
		end
end


