
/*
Nombre del procedimiento: paActualizaPersonaNatural
Propósito: Actualiza o inserta información de una persona natural en la base de datos.
Parámetros de entrada:
    - @idPersonaNatural: Identificador único de la persona natural.
    - @idPersona: Identificador único de la persona asociada.
    - @nombre: Nombre de la persona natural.
    - @apPat: Apellido paterno de la persona natural.
    - @apMat: Apellido materno de la persona natural.
    - @dni: DNI de la persona natural.
*/
CREATE PROCEDURE paActualizaPersonaNatural
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
	-- Comprueba si la persona asociada existe
	IF EXISTS (SELECT 1 FROM Persona WHERE idPersona = @idPersona) 
	BEGIN
		-- Comprueba si no existe una referencia de persona en persona natural
		IF NOT EXISTS (SELECT 1 FROM PersonaNatural WHERE idPersona = @idPersona) 
		BEGIN
			-- Comprueba si existe un registro con el ID de persona natural proporcionado
			 IF EXISTS (SELECT 1 FROM PersonaNatural WHERE idPersonaNatural = @idPersonaNatural)
			 BEGIN
				-- Actualización de los datos existentes
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
			 BEGIN
			 -- Inserción de un nuevo registro
				INSERT INTO PersonaNatural(idPersona, nombre, apPat, apMat, dni)
				VALUES (@idPersona, @nombre, @apPat, @apMat, @dni);
			 END
		END
		-- Mensaje si ya existe el ID de persona
		ELSE
		BEGIN
			PRINT 'Ya se registró el idPersona proporcionado, utilice otro'
		END
	END
	-- Mensaje si el ID de persona no se encuentra en la tabla Persona
	PRINT 'El idPersona proporcionado no se encuentra en la tabla Persona'
END


/*
Nombre del procedimiento: paActualizaPersonaJuridica
Propósito: Actualiza o inserta información de una persona jurídica en la base de datos.
Parámetros de entrada:
    - @idPersJuridica: Identificador único de la persona jurídica.
    - @idPersona: Identificador único de la persona asociada.
    - @razonSocial: Razón social de la persona jurídica.
*/
CREATE PROCEDURE paActualizaPersonaJuridica
(
    @idPersJuridica SMALLINT,
    @idPersona SMALLINT,
    @razonSocial VARCHAR(150)
)
AS
BEGIN
	-- Comprueba si existe la persona
	IF EXISTS (SELECT 1 FROM Persona WHERE idPersona = @idPersona)
	BEGIN
		-- Comprueba si la persona no es persona jurídica
		IF NOT EXISTS (SELECT 1 FROM PersonaJuridica WHERE idPersona = @idPersona)
		BEGIN
			-- Comprueba si ya existe la persona jurídica
			IF EXISTS (SELECT 1 FROM PersonaJuridica WHERE idPersJuridica = @idPersJuridica)
			BEGIN
				-- Actualización de la persona jurídica existente
				UPDATE PersonaJuridica
				SET 
					  idPersona = @idPersona,
					  razonSocial = @razonSocial
				WHERE idPersJuridica = @idPersJuridica;
			END
			ELSE
			BEGIN
				-- Inserción de una nueva persona jurídica
				INSERT INTO PersonaJuridica(idPersona, razonSocial)
				VALUES (@idPersona, @razonSocial)
			END
		END
		ELSE 
		BEGIN
			PRINT 'El idPersona ya existe en la tabla'
		END
	END 
	ELSE 
	BEGIN
		PRINT 'No existe idPersona en la tabla Persona'
	END
END


/*
Nombre del procedimiento: paActualizarTelefono
Propósito: Actualiza o inserta un número de teléfono en la base de datos.
Parámetros de entrada:
    - @id: Identificador único del teléfono.
    - @numTelefono: Número de teléfono a actualizar o insertar.
*/
CREATE PROCEDURE paActualizarTelefono
(
	@id SMALLINT,
	@numTelefono CHAR(9)
)
AS
BEGIN
	DECLARE @numTelefonoA VARCHAR(40)
	-- Comprueba si el teléfono existe para realizar una actualización
	IF EXISTS (SELECT 1 FROM Telefono WHERE idTelefono = @id) 
	BEGIN
		SELECT @numTelefonoA = numeroTelefono
		FROM Telefono 
		WHERE idTelefono = @id
		-- Realiza la actualización si el número es diferente
		IF @numTelefono <> @numTelefonoA  
		BEGIN
			-- Actualiza el número de teléfono
			UPDATE Telefono
			SET numeroTelefono = @numTelefono
			WHERE idTelefono = @id
		END
	END
	ELSE
	BEGIN
		-- Inserta un nuevo número de teléfono si no existe
		INSERT INTO Telefono(numeroTelefono)
		VALUES (@numTelefono)
	END
END


/*
Nombre del procedimiento: paActualizaPersona
Propósito: Actualiza o inserta información de una persona en la base de datos.
Parámetros de entrada:
    - @idPersona: Identificador único de la persona.
    - @idTelefono: Identificador único del teléfono asociado.
    - @email: Correo electrónico de la persona.
    - @direccion: Dirección de la persona.
    - @ruc: RUC de la persona.
*/
CREATE PROCEDURE paActualizaPersona
(
    @idPersona SMALLINT,
    @idTelefono SMALLINT,
    @email VARCHAR(50),
    @direccion VARCHAR(150),
    @ruc CHAR(11)
)
AS
BEGIN
	-- Verifica si el teléfono asociado existe
	IF EXISTS(SELECT 1 FROM Telefono WHERE idTelefono = @idTelefono) 
	BEGIN
		-- Si no existe teléfono asignado a la persona
		IF NOT EXISTS(SELECT 1 FROM Persona WHERE idTelefono = @idTelefono)
		BEGIN
			-- Si existe la persona
			IF EXISTS(SELECT 1 FROM Persona WHERE idPersona = @idPersona)
			BEGIN
				-- Actualiza la información de la persona y asigna el teléfono
				UPDATE Persona
				SET idTelefono = @idTelefono,
					email = @email,
					direccion = @direccion,
					ruc = @ruc
				WHERE idPersona = @idPersona
			END
			-- Si no existe la persona, la inserta y asigna el teléfono
			ELSE
			BEGIN
				-- Inserta una nueva persona y asigna el teléfono
				INSERT INTO Persona
				VALUES(@idTelefono, @email, @direccion, @ruc)
			END
		END
		-- Si ya existe el teléfono asignado a la persona
		ELSE BEGIN
			PRINT 'La persona ya existe'
		END
	END
	-- Si no existe el registro de teléfono
	ELSE BEGIN
		PRINT 'ERROR, VERIFIQUE LA EXISTENCIA DE REGISTRO DE TELEFONO'
	END
END


/*
Nombre del procedimiento: paActualizaTipoProveedor
Propósito: Actualiza o inserta un tipo de proveedor en la base de datos.
Parámetros de entrada:
    - @id: Identificador único del tipo de proveedor.
    - @nombre: Nombre del tipo de proveedor.
*/
CREATE PROCEDURE paActualizaTipoProveedor
(
	@id TINYINT,
	@nombre VARCHAR(40)
)
AS
BEGIN
	DECLARE @nombreA VARCHAR(40)
	-- Comprueba si el tipo de proveedor existe
	IF EXISTS (SELECT 1 FROM tipoProveedor WHERE idtipoProveedor = @id) 
	BEGIN
		SELECT @nombreA = nombre
		FROM tipoProveedor 
		WHERE idtipoProveedor = @id
		-- Actualiza el nombre si es diferente
		IF @nombre <> @nombreA
		BEGIN
			UPDATE tipoProveedor
			SET nombre = @nombre
			WHERE idtipoProveedor = @id
		END
	ELSE
	BEGIN
		-- Inserta un nuevo tipo de proveedor si no existe
		IF NOT EXISTS (SELECT 1 FROM tipoProveedor WHERE nombre = @nombre) 
		BEGIN
			INSERT INTO tipoProveedor (nombre)
			VALUES(@nombre)
		END
		ELSE
		BEGIN
			PRINT 'Ya se ha registrado ese tipo de proveedor'
		END
	END
END


