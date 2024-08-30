--2

CREATE DATABASE CM_V1
USE CM_V1


Create Table PersonaNatural(
	idPersonaNatural smallint identity(1,1) PRIMARY KEY not null,
	idCliente smallint not null,
	nombre varchar(100) not null,
	apPat varchar(50) not null,
	apMat varchar(50) null,
	dni char(8) UNIQUE not null,
	direccion varchar(150) not null,
	telefono char(9) UNIQUE not null,
	email varchar(50) UNIQUE not null,
)
ALTER TABLE PersonaNatural
ADD CONSTRAINT CK_dniNumeros CHECK(dni LIKE '%[0-9]%'),
CONSTRAINT CK_dniOcho CHECK(len(dni) = 8 ),
CONSTRAINT CK_telefonoNumero CHECK(telefono LIKE '%[0-9]%')


Create Table PersonaJuridica(
	idPersJuridica smallint identity(1,1) PRIMARY KEY not null,
	idCliente smallint not null,
	razonSocial varchar(150) not null,
	ruc char(11) UNIQUE not null ,
	direccion varchar(150) not null,
	telefono char(9) UNIQUE not null ,
	email varchar(50) UNIQUE not null ,
)


ALTER TABLE PersonaJuridica
ADD CONSTRAINT CK_rucNumeros CHECK(ruc LIKE '%[0-9]%'),
CONSTRAINT CK_rucOnce CHECK(len(ruc) = 11),
CONSTRAINT CK_telefonoNumeros CHECK(telefono LIKE '%[0-9]%')





Create table Cliente(
	idCliente smallint identity(1,1) PRIMARY KEY not null,
	idCategoria tinyint not null,
	idPersona smallint not null
)

ALTER TABLE PersonaJuridica
	ADD CONSTRAINT FK_PersonaJuridica_Cliente
	FOREIGN KEY (idCliente)
	REFERENCES Cliente(idCliente)

ALTER TABLE PersonaNatural
	ADD CONSTRAINT FK_PersonaNatural_Cliente
	FOREIGN KEY (idCliente)
	REFERENCES Cliente(idCliente)


Create table Categoria(
	idCategoria tinyint identity(1,1)  PRIMARY KEY not null,
	nombre varchar(50) not null,
	descripcion varchar(100) not null
)

Create table Persona(
	idPersona smallint identity(1,1) PRIMARY KEY not null,
	nombre varchar(100) not null,
	apPat varchar(50) not null,
	apMat varchar(50) null,
	dni char(8) UNIQUE not null,
	telefono char(9) UNIQUE not null,
	email varchar(50) UNIQUE not null,
	direccion varchar(150) not null,
)


ALTER TABLE Persona
ADD CONSTRAINT CK_dniPersona CHECK(dni  LIKE '%[0-9]%'),
CONSTRAINT CK_dniPersonaOcho CHECK(len(dni) = 8 ),
CONSTRAINT CK_telefonoNumeros_persona CHECK(telefono LIKE '%[0-9]%')


ALTER TABLE Cliente
	ADD CONSTRAINT FK_Cliente_Categoria
	FOREIGN KEY (idCategoria)
	REFERENCES Categoria(idCategoria)


ALTER TABLE Cliente
	ADD CONSTRAINT FK_Persona_Cliente_Persona
	FOREIGN KEY (idPersona)
	REFERENCES Persona(idPersona)



Create Table Solicitud(
	idSolicitud smallint identity(1,1) PRIMARY KEY not null,
	idCliente smallint not null,
	idSecretario tinyint not null,
	fechaHora datetime not null,
	descripcion varchar(250) not null,
)

Create table Secretario(
	idSecretario tinyint identity(1,1) not null PRIMARY KEY,
	idPersona smallint not null
)
ALTER TABLE Secretario
	ADD CONSTRAINT FK_Secretario_Persona
	FOREIGN KEY (idPersona)
	REFERENCES Persona(idPersona)

ALTER TABLE Solicitud
	ADD CONSTRAINT FK_Solicitud_Cliente
	FOREIGN KEY (idCliente)
	REFERENCES Cliente (idCliente)

ALTER TABLE Solicitud 
	ADD CONSTRAINT FK_Solicitud_Secretario
	FOREIGN KEY (idSecretario)
	REFERENCES Secretario(idSecretario)



Create table TipoServicio(
	idTipoServicio tinyint identity(1,1) PRIMARY KEY not null,
	nombre varchar(100) not null
)

Create table SolicitudServicio(
	idSolicitudServicio smallint identity(1,1) PRIMARY KEY not null,
	idSolicitud smallint not null,
	idTipoServicio tinyint not null,
)


