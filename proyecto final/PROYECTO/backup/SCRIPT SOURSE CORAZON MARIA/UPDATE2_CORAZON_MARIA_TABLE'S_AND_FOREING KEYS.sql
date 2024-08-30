
--------BASE DE DATOS MEJORADA-CORAZÓN DE MARIA---------
CREATE DATABASE CORAZON_MARIA_UPDATE1
USE CORAZON_MARIA_UPDATE1


CREATE TABLE PersonaNatural(
    idPersonaNatural SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idPersona SMALLINT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apPat VARCHAR(50) NOT NULL,
    apMat VARCHAR(50) NULL,
    dni CHAR(8) UNIQUE NOT NULL
);


CREATE TABLE PersonaJuridica(
    idPersJuridica SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idPersona SMALLINT NOT NULL,
    razonSocial VARCHAR(150) NOT NULL
);

CREATE TABLE Telefono(
    idTelefono SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    numeroTelefono CHAR(9) NOT NULL
);

CREATE TABLE Persona(
    idPersona SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idTelefono SMALLINT NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    direccion VARCHAR(150) NOT NULL,
	ruc CHAR(11) not null
);

CREATE TABLE tipoProveedor(
    idtipoProveedor TINYINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    nombre VARCHAR(40) NOT NULL
);

CREATE TABLE Proveedor(
    idProveedor SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idPersona	SMALLINT NOT NULL,
	idtipoProveedor TINYINT NOT NULL
);

CREATE TABLE Cargo(
	idCargo TINYINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Empleado(
	idEmpleado SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	idCargo TINYINT NOT NULL,
	idPersona SMALLINT NOT NULL,
	fechaIngreso DATE NOT NULL,
	fechaCese DATE NULL,
	estado CHAR(1) NOT NULL
);

CREATE TABLE Pagos(
	idPagos SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	idEmpleado SMALLINT NOT NULL,
	monto NUMERIC(7,2) NOT NULL,
	fecha DATE  NOT NULL
);

CREATE TABLE CategoriaMateriaPrima(
    idCategoriaMateriaPrima TINYINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    nombre VARCHAR(150) NOT NULL
);

CREATE TABLE MateriaPrima(
    idMateriaPrima SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idCategoriaMateriaPrima TINYINT NOT NULL,
    nombre VARCHAR(150) NOT NULL
);

CREATE TABLE TipoArticulo(
	idTipoArticulo TINYINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	nombre VARCHAR(40) NOT NULL
);

CREATE TABLE Articulo(
    idArticulo INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idTipoArticulo TINYINT NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    precioUnitario NUMERIC(7,2) NOT NULL
);

CREATE TABLE InventarioMateriaPrima(
    idInventarioMateriaPrima INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idMateriaPrima SMALLINT NOT NULL, 
	entradaMateria SMALLINT NOT NULL,
    salidaMateria SMALLINT NOT NULL
);

CREATE TABLE InventarioProducto(
    idInventarioProducto INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idArticulo INT NOT NULL,
    entrada SMALLINT NOT NULL,
    salida SMALLINT NOT NULL
);

CREATE TABLE Categoria(
    idCategoria TINYINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100) NOT NULL
);


CREATE TABLE Cliente(
    idCliente SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idCategoria TINYINT NOT NULL,
    idPersona SMALLINT NOT NULL
);


CREATE TABLE Solicitud(
    idSolicitud SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idCliente SMALLINT NOT NULL,
    idEmpleado SMALLINT NOT NULL,
    fechaHora DATETIME NOT NULL,
    descripcion VARCHAR(250) NULL
);
alter table Solicitud alter column descripcion VARCHAR(250) NULL