/*
Nombre del procedimiento: paActualizaProveedor
Propósito: Actualiza o inserta información de un proveedor en la base de datos.
Parámetros de entrada:
    - @idProveedor: Identificador único del proveedor.
    - @idPersona: Identificador único de la persona asociada al proveedor.
    - @idtipoProveedor: Identificador único del tipo de proveedor asociado.
*/
CREATE PROCEDURE paActualizaProveedor
(
	@idProveedor SMALLINT,
	@idPersona SMALLINT,
	@idtipoProveedor TINYINT
)
AS
BEGIN
	DECLARE @idPersonaA SMALLINT, @idtipoProveedorA TINYINT
	
	-- Verifica la existencia de la persona en la tabla Persona
	IF EXISTS (SELECT 1 FROM Persona WHERE idPersona = @idPersona ) 
	BEGIN
		-- Verifica la existencia del tipo de proveedor en la tabla tipoProveedor
		IF EXISTS (SELECT 1 FROM tipoProveedor WHERE idtipoProveedor = @idtipoProveedor) 
		BEGIN
			-- Verifica si el idPersona ya se encuentra registrado en la tabla Proveedor
			IF NOT EXISTS (SELECT 1 FROM PROVEEDOR WHERE idPersona = @idPersona) 
			BEGIN
				-- Comprueba si existe el idProveedor, si existe, se trata de una actualización
				IF EXISTS (SELECT 1 FROM Proveedor WHERE idProveedor = @idProveedor)
				BEGIN
					-- Realiza la actualización del proveedor
					UPDATE Proveedor
					SET idPersona = @idPersona,
					idtipoProveedor = @idtipoProveedor
					WHERE idProveedor = @idProveedor
				END
				ELSE
				BEGIN
					-- Inserta un nuevo proveedor
					INSERT INTO Proveedor (idPersona, idtipoProveedor)
					VALUES (@idPersona, @idtipoProveedor)
				END
			END
			ELSE
			BEGIN
				PRINT 'El idPersona ya se encuentra registrado'
			END
		END
		ELSE
		BEGIN
			PRINT 'El idtipoProveedor pasado como parámetro no se encuentra registrado en tipoProveedor'
		END
	END
	ELSE
	BEGIN
		PRINT 'El idPersona pasado como parámetro no se encuentra registrado en Persona' 
	END
END


/*
Nombre del procedimiento: paActualizaCargo
Propósito: Actualiza o inserta un cargo en la base de datos.
Parámetros de entrada:
    - @idCargo: Identificador único del cargo.
    - @nombre: Nombre del cargo.
*/
CREATE PROCEDURE paActualizaCargo
(
	@idCargo TINYINT,
	@nombre VARCHAR(50)
)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Cargo WHERE idCargo = @idCargo) 
	-- Actualiza el cargo si existe
	UPDATE Cargo
	SET nombre = @nombre
	WHERE idCargo = @idCargo
	ELSE
		IF NOT EXISTS(SELECT 1 FROM Cargo WHERE nombre = @nombre) 
		BEGIN
			-- Inserta un nuevo cargo si el nombre no está registrado
			INSERT INTO Cargo (nombre)
			VALUES(@nombre)
		END
		ELSE
		BEGIN
			PRINT 'El nombre del cargo ya se encuentra registrado'
		END
END


/*
Nombre del procedimiento: paActualizaEmpleado
Propósito: Actualiza o inserta información de un empleado en la base de datos.
Parámetros de entrada:
    - @idEmpleado: Identificador único del empleado.
    - @idCargo: Identificador único del cargo del empleado.
    - @idPersona: Identificador único de la persona asociada al empleado.
    - @fechaIngreso: Fecha de ingreso del empleado.
    - @fechaCese: Fecha de cese del empleado.
    - @estado: Estado del empleado.
*/
CREATE PROCEDURE paActualizaEmpleado
(
	@idEmpleado SMALLINT,
	@idCargo TINYINT,
	@idPersona SMALLINT,
	@fechaIngreso DATE,
	@fechaCese DATE,
	@estado CHAR(1) 
)
AS
BEGIN
	-- Verifica si el cargo existe en la tabla Cargo
	IF EXISTS(SELECT 1 FROM Cargo WHERE idCargo = @idCargo )
	BEGIN
		-- Verifica si la persona existe en la tabla Persona
		IF EXISTS(SELECT 1 FROM Persona WHERE idPersona = @idPersona) 
		BEGIN
			-- Verifica si el idPersona no está registrado como empleado
			IF NOT EXISTS(SELECT 1 FROM Empleado WHERE idPersona = @idPersona) 
			BEGIN
				-- Verifica si el idEmpleado existe, en caso afirmativo, se trata de una actualización
				IF EXISTS(SELECT 1 FROM Empleado WHERE idEmpleado = @idEmpleado)
				BEGIN
					-- Realiza la actualización del empleado
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
					-- Inserta un nuevo empleado
					INSERT INTO Empleado(idCargo,idPersona,fechaIngreso,fechaCese,estado)
					VALUES(@idCargo,@idPersona,@fechaIngreso,@fechaCese,@estado)
				END
			END
			ELSE
			BEGIN
				PRINT 'El idPersona pasado como parámetro ya está registrado en Empleado'
			END
		END
		ELSE
		BEGIN
			PRINT 'El idPersona no está registrado en Persona'
		END
	END
	ELSE
	BEGIN
		PRINT 'El idCargo no está registrado en Cargo'
	END
END


/*
Nombre del procedimiento: paActualizaPago 
Propósito: Actualiza o inserta información de un pago en la base de datos.
Parámetros de entrada:
    - @idPagos: Identificador único del pago.
    - @idEmpleado: Identificador único del empleado asociado al pago.
    - @monto: Monto del pago.
    - @fecha: Fecha del pago.
*/
CREATE PROCEDURE paActualizaPago 
(
	@idPagos SMALLINT,
	@idEmpleado SMALLINT,
	@monto NUMERIC(7,2),
	@fecha DATE 
)
AS
BEGIN
	-- Verifica si el empleado existe en la tabla Empleado
	IF EXISTS(SELECT 1 FROM Empleado WHERE idEmpleado = @idEmpleado) 
	BEGIN
		-- Verifica si el pago existe en la tabla Pagos
		IF EXISTS(SELECT 1 FROM Pagos WHERE idPagos = @idPagos) 
		BEGIN
			-- Realiza la actualización del pago
			UPDATE Pagos
			SET idEmpleado = @idEmpleado,
				monto = @monto,
				fecha = @fecha
			WHERE idPagos = @idPagos
		END
		ELSE
		BEGIN
			-- Inserta un nuevo pago
			INSERT INTO Pagos(idEmpleado, monto, fecha)
			VALUES(@idEmpleado, @monto,@fecha)
		END
	END
	ELSE
	BEGIN
		PRINT 'El idEmpleado pasado como parámetro no está registrado en Empleado'
	END
END

/*
Nombre del procedimiento: paActualizaCategoriaMP
Propósito: Actualiza o inserta una categoría de materia prima en la base de datos.
Parámetros de entrada:
    - @idCategoriaMateriaPrima: Identificador único de la categoría de materia prima.
    - @nombre: Nombre de la categoría de materia prima.
*/
CREATE PROCEDURE paActualizaCategoriaMP
(
	@idCategoriaMateriaPrima TINYINT,
	@nombre VARCHAR(50)
)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM CategoriaMateriaPrima WHERE idCategoriaMateriaPrima=@idCategoriaMateriaPrima) 
	BEGIN
		-- Actualiza la categoría si existe
		UPDATE CategoriaMateriaPrima
		SET nombre = @nombre
		WHERE  idCategoriaMateriaPrima=@idCategoriaMateriaPrima
	END
	ELSE
	BEGIN
		-- Inserta una nueva categoría si el nombre no está registrado
		IF NOT EXISTS (SELECT 1 FROM CategoriaMateriaPrima WHERE nombre = @nombre) 
		BEGIN
			INSERT INTO CategoriaMateriaPrima(nombre)
			VALUES (@nombre)
		END
		ELSE
		BEGIN
			PRINT 'El nombre de la categoría ya se encuentra registrado'
		END
	END
END