ALTER TABLE SolicitudServicio
	ADD CONSTRAINT FK_SolicitudServicio_Solicitud
	FOREIGN KEY (idSolicitud)
	REFERENCES Solicitud(idSolicitud)


ALTER TABLE SolicitudServicio
	ADD CONSTRAINT FK_SolicitudServicio_TipoServicio
	FOREIGN KEY (idTipoServicio)
	REFERENCES TipoServicio(idTipoServicio)


Create Table Propuesta(
	idPropuesta smallint identity(1,1) PRIMARY KEY not null,
	idSolicitud smallint not null,
	fecha date not null,
	hora time not null,
	costo numeric(5,2) not null,
	descuento numeric(5,2) not null,
	descripcion varchar(250) not null,
)



ALTER TABLE Propuesta
ADD CONSTRAINT CK_costoPropuesta CHECK(costo > 0),
CONSTRAINT CK_descuentoPropuesta CHECK(descuento >=0 )


ALTER TABLE Propuesta
	ADD CONSTRAINT FK_Propuesta_Solicitud
	FOREIGN KEY (idSolicitud)
	REFERENCES Solicitud(idSolicitud)



Create Table TipoContrato(
idTipoContrato tinyint identity(1,1) PRIMARY KEY not null,
nombre varchar(30) not null,--MAYORISTA O MINORISTA
)

Create table Contrato(
	idContrato smallint identity(1,1) PRIMARY KEY not null,
	idPropuesta smallint not null,
	idTipoContrato tinyint not null,
	idEncargadoVenta tinyint not null,
	fechaHora datetime not null,
	montoTotal numeric(5,2) not null,
	tiempoRealizar tinyint not null,
	descripcion varchar(250) not null,
	estado char(1) not null, --A:anulado; E:en cruso
)

ALTER TABLE Contrato
ADD CONSTRAINT CK_montoTotalContrato CHECK(montoTotal > 0),
CONSTRAINT CK_estadoContrato CHECK(estado IN ('A','I') )


ALTER TABLE Contrato
	ADD CONSTRAINT FK_Contrato_Propuesta
	FOREIGN KEY (idPropuesta)
	REFERENCES Propuesta(idPropuesta)

ALTER TABLE Contrato 
	ADD CONSTRAINT FK_Contrato_TipoContrato
	FOREIGN KEY (idTipoContrato)
	REFERENCES TipoContrato(idTipoContrato)





Create table Orfebre(
	idOrfebre tinyint identity(1,1) PRIMARY KEY not null,
	fechaInicio date not null,
	fechaCese date not null,
	idPersona smallint not null,
	estado char(1) not null --A:activo; I:inactivo
)
ALTER TABLE Orfebre ADD
CONSTRAINT CK_estadoOrfebre CHECK( estado IN('A','I') )--A:activo,I:inactivo

ALTER TABLE Orfebre
	ADD CONSTRAINT FK_Orfebre_Persona
	FOREIGN KEY (idPersona)
	REFERENCES Persona(idPersona)

Create table ContratoOrfebre(
	idContratoOrfebre smallint identity(1,1) PRIMARY KEY not null,
	idContrato smallint not null,
	idOrfebre tinyint not null
)
ALTER TABLE ContratoOrfebre
	ADD CONSTRAINT FK_ContratoOrfebre_Contrato
	FOREIGN KEY(idContrato)
	REFERENCES Contrato(idContrato)
ALTER TABLE ContratoOrfebre
	ADD CONSTRAINT FK_ContratoOrfebre_Orfebre
	FOREIGN KEY(idOrfebre)
	REFERENCES Orfebre(idOrfebre)

-----------------------------------------------------



Create table EncargadoVenta(
	idEncargadoVenta tinyint identity(1,1)  PRIMARY KEY not null,
	idPersona smallint not null
)
ALTER TABLE EncargadoVenta
		ADD CONSTRAINT FK_EncargadoVenta_Persona
		FOREIGN KEY (idPersona)
		REFERENCES Persona(idPersona)


ALTER TABLE Contrato
	ADD CONSTRAINT FK_Contrato_EncargadoVenta
	FOREIGN KEY (idEncargadoVenta)
	REFERENCES EncargadoVenta(idEncargadoVenta)






Create table TipoComprobante(
idTipoComprobante tinyint identity(1,1) PRIMARY KEY not null ,
nombre varchar(50) not null
)

Create table TipoPago(
idTipoPago tinyint identity(1,1) PRIMARY KEY not null,
nombre varchar(50) not null
)