CREATE TABLE TipoServicio(
    idTipoServicio TINYINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE SolicitudServicio(
    idSolicitudServicio SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idSolicitud SMALLINT NOT NULL,
    idTipoServicio TINYINT NOT NULL
);


CREATE TABLE Propuesta(
    idPropuesta SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idSolicitud SMALLINT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    costo NUMERIC(7,2) NOT NULL
);

CREATE TABLE DetalleArticuloPropuesta(
    idDetalleArticuloPropuesta SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
    idPropuesta SMALLINT NOT NULL,
	idArticulo INT NOT NULL,
	dimensiones VARCHAR(50) NOT NULL,
	cantidad SMALLINT NOT NULL,
	precioVenta NUMERIC(7,2) NOT NULL
);


CREATE TABLE ArticuloMateriaPrima(
    idArticuloMateriaPrima SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idArticulo INT NOT NULL,
	idMateriaPrima SMALLINT NOT NULL,
	cantidadMateriaPrima INT NOT NULL,
	unidadMedida char(10) NOT NULL
);

CREATE TABLE TipoComprobante(
	idTipoComprobante TINYINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	nombre VARCHAR(50) NOT NULL
);


CREATE TABLE TipoContrato(
    idTipoContrato TINYINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    nombre VARCHAR(30) NOT NULL
);

CREATE TABLE Contrato(
    idContrato SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idPropuesta SMALLINT NOT NULL,
    idTipoContrato TINYINT NOT NULL,
    idEmpleado SMALLINT NOT NULL,
    fechaHora DATETIME NOT NULL,
    montoContrato NUMERIC(5,2) NOT NULL,
	montoAdelanto NUMERIC(5,2) NOT NULL,
    tiempoRealizar TINYINT NOT NULL,
    descripcion VARCHAR(250) NOT NULL,
    estado CHAR(1) NOT NULL,
	motivo_Anulacion  text,
	fechaHora_Anulacion datetime,
	usuario_Anulacion varchar(100)
);

CREATE TABLE Comprobante(
    idComprobante INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idContrato SMALLINT NOT NULL,
	idTipoComprobante TINYINT NOT NULL,
	nSerie CHAR(4) NOT NULL,
	nComprobante CHAR(8) NOT NULL,
	fecha DATE NOT NULL,
	hora TIME NOT NULL,
	subtotal NUMERIC(7,2) NOT NULL,
	igv NUMERIC(7,2) NOT NULL,
	total NUMERIC(7,2) NOT NULL
);



CREATE TABLE DetalleComprobante(
	idDetalleComprobante INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	idArticulo INT NOT NULL,
	idComprobante INT NOT NULL,
	cantidad SMALLINT NOT NULL,
	precioVenta NUMERIC(7,2) NOT NULL,
	subtotal NUMERIC(7,2) NOT NULL
);

CREATE TABLE TipoPago(
    idTipoPago TINYINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE DetalleComprobanteTipoPago(
    idDetalleComprobanteTipoPago SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idComprobante INT NOT NULL,
	idTipoPago TINYINT NOT NULL,
	monto NUMERIC(7,2) NOT NULL
);

CREATE TABLE ContratoEmpleado(
    idContratoEmpleado SMALLINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idContrato SMALLINT NOT NULL,
    idEmpleado SMALLINT NOT NULL
);




CREATE TABLE ProveedorMateriaPrima(
    idProveedorMateriaPrima INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    idProveedor SMALLINT NOT NULL,
    idMateriaPrima SMALLINT NOT NULL,
    precioMateriaPrima NUMERIC(5,2) NOT NULL,
    fechaCompra DATE NOT NULL,
    cantidad SMALLINT NOT NULL,
    unidadMedida VARCHAR(20) NOT NULL
);


--CREACIÓN DE CLAVES FORANEAS

-- PersonaNatural
ALTER TABLE PersonaNatural
    ADD CONSTRAINT FK_PersonaNatural_Persona
    FOREIGN KEY (idPersona)
    REFERENCES Persona(idPersona);

-- PersonaJuridica
ALTER TABLE PersonaJuridica
    ADD CONSTRAINT FK_PersonaJuridica_Persona
    FOREIGN KEY (idPersona)
    REFERENCES Persona(idPersona);
-- Telefono
ALTER TABLE Persona
    ADD CONSTRAINT FK_Persona_Telefono
    FOREIGN KEY (idTelefono)
    REFERENCES Telefono(idTelefono);

-- Proveedor
ALTER TABLE Proveedor
    ADD CONSTRAINT FK_Proveedor_Persona
    FOREIGN KEY (idPersona)
    REFERENCES Persona(idPersona),
    CONSTRAINT FK_Proveedor_TipoProveedor
    FOREIGN KEY (idtipoProveedor)
    REFERENCES tipoProveedor(idtipoProveedor);

-- Empleado
ALTER TABLE Empleado
    ADD CONSTRAINT FK_Empleado_Cargo
    FOREIGN KEY (idCargo)
    REFERENCES Cargo(idCargo),
    CONSTRAINT FK_Empleado_Persona
    FOREIGN KEY (idPersona)
    REFERENCES Persona(idPersona);

-- Pagos
ALTER TABLE Pagos
    ADD CONSTRAINT FK_Pagos_Empleado
    FOREIGN KEY (idEmpleado)
    REFERENCES Empleado(idEmpleado);

-- MateriaPrima
ALTER TABLE MateriaPrima
    ADD CONSTRAINT FK_CategoriaMateriaPrima_MateriaPrima
    FOREIGN KEY (idCategoriaMateriaPrima)
    REFERENCES CategoriaMateriaPrima(idCategoriaMateriaPrima)


-- Articulo
ALTER TABLE Articulo
    ADD CONSTRAINT FK_TipoArticulo_Articulo
    FOREIGN KEY (idTipoArticulo)
    REFERENCES TipoArticulo(idTipoArticulo)

-- InventarioMateriaPrima
ALTER TABLE InventarioMateriaPrima
    ADD CONSTRAINT FK_InventarioMateriaPrima_MateriaPrima
    FOREIGN KEY (idMateriaPrima)
    REFERENCES MateriaPrima(idMateriaPrima)

-- InventarioProducto
ALTER TABLE InventarioProducto
    ADD CONSTRAINT FK_InventarioProducto_Articulo
    FOREIGN KEY (idArticulo)
    REFERENCES Articulo(idArticulo);

-- Cliente
ALTER TABLE Cliente
    ADD CONSTRAINT FK_Cliente_Categoria
    FOREIGN KEY (idCategoria)
    REFERENCES Categoria(idCategoria),
    CONSTRAINT FK_Cliente_Persona
    FOREIGN KEY (idPersona)
    REFERENCES Persona(idPersona);

-- Solicitud
ALTER TABLE Solicitud
    ADD CONSTRAINT FK_Solicitud_Cliente
    FOREIGN KEY (idCliente)
    REFERENCES Cliente(idCliente),
    CONSTRAINT FK_Solicitud_Empleado
    FOREIGN KEY (idEmpleado)
    REFERENCES Empleado(idEmpleado);

-- SolicitudServicio
ALTER TABLE SolicitudServicio
    ADD CONSTRAINT FK_SolicitudServicio_Solicitud
    FOREIGN KEY (idSolicitud)
    REFERENCES Solicitud(idSolicitud),
    CONSTRAINT FK_SolicitudServicio_TipoServicio
    FOREIGN KEY (idTipoServicio)
    REFERENCES TipoServicio(idTipoServicio);

-- Propuesta
ALTER TABLE Propuesta
    ADD CONSTRAINT FK_Propuesta_Solicitud
    FOREIGN KEY (idSolicitud)
    REFERENCES Solicitud(idSolicitud);

-- DetalleArticuloPropuesta
ALTER TABLE DetalleArticuloPropuesta
    ADD CONSTRAINT FK_DetalleArticuloPropuesta_Propuesta
    FOREIGN KEY (idPropuesta)
    REFERENCES Propuesta(idPropuesta),
    CONSTRAINT FK_DetalleArticuloPropuesta_Articulo
    FOREIGN KEY (idArticulo)
    REFERENCES Articulo(idArticulo);

-- ArticuloMateriaPrima
ALTER TABLE ArticuloMateriaPrima
    ADD CONSTRAINT FK_ArticuloMateriaPrima_Articulo
    FOREIGN KEY (idArticulo)
    REFERENCES Articulo(idArticulo),
    CONSTRAINT FK_ArticuloMateriaPrima_MateriaPrima
    FOREIGN KEY (idMateriaPrima)
    REFERENCES MateriaPrima(idMateriaPrima);
	
-- Contrato
ALTER TABLE Contrato
    ADD CONSTRAINT FK_Contrato_Propuesta
    FOREIGN KEY (idPropuesta)
    REFERENCES Propuesta(idPropuesta),
    CONSTRAINT FK_Contrato_TipoContrato
    FOREIGN KEY (idTipoContrato)
    REFERENCES TipoContrato(idTipoContrato),
    CONSTRAINT FK_Contrato_Empleado
    FOREIGN KEY (idEmpleado)
    REFERENCES Empleado(idEmpleado);


-- Comprobante
ALTER TABLE Comprobante
    ADD CONSTRAINT FK_Comprobante_Contrato
    FOREIGN KEY (idContrato)
    REFERENCES Contrato(idContrato),
    CONSTRAINT FK_Comprobante_TipoComprobante
    FOREIGN KEY (idTipoComprobante)
    REFERENCES TipoComprobante(idTipoComprobante);

-- DetalleComprobante
ALTER TABLE DetalleComprobante
    ADD CONSTRAINT FK_DetalleComprobante_Articulo
    FOREIGN KEY (idArticulo)
    REFERENCES Articulo(idArticulo),
    CONSTRAINT FK_DetalleComprobante_Comprobante
    FOREIGN KEY (idComprobante)
    REFERENCES Comprobante(idComprobante);

-- DetalleComprobanteTipoPago
ALTER TABLE DetalleComprobanteTipoPago
    ADD CONSTRAINT FK_DetalleComprobanteTipoPago_Comprobante
    FOREIGN KEY (idComprobante)
    REFERENCES Comprobante(idComprobante),
    CONSTRAINT FK_DetalleComprobanteTipoPago_TipoPago
    FOREIGN KEY (idTipoPago)
    REFERENCES TipoPago(idTipoPago);


-- ContratoEmpleado
ALTER TABLE ContratoEmpleado
    ADD CONSTRAINT FK_ContratoEmpleado_Contrato
    FOREIGN KEY (idContrato)
    REFERENCES Contrato(idContrato),
    CONSTRAINT FK_ContratoEmpleado_Empleado
    FOREIGN KEY (idEmpleado)
    REFERENCES Empleado(idEmpleado);

---- Anulacion
--ALTER TABLE Anulacion
--    ADD CONSTRAINT FK_Anulacion_Contrato
--    FOREIGN KEY (idContrato)
--    REFERENCES Contrato(idContrato),
--    CONSTRAINT FK_Anulacion_Empleado
--    FOREIGN KEY (idEmpleado)
--    REFERENCES Empleado(idEmpleado);

-- ProveedorMateriaPrima
ALTER TABLE ProveedorMateriaPrima
    ADD CONSTRAINT FK_ProveedorMateriaPrima_Proveedor
    FOREIGN KEY (idProveedor)
    REFERENCES Proveedor(idProveedor),
    CONSTRAINT FK_ProveedorMateriaPrima_MateriaPrima
    FOREIGN KEY (idMateriaPrima)
    REFERENCES MateriaPrima(idMateriaPrima);

-----------------------------------------------CREACION DE RESTRICCIONES CHECK y UNIQUE 

--PersonaNatural
ALTER TABLE PersonaNatural
ADD CONSTRAINT CK_dniNumeros CHECK(dni LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
CONSTRAINT CK_dniOcho CHECK(LEN(dni) = 8  );


--PersonaJuridica

ALTER TABLE PersonaJuridica
ADD CONSTRAINT chk_razonSocial_no_vacia
CHECK ( razonSocial <> '');

--Propuesta

ALTER TABLE Propuesta
ADD CONSTRAINT CK_costoPropuesta CHECK(costo > 0);

--Contrato

ALTER TABLE Contrato
ADD CONSTRAINT CK_montoAdelanto CHECK(montoAdelanto > 0),
CONSTRAINT CK_montoContrato CHECK(montoContrato >= 0),
CONSTRAINT CK_tiempoRealizar CHECK (tiempoRealizar > 0),
CONSTRAINT CK_estadoContrato CHECK(estado IN ('A','I') );

--Comprobante

ALTER TABLE Comprobante
ADD CONSTRAINT CK_serie CHECK (nSerie LIKE '[A-Z][0-9][0-9][0-9]'),
CONSTRAINT CK_nComprobante CHECK (nComprobante LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
CONSTRAINT UQ_comprobante UNIQUE(nSerie,nComprobante), 
CONSTRAINT CK_igvComprobante CHECK(igv > 0),--el igv sacado siempre es positivo
CONSTRAINT CK_subtotalComprobante CHECK(subtotal > 0),--Siempre tendremos un monto positivo
CONSTRAINT CK_totalComprobante CHECK(total = igv + subtotal),--Para comprobar el total y no hayan incoherencias
CONSTRAINT CK_igv18 CHECK(igv = total - subtotal),--para verificar si el igv sacado coincide
CONSTRAINT CK_subtotaligv CHECK(subtotal = total / 1.18);--verificamos que el subtotal sea el correcto

--Empleado

ALTER TABLE Empleado ADD
CONSTRAINT CK_empleado CHECK( estado IN('A','I') ),--A:activo,I:inactivo
 CONSTRAINT CK_fechaIngreso CHECK(fechaIngreso <= GETDATE()), -- La fecha de ingreso no puede ser en el futuro
CONSTRAINT CK_fechaCese CHECK(fechaCese >= fechaIngreso); -- La fecha de cese debe ser posterior o igual a la fecha de ingreso

--ProveedorMateriaPrima

ALTER TABLE ProveedorMateriaPrima
ADD CONSTRAINT CK_CantidadNoNegativo_ProveedorMateria_Prima CHECK (cantidad > 0),
CONSTRAINT CK_unidadMedida_ProveedorMateria_Prima CHECK( unidadMedida IN ('m','kg','kt'));


--InventarioMateriaPrima
ALTER TABLE InventarioMateriaPrima
ADD CONSTRAINT CK_EntradaNoNegativoInventarioMateriaPrima CHECK (entradaMateria >= 0),
CONSTRAINT CK_SalidaNonNegativeInventarioMateriaPrima CHECK (salidaMateria >= 0);

---CategoriaMateriaPrima
ALTER TABLE CategoriaMateriaPrima
ADD CONSTRAINT UQ_nombre_unico_categoria UNIQUE(nombre),
CONSTRAINT CK_nombre_noVacio_CategoriaMateriaPrima CHECK(nombre <> '');

--InventarioProducto
ALTER TABLE InventarioProducto
ADD CONSTRAINT CK_EntradaNoNegativoInventarioProducto CHECK (entrada >= 0),
CONSTRAINT CK_SalidaNonNegativeInventarioProducto CHECK (salida >= 0);

--TipoPago

ALTER TABLE TipoPago
ADD CONSTRAINT UQ_nombre_unico_TipoPago UNIQUE(nombre),
CONSTRAINT CK_nombre_noVacio_TipoPago CHECK(nombre <> '');

--TipoArticulo

ALTER TABLE TipoArticulo
ADD CONSTRAINT UQ_nombre_unico_TipoArticulo UNIQUE(nombre),
CONSTRAINT CK_nombre_noVacio_TipoArticulo CHECK(nombre <> '');

--TipoContrato

ALTER TABLE TipoContrato
ADD CONSTRAINT UQ_nombre_unico_TipoContrato UNIQUE(nombre),
CONSTRAINT CK_nombre_noVacio_TipoContrato CHECK(nombre <> '');

--TipoServicio
ALTER TABLE TipoServicio
ADD CONSTRAINT UQ_nombre_unico_TipoServicio UNIQUE(nombre),
CONSTRAINT CK_nombre_noVacio_TipoServicio CHECK(nombre <> '');

--Cargo

ALTER TABLE Cargo
ADD CONSTRAINT UQ_nombre_unico_Cargo UNIQUE(nombre),
CONSTRAINT CK_nombre_noVacio_Cargo CHECK(nombre <> '');

--TipoComprobante

ALTER TABLE TipoComprobante
ADD CONSTRAINT UQ_nombre_unico_TipoComprobante UNIQUE(nombre),
CONSTRAINT CK_nombre_noVacio_TipoComprobante CHECK(nombre <> '');

--Telefono
ALTER TABLE Telefono
ADD CONSTRAINT CK_telefono_formato CHECK(numeroTelefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'), -- Verifica que el teléfono comience con un dígito
CONSTRAINT CK_longitud_telefono CHECK(LEN(numeroTelefono) >= 6 AND LEN(numeroTelefono) <= 9); -- Si es telefono de casa son 6 a 7 dig, si es celular son 9 dig

--Persona 
ALTER TABLE Persona
ADD CONSTRAINT CK_ruc_formato 
CHECK ( (SUBSTRING(ruc, 1, 2) IN ('10', '20')) AND -- Verifica el formato del inicio de RUC 10 o RUC 20
    LEN(ruc) = 11 AND -- Verifica la longitud del RUC
    ruc LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'); -- Verifica que solo contiene dígitos numéricos


----CREACIÓN DE INDICES

-- Índices de la tabla PersonaNatural
CREATE NONCLUSTERED INDEX IDX_DNI_PersonaNatural
ON PersonaNatural(dni);

-- Índices de la tabla Cliente
CREATE NONCLUSTERED INDEX IDX_IDCategoria_Cliente
ON Cliente(idCategoria);

CREATE NONCLUSTERED INDEX IDX_IDPersona_Cliente
ON Cliente(idPersona);

-- Índices de la tabla Solicitud
CREATE NONCLUSTERED INDEX IDX_FechaHora_Solicitud
ON Solicitud(fechaHora);

-- Índices de la tabla Contrato
CREATE NONCLUSTERED INDEX IDX_IDPropuesta_Contrato
ON Contrato(idPropuesta);

CREATE NONCLUSTERED INDEX IDX_Estado_Contrato
ON Contrato(estado);

-- Índice de la tabla Persona para la columna ruc
CREATE NONCLUSTERED INDEX IDX_ruc_Persona
ON Persona(ruc);