/*
Nombre del procedimiento: paActualizaMateriaPrima
Propósito: Actualiza o inserta información de una materia prima en la base de datos.
Parámetros de entrada:
    - @idMateriaPrima: Identificador único de la materia prima.
    - @idCategoriaMateriaPrima: Identificador único de la categoría de materia prima asociada.
    - @nombre: Nombre de la materia prima.
*/
CREATE PROCEDURE paActualizaMateriaPrima
(
	@idMateriaPrima SMALLINT,
    @idCategoriaMateriaPrima TINYINT,
    @nombre VARCHAR(150)
)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM CategoriaMateriaPrima WHERE idCategoriaMateriaPrima = @idCategoriaMateriaPrima) 
	BEGIN
		IF EXISTS(SELECT 1 FROM MateriaPrima WHERE idMateriaPrima = @idMateriaPrima) 
		BEGIN
			IF NOT EXISTS(SELECT 1 FROM MateriaPrima WHERE nombre = @nombre) 
			BEGIN
				-- Actualización de la materia prima
				UPDATE MateriaPrima
				SET idCategoriaMateriaPrima = @idCategoriaMateriaPrima,
					nombre = @nombre
				WHERE idMateriaPrima = @idMateriaPrima
			END
			ELSE
			BEGIN
				PRINT 'La materia prima ya está registrada'
			END
		END
		ELSE
		BEGIN
			-- Inserción de una nueva materia prima
			INSERT INTO MateriaPrima(idCategoriaMateriaPrima, nombre)
			VALUES(@idCategoriaMateriaPrima, @nombre)
		END
	END
	ELSE
	BEGIN
		PRINT 'La idCategoriaMateriaPrima no está registrada en CategoriaMateriaPrima'
	END
END


/*
Nombre del procedimiento: paActualizaTipoArticulo
Propósito: Actualiza o inserta información de un tipo de artículo en la base de datos.
Parámetros de entrada:
    - @idTipoArticulo: Identificador único del tipo de artículo.
    - @nombre: Nombre del tipo de artículo.
*/
CREATE PROCEDURE paActualizaTipoArticulo
(
	@idTipoArticulo TINYINT,
	@nombre VARCHAR(40)
)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM TipoArticulo WHERE idTipoArticulo=@idTipoArticulo) 
	BEGIN
		-- Actualización del tipo de artículo
		UPDATE TipoArticulo
		SET nombre = @nombre
		WHERE idTipoArticulo=@idTipoArticulo
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM TipoArticulo WHERE nombre = @nombre)
		BEGIN
			-- Inserción de un nuevo tipo de artículo
			INSERT INTO TipoArticulo(nombre)
			VALUES (@nombre)
		END
		ELSE
		BEGIN
			PRINT 'El tipo de artículo ya está registrado'
		END
	END
END


/*
Nombre del procedimiento: paActualizaArticulo
Propósito: Actualiza o inserta información de un artículo en la base de datos.
Parámetros de entrada:
    - @idArticulo: Identificador único del artículo.
    - @idTipoArticulo: Identificador único del tipo de artículo asociado.
    - @nombre: Nombre del artículo.
    - @precioUnitario: Precio unitario del artículo.
*/
CREATE PROCEDURE paActualizaArticulo
(
    @idArticulo INT,
    @idTipoArticulo TINYINT,
    @nombre VARCHAR(40),
    @precioUnitario NUMERIC(7,2)
)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM TipoArticulo WHERE idTipoArticulo = @idTipoArticulo) 
	BEGIN
		IF EXISTS(SELECT 1 FROM Articulo WHERE idArticulo = @idArticulo) 
		BEGIN
			-- Actualización del artículo
			UPDATE Articulo
			SET idTipoArticulo = @idTipoArticulo,
				nombre = @nombre,
				precioUnitario = @precioUnitario
			WHERE idArticulo = @idArticulo
		END
		ELSE
		BEGIN
			-- Inserción de un nuevo artículo
			INSERT INTO Articulo(idTipoArticulo, nombre, precioUnitario)
			VALUES (@idTipoArticulo, @nombre, @precioUnitario)
		END
	END
	ELSE
	BEGIN
		PRINT 'El idTipoArticulo no está registrado en TipoArticulo'
	END
END


/*
Nombre del procedimiento: paActualizaInventarioMateriaPrima
Propósito: Actualiza o inserta información del inventario de materia prima en la base de datos.
Parámetros de entrada:
    - @idInventarioMateriaPrima: Identificador único del inventario de materia prima.
    - @idMateriaPrima: Identificador único de la materia prima asociada.
    - @entradaMateria: Cantidad de entrada de materia prima.
    - @salidaMateria: Cantidad de salida de materia prima.
*/
CREATE PROCEDURE paActualizaInventarioMateriaPrima
(
	@idInventarioMateriaPrima INT,
    @idMateriaPrima SMALLINT,
    @entradaMateria SMALLINT,
    @salidaMateria SMALLINT 
)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM MateriaPrima WHERE idMateriaPrima = @idMateriaPrima) 
	BEGIN
		IF EXISTS(SELECT 1 FROM InventarioMateriaPrima WHERE idInventarioMateriaPrima = @idInventarioMateriaPrima) 
		BEGIN
			-- Actualización del inventario de materia prima
			UPDATE InventarioMateriaPrima
			SET idMateriaPrima = @idMateriaPrima,
				entradaMateria = @entradaMateria,
				salidaMateria = @salidaMateria
			WHERE idInventarioMateriaPrima = @idInventarioMateriaPrima
		END
		ELSE
		BEGIN
			-- Inserción de un nuevo registro de inventario de materia prima
			INSERT INTO InventarioMateriaPrima(idMateriaPrima, entradaMateria, salidaMateria)
			VALUES (@idMateriaPrima, @entradaMateria, @salidaMateria)
		END
	END
	ELSE
	BEGIN
		PRINT 'El idMateriaPrima no está registrado en MateriaPrima'
	END
END


/*
Nombre del procedimiento: paActualizaInventarioProducto
Propósito: Actualiza o inserta información del inventario de producto en la base de datos.
Parámetros de entrada:
    - @idInventarioProducto: Identificador único del inventario de producto.
    - @idArticulo: Identificador único del artículo asociado.
    - @entrada: Cantidad de entrada de producto.
    - @salida: Cantidad de salida de producto.
*/
CREATE PROCEDURE

 paActualizaInventarioProducto
(
	@idInventarioProducto INT,
	@idArticulo INT,
    @entrada SMALLINT,
    @salida SMALLINT
)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM Articulo WHERE idArticulo = @idArticulo) 
	BEGIN
		IF EXISTS(SELECT 1 FROM InventarioProducto WHERE idInventarioProducto = @idInventarioProducto) 
		BEGIN
			-- Actualización del inventario de producto
			UPDATE InventarioProducto
			SET idArticulo = @idArticulo,
				entrada = @entrada,
				salida = @salida
			WHERE idInventarioProducto = @idInventarioProducto
		END
		ELSE
		BEGIN
			-- Inserción de un nuevo registro de inventario de producto
			INSERT INTO InventarioProducto(idArticulo, entrada, salida)
			VALUES(@idArticulo, @entrada, @salida)
		END
	END
	ELSE
	BEGIN
		PRINT 'El idArticulo no está registrado en Articulo'
	END
END


/*
Nombre del procedimiento: paActualizaCategoria
Propósito: Actualiza o inserta información de una categoría en la base de datos.
Parámetros de entrada:
    - @idCategoria: Identificador único de la categoría.
    - @nombre: Nombre de la categoría.
    - @descripcion: Descripción de la categoría.
*/
CREATE PROCEDURE paActualizaCategoria
(
    @idCategoria TINYINT, 
    @nombre VARCHAR(50),
    @descripcion VARCHAR(100)
)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM Categoria WHERE nombre = @nombre) 
	BEGIN
		IF EXISTS(SELECT 1 FROM Categoria WHERE idCategoria = @idCategoria) 
		BEGIN
			-- Actualización de la categoría
			UPDATE Categoria
			SET nombre = @nombre,
				descripcion = @descripcion
			WHERE idCategoria = @idCategoria
		END
		ELSE
		BEGIN
			-- Inserción de una nueva categoría
			INSERT INTO Categoria(nombre, descripcion)
			VALUES (@nombre, @descripcion)
		END
	END
	ELSE
	BEGIN	
		PRINT 'La categoría ya está registrada'
	END
END