Create table Pago(
idPago smallint identity(1,1) not null PRIMARY KEY,
idContrato smallint not null,
fechaHora Datetime not null,
montoTotal numeric(5,2) not null,
montoRestante numeric(5,2) not null,
montoPagar numeric(5,2) not null,
igv numeric(5,2) not null,
idTipoComprobante tinyint not null,
idTipoPago tinyint not null,
subtotal NUMERIC(5,2) NOT NULL
)


ALTER TABLE Pago
ADD CONSTRAINT CK_igvPago CHECK(igv > 0),
CONSTRAINT CK_subtotalPago CHECK(subtotal > 0), 
CONSTRAINT CK_subtotaligv CHECK(subtotal = montoTotal / 1.18),
CONSTRAINT CK_MontoTotalNoNegativo CHECK (montoTotal > 0),
CONSTRAINT CK_MontoRestanteNoNegativo CHECK (montoRestante >= 0),
CONSTRAINT CK_MontoPagarNoNegativo CHECK (montoPagar >= 0),
CONSTRAINT CK_MontoPagarNoMayorMontoRestante CHECK (montoPagar <= montoRestante);






ALTER TABLE Pago
	ADD CONSTRAINT FK_Pago_Contrato
	FOREIGN KEY (idContrato)
	REFERENCES Contrato(idContrato)

ALTER TABLE Pago
	ADD CONSTRAINT FK_Pago_TipoComprobante
	FOREIGN KEY (idTipoComprobante)
	REFERENCES TipoComprobante(idTipoComprobante)

ALTER TABLE Pago
	ADD CONSTRAINT FK_Pago_TipoPago
	FOREIGN KEY (idTipoPago)
	REFERENCES TipoPago(idTipoPago)


Create table Administrador(
	idAdministrador tinyint identity(1,1) PRIMARY KEY not null,
	idPersona smallint not null
)
ALTER TABLE Administrador
	ADD CONSTRAINT FK_Administrador_Persona
	FOREIGN KEY (idPersona)
	REFERENCES Persona(idPersona)


Create table Anulacion(
	idAnulacion smallint identity(1,1) PRIMARY KEY not null,
	fecha date not null,
	hora time not null,
	idContrato smallint not null,
	idAdministrador tinyint not null
)
ALTER TABLE Anulacion
	ADD CONSTRAINT FK_Anulacion_Contrato
	FOREIGN KEY (idContrato)
	REFERENCES Contrato(idContrato)

ALTER TABLE Anulacion
	ADD CONSTRAINT FK_Anulacion_Administrador
	FOREIGN KEY (idAdministrador)
	REFERENCES Administrador(idAdministrador)


Create table Costurera(
	idCosturera tinyint identity(1,1) PRIMARY KEY not null,
	fechaInicio date not null,
	fechaCese date not null,
	idPersona smallint not null,
	estado char(1) not null, --A:activo, I:inactivo
 )

 ALTER TABLE Costurera ADD
CONSTRAINT CK_estadoCosturera CHECK( estado IN('A','I') )--A:activo,I:inactivo

 ALTER TABLE Costurera
	ADD CONSTRAINT FK_Costurea_Persona
	FOREIGN KEY (idPersona)
	REFERENCES Persona(idPersona)

Create table ContratoCosturera(
	idContratoCosturera smallint identity(1,1) PRIMARY KEY not null,
	idContrato smallint not null,
	idCosturera tinyint not null
)
ALTER TABLE ContratoCosturera
	ADD CONSTRAINT FK_ContratoCosturera_Contrato
	FOREIGN KEY (idContrato)
	REFERENCES Contrato(idContrato)
ALTER TABLE ContratoCosturera
	ADD CONSTRAINT FK_ContratoCosturera_Costurera
	FOREIGN KEY (idCosturera)
	REFERENCES Costurera(idCosturera)



Create table CategoriaMateriaPrima(
	idCategoriaMateriaPrima tinyint identity(1,1) PRIMARY KEY not null,
	nombre varchar(150) not null
)

CREATE TABLE MateriaPrima(
	idMateriaPrima smallint identity(1,1) PRIMARY KEY not null,
	idCategoriaMateriaPrima tinyint not null,
	nombre varchar(150) not null
)


ALTER TABLE MateriaPrima
	ADD CONSTRAINT FK_MateriaPrima_CategoriaMateriaPrima
	FOREIGN KEY (idCategoriaMateriaPrima)
	REFERENCES CategoriaMateriaPrima(idCategoriaMateriaPrima)