/*
Nombre del procedimiento: paActualizaCliente
Propósito: Actualiza o inserta información de un cliente en la base de datos.
Parámetros de entrada:
    - @idCliente: Identificador único del cliente.
    - @idCategoria: Identificador único de la categoría asociada al cliente.
    - @idPersona: Identificador único de la persona asociada al cliente.
*/
CREATE PROCEDURE paActualizaCliente
(
	@idCliente SMALLINT,
    @idCategoria TINYINT,
    @idPersona SMALLINT
)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM Categoria WHERE idCategoria = @idCategoria) 
	BEGIN
		IF EXISTS(SELECT 1 FROM Persona WHERE idPersona = @idPersona) 
		BEGIN
			-- Cada cliente está relacionado con un idPersona
			IF NOT EXISTS (SELECT 1 FROM Cliente WHERE idPersona = @idPersona) 
			BEGIN
				IF EXISTS(SELECT 1 FROM Cliente WHERE idCliente = @idCliente) 
				BEGIN
					-- Actualización del cliente
					UPDATE Cliente
					SET idCategoria = @idCategoria,
						idPersona = @idPersona
					WHERE idCliente = @idCliente
				END
				ELSE 
				BEGIN
					-- Inserción de un nuevo cliente
					INSERT INTO Cliente(idCategoria, idPersona)
					VALUES(@idCategoria, @idCliente)
				END
			END
		END
		ELSE 
		BEGIN
			PRINT 'El idPersona no está registrado en Persona'
		END
	END
	ELSE 
	BEGIN
		PRINT 'El idCategoria no está registrado en Categoria'
	END
END


/*
Nombre del procedimiento: paActualizaSolicitud
Propósito: Actualiza o inserta información de una solicitud en la base de datos.
Parámetros de entrada:
    - @idSolicitud: Identificador único de la solicitud.
    - @idCliente: Identificador único del cliente asociado a la solicitud.
    - @idEmpleado: Identificador único del empleado asociado a la solicitud.
    - @fechaHora: Fecha y hora de la solicitud.
    - @descripcion: Descripción de la solicitud.
*/
CREATE PROCEDURE paActualizaSolicitud
(
    @idSolicitud SMALLINT,
    @idCliente SMALLINT,
    @idEmpleado SMALLINT,
    @fechaHora DATETIME,
    @descripcion VARCHAR(250)
)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM Cliente WHERE idCliente = @idCliente) 
	BEGIN
		IF EXISTS(SELECT 1 FROM Empleado WHERE idEmpleado = @idEmpleado)
		BEGIN
			IF EXISTS(SELECT 1 FROM Solicitud WHERE idSolicitud = @idSolicitud) 
			BEGIN
				-- Actualización de la solicitud
				UPDATE Solicitud
				SET idCliente = @idCliente,
					idEmpleado  = @idEmpleado,
					fechaHora = @fechaHora,
					descripcion = @descripcion
				WHERE idSolicitud = @idSolicitud
			END
			ELSE
			BEGIN
				-- Inserción de una nueva solicitud
				INSERT INTO Solicitud(idCliente, idEmpleado, fechaHora, descripcion)
				VALUES(@idCliente, @idEmpleado, @fechaHora, @descripcion)
			END
		END
		ELSE
		BEGIN
			PRINT 'El idEmpleado no está registrado en Empleado'
		END
	END
	ELSE
	BEGIN
		PRINT 'El idCliente no está registrado en Cliente'
	END
END


/*
Nombre del procedimiento: paAcualizaTipoServicio
Propósito: Actualiza o inserta información de un tipo de servicio en la base de datos.
Parámetros de entrada:
    - @idTipoServicio: Identificador único del tipo de servicio.
    - @nombre: Nombre del tipo de servicio.
*/
CREATE PROCEDURE paAcualizaTipoServicio
(
	@idTipoServicio tinyint,
	@nombre varchar(100)
)
AS
BEGIN
	IF NOT EXISTS ( SELECT 1 FROM TipoServicio WHERE nombre = @nombre) 
	BEGIN
		IF EXISTS(SELECT 1 FROM TipoServicio WHERE idTipoServicio=@idTipoServicio) 
		BEGIN
			-- Actualización del tipo de servicio
			UPDATE TipoServicio
			SET nombre = @nombre
			WHERE idTipoServicio=@idTipoServicio
		END
		ELSE
		BEGIN
			-- Inserción de un nuevo tipo de servicio
			INSERT INTO TipoServicio(nombre)
			VALUES(@nombre)
		END
	END 
	ELSE
	BEGIN 
		PRINT 'El tipo de servicio ya está registrado'
	END
END


/*
Nombre del procedimiento: paActualizaSolicitudServicio
Propósito: Actualiza o inserta información de una solicitud de servicio en la base de datos.
Parámetros de entrada:
    - @idSolicitudServicio: Identificador único de la solicitud de servicio.
    - @idSolicitud: Identificador único de la solicitud asociada.
    - @idTipoServicio: Identificador único del tipo de servicio asociado.
*/
CREATE PROCEDURE paActualizaSolicitudServicio
(
    @idSolicitudServicio SMALLINT,
    @idSolicitud SMALLINT,
    @idTipoServicio TINYINT 
)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM Solicitud WHERE idSolicitud = @idSolicitud) 
	BEGIN
		IF EXISTS(SELECT 1 FROM TipoServicio WHERE idTipoServicio = @idTipoServicio) 
		BEGIN
			IF EXISTS(SELECT 1 FROM SolicitudServicio WHERE idSolicitudServicio = @idSolicitudServicio) 
			BEGIN
				-- Actualización de la solicitud de servicio
				UPDATE SolicitudServicio
				SET idSolicitud = @idSolicitud,
					idTipoServicio = @idTipoServicio
				WHERE idSolicitudServicio = @idSolicitudServicio
			END
			ELSE
			BEGIN
				-- Inserción de una nueva solicitud de servicio
				INSERT INTO SolicitudServicio(idSolicitud, idTipoServicio)
				VALUES(@idSolicitud, @idSolicitudServicio)
			END
		END
		ELSE
		BEGIN 
			PRINT 'El idTipoServicio no está registrado en TipoServicio' 
		END
	END
	ELSE
	BEGIN 
		PRINT 'El idSolicitud no está registrado en Solicitud' 
	END
END


/*
Nombre del procedimiento: paActualizaPropuesta
Propósito: Actualiza o inserta información de una propuesta en la base de datos.
Parámetros de entrada:
    - @idPropuesta: Identificador único de la propuesta.
    - @idSolicitud: Identificador único de la solicitud asociada a la propuesta.
    - @fecha: Fecha de la propuesta.
    - @hora: Hora de la propuesta.
    - @costo: Costo de la propuesta.
*/
CREATE PROCEDURE paActualizaPropuesta
	@idPropuesta SMALLINT,
    @idSolicitud SMALLINT,
    @fecha DATE,
    @hora TIME,
    @costo NUMERIC(7,2)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM Solicitud WHERE idSolicitud = @idSolicitud) 
	BEGIN
		IF EXISTS(SELECT 1 FROM Propuesta WHERE idPropuesta=@idPropuesta) 
		BEGIN
			-- Actualización de la propuesta
			UPDATE Propuesta
			SET idSolicitud = @idSolicitud,
				fecha = @fecha,
				hora = @hora,
				costo = @costo
			WHERE idPropuesta=@idPropuesta
		END
		ELSE
		BEGIN
			-- Inserción de una nueva propuesta
			INSERT INTO Propuesta(idSolicitud,fecha,hora,costo)
			VALUES(@idSolicitud,@fecha,@hora,@costo)
		END
	END
	ELSE 
	BEGIN 
		PRINT 'idSolicitud NO REGISTRADA EN Solicitud' 
	END
END


/*
Nombre del procedimiento: paActualizaDAP
Propósito: Actualiza o inserta información de un detalle de artículo de una propuesta en la base de datos.
Parámetros de entrada:
    - @idDetalleArticuloPropuesta: Identificador único del detalle de artículo de la propuesta.
    - @idPropuesta: Identificador único de la propuesta asociada al detalle de artículo.
    - @idArticulo: Identificador único del artículo asociado al detalle de artículo.
    - @dimensiones: Dimensiones del artículo.
    - @cantidad: Cantidad del artículo.
    - @precioVenta: Precio de venta del artículo.
*/
CREATE PROCEDURE paActualizaDAP
	@idDetalleArticuloPropuesta SMALLINT,
    @idPropuesta SMALLINT,
   	@idArticulo INT,
   	@dimensiones VARCHAR(50),
   	@cantidad SMALLINT,
   	@precioVenta NUMERIC(7,2)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM Propuesta WHERE idPropuesta = @idPropuesta) 
	BEGIN
		IF EXISTS(SELECT 1 FROM Articulo WHERE idArticulo = @idArticulo) 
		BEGIN
			IF EXISTS(SELECT 1 FROM DetalleArticuloPropuesta WHERE idDetalleArticuloPropuesta = @idDetalleArticuloPropuesta) 
			BEGIN
				-- Actualización del detalle de artículo de la propuesta
				UPDATE DetalleArticuloPropuesta
				SET idPropuesta = @idPropuesta,
					idArticulo = @idArticulo,
					dimensiones = @dimensiones,
					cantidad = @cantidad,
					precioVenta = @precioVenta
				WHERE idDetalleArticuloPropuesta = @idDetalleArticuloPropuesta
			END
			ELSE
			BEGIN
				-- Inserción de un nuevo detalle de artículo de la propuesta
				INSERT INTO DetalleArticuloPropuesta(idPropuesta,idArticulo,dimensiones,cantidad,precioVenta)
				VALUES(@idPropuesta,@idArticulo,@dimensiones,@cantidad,@precioVenta)
			END
		END 
		ELSE 
		BEGIN 
			PRINT 'idArticulo NO REGISTRADO en ARTICULO' 
		END
	END 
	ELSE 
	BEGIN 
		PRINT 'idPropuesta NO REGISTRADO en Propuesta' 
	END
END


/*
Nombre del procedimiento: paActualizaArticuloMP
Propósito: Actualiza o inserta información de un artículo de materia prima en la base de datos.
Parámetros de entrada:
    - @idArticuloMateriaPrima: Identificador único del artículo de materia prima.
    - @idArticulo: Identificador único del artículo asociado.
    - @idMateriaPrima: Identificador único de la materia prima asociada.
    - @cantidadMateriaPrima: Cantidad de la materia prima.
    - @unidadMedida: Unidad de medida de la materia prima.
*/
CREATE PROCEDURE paActualizaArticuloMP
	@idArticuloMateriaPrima SMALLINT,
	@idArticulo INT,
   	@idMateriaPrima SMALLINT,
   	@cantidadMateriaPrima INT,
   	@unidadMedida CHAR(10)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM Articulo WHERE idArticulo = @idArticulo) 
	BEGIN
		IF EXISTS(SELECT 1 FROM MateriaPrima WHERE idMateriaPrima = @idMateriaPrima) 
		BEGIN
			IF EXISTS (SELECT 1 FROM ArticuloMateriaPrima WHERE idArticuloMateriaPrima = @idArticuloMateriaPrima ) 
			BEGIN
				-- Actualización del artículo de materia prima
				UPDATE ArticuloMateriaPrima
				SET idArticulo = @idArticulo,
					idMateriaPrima = @idMateriaPrima,
					cantidadMateriaPrima = @cantidadMateriaPrima,
					unidadMedida = @unidadMedida
				WHERE idArticuloMateriaPrima = @idArticuloMateriaPrima
			END
			ELSE 
			BEGIN
				-- Inserción de un nuevo artículo de materia prima
				INSERT INTO ArticuloMateriaPrima(idArticulo, idMateriaPrima, cantidadMateriaPrima, unidadMedida)
				VALUES(@idArticulo,@idMateriaPrima,@cantidadMateriaPrima,@unidadMedida)
			END
		END 
		ELSE 
		BEGIN 
			PRINT 'idMateriaPrima NO REGISTRADA en MateriaPrima' 
		END
	END 
	ELSE 
	BEGIN 
		PRINT 'idArticulo NO REGISTRA EN Articulo' 
	END
END


/*
Nombre del procedimiento: paActualizaTipoComprobante
Propósito: Actualiza o inserta información de un tipo de comprobante en la base de datos.
Parámetros de entrada:
    - @idTipoComprobante: Identificador único del tipo de comprobante.
    - @nombre: Nombre del tipo de comprobante.
*/
CREATE PROCEDURE paActualizaTipoComprobante
	@idTipoComprobante TINYINT,
	@nombre VARCHAR(50)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM TipoComprobante WHERE nombre = @nombre) 
	BEGIN
		IF EXISTS(SELECT 1 FROM TipoComprobante

 WHERE idTipoComprobante = @idTipoComprobante ) 
		BEGIN
			-- Actualización del tipo de comprobante
			UPDATE TipoComprobante
			SET nombre = @nombre
			WHERE idTipoComprobante = @idTipoComprobante 
		END
		ELSE
		BEGIN
			-- Inserción de un nuevo tipo de comprobante
			INSERT INTO TipoComprobante(nombre)
			VALUES(@nombre)
		END
	END
END


/*
Nombre del procedimiento: paActualizaTipoContrato
Propósito: Actualiza o inserta información de un tipo de contrato en la base de datos.
Parámetros de entrada:
    - @idTipoContrato: Identificador único del tipo de contrato.
    - @nombre: Nombre del tipo de contrato.
*/
CREATE PROCEDURE paActualizaTipoContrato
	@idTipoContrato TINYINT,
	@nombre VARCHAR(30) 
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM TipoContrato WHERE nombre = @nombre) 
	BEGIN
		IF EXISTS(SELECT 1 FROM TipoContrato WHERE idTipoContrato = @idTipoContrato ) 
		BEGIN
			-- Actualización del tipo de contrato
			UPDATE TipoContrato
			SET nombre = @nombre
			WHERE idTipoContrato = @idTipoContrato 
		END
		ELSE
		BEGIN
			-- Inserción de un nuevo tipo de contrato
			INSERT INTO TipoContrato(nombre)
			VALUES(@nombre)
		END
	END
END


/*
Nombre del procedimiento: paActualizaContrato
Propósito: Actualiza o inserta información de un contrato en la base de datos.
Parámetros de entrada:
    - @idContrato: Identificador único del contrato.
    - @idPropuesta: Identificador único de la propuesta asociada al contrato.
    - @idTipoContrato: Identificador único del tipo de contrato asociado.
    - @idEmpleado: Identificador único del empleado asociado al contrato.
    - @fechaHora: Fecha y hora del contrato.
    - @montoContrato: Monto del contrato.
    - @montoAdelanto: Monto del adelanto del contrato.
    - @tiempoRealizar: Tiempo estimado para realizar el contrato.
    - @descripcion: Descripción del contrato.
    - @estado: Estado del contrato.
*/
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
	IF EXISTS(SELECT 1 FROM Propuesta WHERE idPropuesta=@idPropuesta) 
	BEGIN
		IF EXISTS(SELECT 1 FROM TipoContrato WHERE idTipoContrato=@idTipoContrato) 
		BEGIN
			IF EXISTS(SELECT 1 FROM Empleado WHERE idEmpleado=@idEmpleado) 
			BEGIN
				IF NOT EXISTS(SELECT 1 FROM Contrato WHERE idPropuesta = @idPropuesta) 
				BEGIN
					IF EXISTS(SELECT 1 FROM Contrato WHERE idContrato=@idContrato) 
					BEGIN
						-- Actualización del contrato
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
						-- Inserción de un nuevo contrato
						INSERT INTO Contrato
						VALUES(@idPropuesta,@idTipoContrato,@idEmpleado,@fechaHora,@montoContrato,@montoAdelanto,@tiempoRealizar,@descripcion,'A')
					END
				END
				ELSE
				BEGIN 
					PRINT 'idPropuesta NO REGISTRADO EN LA TABALA PROPUESTA' 
				END
			END
			ELSE 
			BEGIN 
				PRINT 'idEmpleado NO REGISTRADO EN LA TABLA EMPLEADO' 
			END
		END
		ELSE 
		BEGIN 
			PRINT 'idContrato NO REGISTRADO EN LA TABLA CONTRATO' 
		END
	END
	ELSE 
	BEGIN 
		PRINT 'idPropuesta NO REGISTRADA EN LA TABLA PROPUESTA' 
	END
END
*/