CREATE TABLE ContratoMateriaPrima(
	idContrato_MateriaPrima smallint identity(1,1) PRIMARY KEY not null,
	idContrato smallint not null,
	idMateriaPrima smallint not null,
	cantidad smallint not null
)

ALTER TABLE ContratoMateriaPrima
ADD CONSTRAINT CK_CantidadNoNegativo CHECK (cantidad > 0);


ALTER TABLE ContratoMateriaPrima
	ADD CONSTRAINT ContratoMateriaPrima_Contrato
	FOREIGN KEY (idContrato)
	REFERENCES Contrato(idContrato)

ALTER TABLE ContratoMateriaPrima
	ADD CONSTRAINT ContratoMateriaPrima_MateriaPrima
	FOREIGN KEY (idMateriaPrima)
	REFERENCES MateriaPrima(idMateriaPrima)


	
CREATE TABLE Proveedor(
	idProveedor SMALLINT IDENTITY(1,1) PRIMARY KEY,
	razonSocial VARCHAR(150) NOT NULL,
	direccion VARCHAR(150) NOT NULL,
	ruc CHAR(11) UNIQUE NOT NULL,
	telefono CHAR(9) UNIQUE NOT NULL,
	email VARCHAR(50) UNIQUE NOT NULL
)



CREATE TABLE ProveedorMateriaPrima(
	idProveedorMateriaPrima SMALLINT IDENTITY(1,1) PRIMARY KEY,
	idProveedor SMALLINT NOT NULL,
	idMateriaPrima SMALLINT NOT NULL,
	precioMateriaPrima NUMERIC(5,2) NOT NULL,
	fechaCompra DATE NOT NULL,
	cantidad SMALLINT NOT NULL,
	unidadMedida VARCHAR(20) NOT NULL
)

ALTER TABLE ProveedorMateriaPrima
ADD CONSTRAINT CK_CantidadNoNegativo_ProveedorMateria_Prima CHECK (cantidad > 0),
CONSTRAINT CK_unidadMedida_ProveedorMateria_Prima CHECK( unidadMedida IN ('m','kg','kt'))

ALTER TABLE ProveedorMateriaPrima ADD
CONSTRAINT FK_ProveedorMateriaPrima_Proveedor 
FOREIGN KEY (idProveedor) 
REFERENCES Proveedor(idProveedor),
CONSTRAINT FK_ProveedorMateriaPrima_MateriaPrima
FOREIGN KEY (idMateriaPrima)
REFERENCES MateriaPrima(idMateriaPrima)

CREATE TABLE Inventario(
	idInventario SMALLINT IDENTITY(1,1) PRIMARY KEY,
	idProveedorMateriaPrima SMALLINT NOT NULL,
	fechaActualizacion DATETIME NOT NULL,
	entradaMateriaPrima SMALLINT NOT NULL,
	salidaMateria SMALLINT NOT NULL,
	stockInsumo SMALLINT NOT NULL
)


ALTER TABLE Inventario
ADD CONSTRAINT CK_EntradaNoNegativoInventario CHECK (entradaMateriaPrima >= 0),
CONSTRAINT CK_SalidaNonNegativeInventario CHECK (salidaMateria >= 0),
CONSTRAINT CK_StockNoNegativoInventario CHECK (stockInsumo >= 0),
CONSTRAINT CK_ConsistenciaStockInventario CHECK (stockInsumo = entradaMateriaPrima - salidaMateria);

ALTER TABLE Inventario ADD
CONSTRAINT FK_Inventario_ProveedorMateriaPrima 
FOREIGN KEY (idProveedorMateriaPrima) 
REFERENCES ProveedorMateriaPrima(idProveedorMateriaPrima)

---------------------------------------------------------------


CREATE NONCLUSTERED INDEX IDX_DNI_PersonaNatural
ON PersonaNatural(DNI);


CREATE NONCLUSTERED INDEX IDX_IDCategoria_Cliente
ON Cliente(idCategoria);

CREATE NONCLUSTERED INDEX IDX_IDPersona_Cliente
ON Cliente(idPersona);


CREATE NONCLUSTERED INDEX IDX_FechaHora_Solicitud
ON Solicitud(fechaHora);


CREATE NONCLUSTERED INDEX IDX_IDPropuesta_Contrato
ON Contrato(idPropuesta);

CREATE NONCLUSTERED INDEX IDX_Estado_Contrato
ON Contrato(estado);


CREATE NONCLUSTERED INDEX IDX_IDContrato_Pago
ON Pago(idContrato);

CREATE NONCLUSTERED INDEX IDX_FechaHora_Pago
ON Pago(fechaHora);