/*
Nombre del procedimiento: paActualizaComprobante
Propósito: Actualiza o inserta información de un comprobante en la base de datos.
Parámetros de entrada:
    - @idComprobante: Identificador único del comprobante.
    - @idContrato: Identificador único del contrato asociado al comprobante.
    - @idTipoComprobante: Identificador único del tipo de comprobante asociado.
    - @nSerie: Número de serie del comprobante.
    - @nComprobante: Número del comprobante.
    - @fecha: Fecha del comprobante.
    - @hora: Hora del comprobante.
    - @subtotal: Subtotal del comprobante.
    - @igv: IGV del comprobante.
    - @total: Total del comprobante.
*/
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
AS
BEGIN
	IF EXISTS(SELECT 1 FROM Contrato WHERE idContrato=@idContrato) 
	BEGIN
		IF EXISTS(SELECT 1 FROM TipoComprobante WHERE idTipoComprobante=@idTipoComprobante) 
		BEGIN
			IF NOT EXISTS(SELECT 1 FROM Comprobante WHERE idContrato=@idContrato) 
			BEGIN
				IF EXISTS(SELECT 1 FROM Comprobante WHERE idComprobante=@idComprobante) 
				BEGIN
					-- Actualización del comprobante
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


				ELSE 
				BEGIN 
					-- Inserción de un nuevo comprobante
					INSERT INTO Comprobante
					VALUES(@idContrato,@idTipoComprobante,@nSerie,@nComprobante,@fecha,@hora,@subtotal,@igv,@total)
				END
			END
			ELSE 
			BEGIN 
				PRINT 'Ya se registro el comprobante de ese contrato' 
			END
		END
		ELSE 
		BEGIN 
			PRINT 'idTipoComprobante NO REGISTRADO EN TipoComprobante' 
		END
	END 
	ELSE 
	BEGIN 
		PRINT 'idContrato NO REGISTRADO EN Contrato(NO EXISTE ESE CONTRATO' 
	END
END
*/

/*
Nombre del procedimiento: paActualizaDetalleComprobante
Propósito: Actualiza o inserta información de un detalle de comprobante en la base de datos.
Parámetros de entrada:
    - @idDetalleComprobante: Identificador único del detalle de comprobante.
    - @idArticulo: Identificador único del artículo asociado al detalle de comprobante.
    - @idComprobante: Identificador único del comprobante asociado al detalle de comprobante.
    - @cantidad: Cantidad del artículo.
    - @precioVenta: Precio de venta del artículo.
    - @subtotal: Subtotal del detalle de comprobante.
*/
CREATE PROCEDURE paActualizaDetalleComprobante
	@idDetalleComprobante INT,
   	@idArticulo INT,
   	@idComprobante INT,
   	@cantidad SMALLINT,
   	@precioVenta NUMERIC(7,2),
   	@subtotal NUMERIC(7,2)
AS
BEGIN	
	IF EXISTS(SELECT 1 FROM DetalleComprobante WHERE idDetalleComprobante=@idDetalleComprobante) 
	BEGIN
		-- Actualización del detalle de comprobante
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
		-- Inserción de un nuevo detalle de comprobante
		INSERT INTO DetalleComprobante
		VALUES(@idArticulo,@idComprobante,@cantidad,@precioVenta,@subtotal,@idDetalleComprobante)
	END
END
*/

/*
Nombre del procedimiento: paActualizaTipoPago
Propósito: Actualiza o inserta información de un tipo de pago en la base de datos.
Parámetros de entrada:
    - @idTipoPago: Identificador único del tipo de pago.
    - @nombre: Nombre del tipo de pago.
*/
CREATE PROCEDURE paActualizaTipoPago
	@idTipoPago TINYINT,
	@nombre VARCHAR(50)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM TipoPago WHERE nombre=@nombre) 
	BEGIN
		IF EXISTS(SELECT 1 FROM TipoPago WHERE idTipoPago=@idTipoPago) 
		BEGIN
			-- Actualización del tipo de pago
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
*/

/*
Nombre del procedimiento: paActualizaDetalleComprobanteTipoPago
Propósito: Actualiza o inserta información de un detalle de comprobante tipo pago en la base de datos.
Parámetros de entrada:
    - @idDetalleComprobanteTipoPago: Identificador único del detalle de comprobante tipo pago.
    - @idComprobante: Identificador único del comprobante asociado.
    - @idTipoPago: Identificador único del tipo de pago asociado.
    - @monto: Monto del detalle de comprobante tipo pago.
*/
CREATE PROCEDURE paActualizaDetalleComprobanteTipoPago
	@idDetalleComprobanteTipoPago SMALLINT,
    @idComprobante INT,
   	@idTipoPago TINYINT,
   	@monto NUMERIC(7,2) 
AS
BEGIN
	IF EXISTS(SELECT 1 FROM Comprobante WHERE idComprobante = @idComprobante) 
	BEGIN
		IF EXISTS(SELECT 1 FROM TipoPago  WHERE idTipoPago=@idTipoPago) 
		BEGIN
			IF EXISTS(SELECT 1 FROM DetalleComprobanteTipoPago WHERE idDetalleComprobanteTipoPago=@idDetalleComprobanteTipoPago) 
			BEGIN
				-- Actualización del detalle de comprobante tipo pago
				UPDATE DetalleComprobanteTipoPago
				SET idComprobante=@idComprobante,
					idTipoPago=@idTipoPago,
					monto=@monto
				WHERE idDetalleComprobanteTipoPago=@idDetalleComprobanteTipoPago
			END
			ELSE
			BEGIN
				-- Inserción de un nuevo detalle de comprobante tipo pago
				INSERT INTO DetalleComprobanteTipoPago
				VALUES(@idComprobante,@idTipoPago,@monto)
			END
		END
		ELSE 
		BEGIN 
			PRINT 'Tipo de pago -NO EXISTE' 
		END
	END
	ELSE
	BEGIN
		PRINT 'Comprobante -NO EXISTE'
	END
END

Aquí tienes los procedimientos almacenados documentados y comentados:

```sql
-- ContratoEmpleado
/*
Nombre del procedimiento: paActualizaContratoEmpleado
Propósito: Actualiza o inserta información de un contrato de empleado en la base de datos.
Parámetros de entrada:
    - @idContratoEmpleado: Identificador único del contrato de empleado.
    - @idContrato: Identificador único del contrato asociado.
    - @idEmpleado: Identificador único del empleado asociado.
*/
CREATE PROCEDURE paActualizaContratoEmpleado
    @idContratoEmpleado SMALLINT,
    @idContrato SMALLINT,
    @idEmpleado SMALLINT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM Contrato WHERE idContrato = @idContrato) 
    BEGIN
        IF EXISTS(SELECT 1 FROM Empleado WHERE idEmpleado = @idEmpleado) 
        BEGIN
            IF EXISTS(SELECT 1 FROM ContratoEmpleado WHERE idContratoEmpleado = @idContratoEmpleado) 
            BEGIN
                -- Actualización
                UPDATE ContratoEmpleado
                SET idContrato = @idContrato,
                    idEmpleado = @idEmpleado
                WHERE idContratoEmpleado = @idContratoEmpleado
            END
            ELSE
            BEGIN
                -- Inserción
                INSERT INTO ContratoEmpleado
                VALUES(@idContrato, @idEmpleado)
            END
        END
        ELSE
        BEGIN
            PRINT 'ERROR: El empleado especificado no existe.'
        END
    END
    ELSE
    BEGIN
        PRINT 'ERROR: El contrato especificado no existe.'
    END
END

-- Anulacion
/*
Nombre del procedimiento: paActualizaAnulacion
Propósito: Actualiza o inserta información de una anulación en la base de datos.
Parámetros de entrada:
    - @idAnulacion: Identificador único de la anulación.
    - @fecha: Fecha de la anulación.
    - @hora: Hora de la anulación.
    - @idContrato: Identificador único del contrato asociado.
    - @idEmpleado: Identificador único del empleado asociado.
*/
CREATE PROCEDURE paActualizaAnulacion
    @idAnulacion SMALLINT,
    @fecha DATE,
    @hora TIME,
    @idContrato SMALLINT,
    @idEmpleado SMALLINT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM Contrato WHERE idContrato = @idContrato) 
    BEGIN
        IF EXISTS(SELECT 1 FROM Empleado WHERE idEmpleado = @idEmpleado) 
        BEGIN
            IF NOT EXISTS(SELECT 1 FROM Anulacion WHERE idContrato = @idContrato) 
            BEGIN
                IF EXISTS(SELECT 1 FROM Anulacion WHERE idAnulacion = @idAnulacion) 
                BEGIN
                    -- Actualización
                    UPDATE Anulacion
                    SET fecha = @fecha,
                        hora = @hora,
                        idContrato = @idContrato,
                        idEmpleado = @idEmpleado
                    WHERE idAnulacion = @idAnulacion
                END
                ELSE
                BEGIN
                    -- Inserción
                    INSERT INTO Anulacion
                    VALUES(@fecha, @hora, @idContrato, @idEmpleado)
                END
            END
            ELSE
            BEGIN
                PRINT 'ERROR: El contrato ya ha sido anulado.'
            END
        END
        ELSE
        BEGIN
            PRINT 'ERROR: El empleado especificado no existe.'
        END
    END
    ELSE
    BEGIN
        PRINT 'ERROR: El contrato especificado no existe.'
    END
END

-- ProveedorMateriaPrima
/*
Nombre del procedimiento: paActualizaProveedorMateriaPrima
Propósito: Actualiza o inserta información de un proveedor de materia prima en la base de datos.
Parámetros de entrada:
    - @idProveedorMateriaPrima: Identificador único del proveedor de materia prima.
    - @idProveedor: Identificador único del proveedor asociado.
    - @idMateriaPrima: Identificador único de la materia prima asociada.
    - @precioMateriaPrima: Precio de la materia prima.
    - @fechaCompra: Fecha de compra de la materia prima.
    - @cantidad: Cantidad de materia prima comprada.
    - @unidadMedida: Unidad de medida de la materia prima.
*/
CREATE PROCEDURE paActualizaProveedorMateriaPrima
    @idProveedorMateriaPrima INT,
    @idProveedor SMALLINT,
    @idMateriaPrima SMALLINT,
    @precioMateriaPrima NUMERIC(5,2),
    @fechaCompra DATE,
    @cantidad SMALLINT,
    @unidadMedida VARCHAR(20) 
AS
BEGIN
    IF EXISTS(SELECT 1 FROM Proveedor WHERE idProveedor = @idProveedor) 
    BEGIN
        IF EXISTS(SELECT 1 FROM MateriaPrima WHERE idMateriaPrima = @idMateriaPrima) 
        BEGIN
            IF EXISTS(SELECT 1 FROM ProveedorMateriaPrima WHERE idProveedorMateriaPrima = @idProveedorMateriaPrima) 
            BEGIN
                -- Actualización
                UPDATE ProveedorMateriaPrima
                SET idProveedor = @idProveedor,
                    idMateriaPrima = @idMateriaPrima,
                    precioMateriaPrima = @precioMateriaPrima,
                    fechaCompra = @fechaCompra,
                    cantidad = @cantidad,
                    unidadMedida = @unidadMedida
                WHERE idProveedorMateriaPrima = @idProveedorMateriaPrima
            END
            ELSE
            BEGIN
                -- Inserción
                INSERT INTO ProveedorMateriaPrima
                VALUES(@idProveedor, @idMateriaPrima, @precioMateriaPrima, @fechaCompra, @cantidad, @unidadMedida)
            END
        END
        ELSE
        BEGIN
            PRINT 'ERROR: La materia prima especificada no existe.'
        END
    END
    ELSE
    BEGIN
        PRINT 'ERROR: El proveedor especificado no existe.'
    END
END


------------------------2. Dos funciones escalares, deberá describir cuál es su funcionalidad agregando
------------------------comentarios dentro de la función.


-- Función: datosCliente
-- Descripción: Obtiene los datos completos de un cliente a partir de su ID, incluyendo nombre, apellidos y tipo de persona.
-- Parámetros de entrada:
--   @idCliente: ID del cliente del cual se desean obtener los datos.
-- Retorna: Una cadena de caracteres que contiene el mensaje de cliente encontrado o no encontrado junto con los datos del cliente si se encuentra.
CREATE FUNCTION dbo.datosCliente(@idCliente smallint)
RETURNS VARCHAR(MAX)
AS
BEGIN
  -- Declaración de variables
  DECLARE @nombre VARCHAR(50), @apellidoPaterno VARCHAR(50), @apellidoMaterno VARCHAR(50), @idPersona smallint, @mensaje varchar(50);

  -- Verifica la existencia del cliente
  IF EXISTS(SELECT 1 FROM Cliente WHERE idCliente = @idCliente) BEGIN
    -- Se establece mensaje de cliente encontrado
    SET @mensaje = 'CLIENTE ENCONTRADO';

    -- Se guarda el idPersona del cliente que coincida con el idCliente pasado como parámetro
    SELECT @idPersona=idPersona
    FROM Cliente
    WHERE idCliente = @idCliente;

    -- En caso exista ese idPersona en la tabla PersonaNatural, se toman dichos datos
    IF EXISTS(SELECT 1 FROM PersonaNatural WHERE idPersona = @idPersona) BEGIN
      SELECT @nombre = nombre, @apellidoPaterno = apPat, @apellidoMaterno = apMat
      FROM PersonaNatural
      WHERE idPersona = @idPersona;
    END
    -- Caso contrario, no existe, quiere decir que es una persona jurídica, por tanto se toman dichos datos
    ELSE BEGIN
      SELECT @nombre = razonSocial
      FROM PersonaJuridica
      WHERE idPersona = @idPersona;
    END
  END
  -- Caso contrario, el cliente no existe, se establece un mensaje para el usuario
  ELSE BEGIN
    SET @mensaje = 'CLIENTE NO ENCONTRADO';
  END

  -- Concatenar los datos para obtener los datos completos
  RETURN CONCAT(@mensaje, ': ', @nombre, ' ', @apellidoPaterno, ' ', @apellidoMaterno);
END;


-- Función: TotalVentasPorDia
-- Descripción: Obtiene el total de ventas por día a partir de una fecha dada.
-- Parámetros de entrada:
--   @fecha: La fecha para la cual se desea obtener el total de ventas.
-- Retorna: Un valor decimal que representa el total de ventas para la fecha especificada.
CREATE FUNCTION dbo.TotalVentasPorDia(@fecha DATE)
RETURNS DECIMAL(10,2)
AS
BEGIN
  -- Declarar una variable para almacenar el total
  DECLARE @totalVentas DECIMAL(10,2);

  -- Selecciona la suma del 'total' de la tabla Comprobante y guárdala en la variable
  SELECT @totalVentas = SUM(c.total)
  FROM Comprobante c
  -- Filtrando para cuando las fechas coincidan
  WHERE c.fecha = @fecha;

  -- Retorna el valor almacenado en la variable, es decir, retorna el total de ventas
  RETURN @totalVentas;
END;


--3. Dos vistas en las que use JOIN. Igual agregar comentarios al script en el cual expliquen
--la utilidad de las vistas.
---Muestra los contratos que se encuentran vigentes (estado = 'A')
---Función: poder visualizar los contratos que se encuentran activos, para tener un mejor 
------------manejo de la información,además se considera que es mucha ayuda.



-- Vista: vContratosVigentes
-- Descripción: Muestra los contratos que se encuentran vigentes (estado = 'A').
-- Función: Esta vista proporciona una manera conveniente de visualizar los contratos activos, 
-- lo que ayuda en la gestión de la información al proporcionar una lista clara de los contratos en curso.
CREATE VIEW vContratosVigentes
AS
SELECT
  -- Selecciona el idContrato, la fechaHora del contrato, el monto del contrato y la descripción
  c.idContrato,
  c.fechaHora,
  c.montoContrato,
  c.descripcion,
  -- Además, muestra el nombre del cliente asociado al contrato
  CASE 
    WHEN EXISTS(SELECT 1 FROM PersonaNatural pn WHERE idPersona = p.idPersona) THEN 
      (SELECT pn.nombre FROM PersonaNatural pn WHERE pn.idPersona = p.idPersona)
    WHEN EXISTS(SELECT 1 FROM PersonaJuridica pj WHERE idPersona = p.idPersona) THEN 
      (SELECT pj.razonSocial FROM PersonaJuridica pj WHERE pj.idPersona = p.idPersona)
  END AS 'Cliente'
FROM Contrato c
-- Realiza inner joins entre las tablas para relacionar los datos necesarios
INNER JOIN Empleado e ON e.idEmpleado = c.idEmpleado
INNER JOIN Propuesta pp ON pp.idPropuesta = c.idPropuesta
INNER JOIN Solicitud s ON pp.idSolicitud = s.idSolicitud
INNER JOIN Cliente cc ON cc.idCliente = s.idCliente
INNER JOIN Persona p ON p.idPersona = cc.idPersona
-- Filtra los contratos por el estado 'A' (activo)
WHERE c.estado = 'A';

-- Selecciona todos los datos de la vista vContratosVigentes
SELECT * FROM vContratosVigentes;

-- Elimina la vista vContratosVigentes
DROP VIEW vContratosVigentes;


-- Vista: vDetalleArticulosPorContrato
-- Descripción: Muestra el detalle de artículos vendidos por contrato.
-- Función: Esta vista permite visualizar qué artículos se han vendido más, lo que facilita la identificación de los productos más populares.
CREATE VIEW vDetalleArticulosPorContrato
AS
SELECT
  -- Selecciona el nombre del artículo y la cantidad vendida del mismo
  a.nombre AS 'Nombre del artículo',
  SUM(dc.cantidad) AS 'Cantidad vendida'
-- Los datos se obtienen de la tabla DetalleComprobante
FROM DetalleComprobante dc
-- Realiza inner joins con las tablas necesarias para relacionar los datos
INNER JOIN Comprobante c ON c.idComprobante = dc.idComprobante
INNER JOIN Articulo a ON a.idArticulo = dc.idArticulo
-- Agrupa los datos por el nombre del artículo
GROUP BY a.nombre;

-- Selecciona todos los datos de la vista vDetalleArticulosPorContrato y los ordena por la cantidad vendida en orden descendente
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


---Columna critica → precioUnitario del articulo
create table tAuditoriaArticulo(
	id int,
	idArticulo int,
	fechaCambio date,
	precioNuevo numeric,
	precioAntiguo numeric,
	Usuario varchar(50)
)

-- Trigger para la tabla Articulo
/*
Nombre del Trigger: tr_Articulo
Propósito: Captura los cambios en la columna crítica 'precioUnitario' de la tabla Articulo y registra los detalles en la tabla de auditoría 'tAuditoriaArticulo'.
*/
CREATE TRIGGER tr_Articulo
ON Articulo
AFTER UPDATE
AS
BEGIN
    -- Declarar variables para almacenar valores relevantes
    DECLARE @idArticulo int, @precioNuevo numeric, @precioAntiguo numeric;

    -- Obtener los valores actualizados y antiguos de precioUnitario
    SELECT @idArticulo = i.idArticulo, @precioAntiguo = d.precioUnitario, @precioNuevo = i.precioUnitario
    FROM inserted i
    INNER JOIN deleted d ON i.idArticulo = d.idArticulo;

    -- Verificar si el precioUnitario se ha actualizado
    IF UPDATE(precioUnitario) BEGIN
        -- Insertar los datos relevantes en la tabla de auditoría
        INSERT INTO tAuditoriaArticulo 
        VALUES (@idArticulo, GETDATE(), @precioNuevo, @precioAntiguo, SYSTEM_USER());
    END;
END;


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

-- Trigger para la tabla Pagos
/*
Nombre del Trigger: tr_Pagos
Propósito: Captura los cambios en la columna crítica 'monto' de la tabla Pagos y registra los detalles en la tabla de auditoría 'tAuditoriaPagos'.
*/
CREATE TRIGGER tr_Pagos
ON Pagos
AFTER UPDATE
AS
BEGIN
    -- Declarar variables para almacenar valores relevantes
    DECLARE @idPago int, @idEmpleado numeric, @montoNuevo numeric, @montoAntiguo numeric;

    -- Obtener los valores actualizados y antiguos de monto
    SELECT @idPago = i.idPago, @montoNuevo = i.monto, @montoAntiguo = d.monto, @idEmpleado = i.idEmpleado
    FROM inserted i
    INNER JOIN deleted d ON i.idPago = d.idPago;

    -- Verificar si el monto se ha actualizado
    IF UPDATE(monto) BEGIN
        -- Insertar los datos relevantes en la tabla de auditoría
        INSERT INTO tAuditoriaPagos 
        VALUES (@idPago, @idEmpleado, @montoNuevo, @montoAntiguo, GETDATE(), SYSTEM_USER());
    END;
END;

--5. Crear también dos triggers que considere importantes y explicar en qué consisten 
--y porqué es importante implementarlos.

-- Trigger para actualizar la entrada en el inventario de materia prima
/*
Nombre del Trigger: Actualizar_entrada_InventarioMateriaPrima
Propósito: Actualizar el inventario de materia prima cuando se inserta una nueva entrada en la tabla ProveedorMateriaPrima.
Explicación: Este trigger se dispara después de una inserción en la tabla ProveedorMateriaPrima. Su objetivo es actualizar el inventario de materia prima sumando la cantidad de materia prima que ha entrado en el almacén. Esto garantiza que el inventario se mantenga actualizado y se refleje correctamente la cantidad disponible de materia prima en el sistema.
*/
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
			SET ip.entradaMateria = ip.entradaMateria + @cantidad -- Corrección de la sintaxis, cambio de '+=' a '+'
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

-- Trigger para actualizar la salida en el inventario de materia prima
/*
Nombre del Trigger: tr_DetalleComprobante
Propósito: Actualizar el inventario de materia prima cuando se inserta un nuevo detalle en la tabla DetalleComprobante.
Explicación: Este trigger se dispara después de una inserción en la tabla DetalleComprobante. Su objetivo es actualizar el inventario de materia prima restando la cantidad correspondiente a la salida de materia prima asociada a la venta de un artículo. Esto asegura que el inventario se mantenga actualizado y refleje correctamente la cantidad disponible de materia prima después de cada venta.
*/
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



--7. Elaborar un procedimiento almacenado que incluya el uso de cursores, justificar
--con comentarios dentro del procedimiento en el que se explique porqué es necesario 
--usar el cursor en el cual se va recorriendo fila por fila y no hacerlo
--en un solo comando Transact-SQL.


-- Procedimiento almacenado: pa_muestra_Articulo_xComprobante
-- Propósito: Mostrar los detalles de los artículos vendidos en los comprobantes de una fecha específica.
-- Parámetros de entrada:
--   - @fecha: Fecha para la cual se desean mostrar los detalles de los artículos vendidos, especificamente por mes .
CREATE PROCEDURE pa_muestra_Articulo_xComprobante
    @fecha DATE
AS 
BEGIN 
    -- Verificar si existen comprobantes para la fecha especificada
    IF EXISTS (SELECT 1 FROM Comprobante WHERE MONTH(fecha) = MONTH(@fecha))
    BEGIN
        -- Declarar variables para almacenar información del artículo
        DECLARE @nombre VARCHAR(100), @precio NUMERIC(7,2);
        
        -- Declarar el cursor para obtener los detalles de los artículos vendidos en los comprobantes
        DECLARE c_articulo CURSOR FOR
        SELECT a.nombre, a.precio
        FROM DetalleComprobante c
        JOIN Comprobante d ON d.idComprobante = c.idComprobante
        JOIN Articulo a ON a.idArticulo = d.idArticulo
        WHERE MONTH(d.fecha) = MONTH(@fecha);
        
        -- Abrir el cursor
        OPEN c_articulo;
        
        -- Recorrer fila por fila los detalles de los artículos vendidos
        FETCH NEXT FROM c_articulo INTO @nombre, @precio;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Mostrar la información del artículo
            PRINT 'Articulo: ' + @nombre + ' Precio: ' + CAST(@precio AS VARCHAR(50));
            FETCH NEXT FROM c_articulo INTO @nombre, @precio;
        END;
        
        -- Cerrar y liberar el cursor
        CLOSE c_articulo;
        DEALLOCATE c_articulo;
    END
    ELSE 
    BEGIN
        -- Mostrar mensaje si no se encontraron comprobantes para la fecha especificada
        PRINT 'No se encontraron artículos vendidos para la fecha: ' + CAST(@fecha AS VARCHAR(10));
    END;
END;
