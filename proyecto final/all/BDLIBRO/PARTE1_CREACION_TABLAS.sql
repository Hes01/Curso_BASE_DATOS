USE MASTER
GO

SET DATEFORMAT YMD
GO

IF DB_ID('BDVENTAS') IS NOT NULL DROP DATABASE BDVENTAS
GO

CREATE DATABASE BDVENTAS
GO

USE BDVENTAS
GO

CREATE TABLE DISTRITO(
COD_DIS CHAR(5) NOT NULL PRIMARY KEY,
NOM_DIS VARCHAR(50) NOT NULL
)
GO

CREATE TABLE VENDEDOR( 
COD_VEN CHAR(3) NOT NULL PRIMARY KEY,
NOM_VEN VARCHAR(20) NOT NULL,
APE_VEN VARCHAR(20) NOT NULL,
SUE_VEN MONEY NOT NULL,---SUELDO VENDEDOR
FIN_VEN DATE NOT NULL,
TIP_VEN VARCHAR(10) NOT NULL,
COD_DIS CHAR(5) NOT NULL REFERENCES DISTRITO --FK
)
GO

CREATE TABLE CLIENTE(
COD_CLI CHAR(5) NOT NULL PRIMARY KEY,
RSO_CLI CHAR(30) NOT NULL,--RAZON SOCIAL
DIR_CLI VARCHAR(100) NOT NULL,
TLF_CLI VARCHAR(9) NOT NULL,
RUC_CLI CHAR(11) NULL,
COD_DIS CHAR(5) NOT NULL REFERENCES DISTRITO,
FEC_REG DATE NOT NULL,
TIP_CLI VARCHAR(10) NOT NULL,
CON_CLI VARCHAR(30) NOT NULL
)
GO

CREATE TABLE PROVEEDOR(
	COD_PRV CHAR(5) NOT NULL PRIMARY KEY,
	RSO_PRV VARCHAR(80) NOT NULL,
	DIR_PRV VARCHAR(100) NOT NULL,
	TEL_PRV CHAR(15) NULL,
	COD_DIS CHAR(5) NOT NULL REFERENCES DISTRITO,
	REP_PRV VARCHAR(80) NOT NULL
)
GO

CREATE TABLE FACTURA(
	NUM_FAC VARCHAR(12) NOT NULL PRIMARY KEY,
	FEC_FAC DATE NOT NULL,
	COD_CLI CHAR(5) NOT NULL REFERENCES CLIENTE,
	FEC_CAN DATE NOT NULL,
	EST_FAC VARCHAR(10) NOT NULL,
	COD_VEN CHAR(3) NOT NULL REFERENCES VENDEDOR,
	POR_IGV DECIMAL NOT NULL
)
GO

CREATE TABLE ORDEN_COMPRA(
	NUM_OCO CHAR(5) NOT NULL PRIMARY KEY,
	FEC_OCO DATE NOT NULL,
	COD_PRV CHAR(5) NOT NULL REFERENCES PROVEEDOR,
	FAT_OCO DATE NOT NULL,
	EST_OCO CHAR(1) NOT NULL
)
GO
EXECUTE sp_rename ORDEN_FACTURA, ORDEN_COMPRA

CREATE TABLE PRODUCTO(
	COD_PRO CHAR(5) NOT NULL PRIMARY KEY,
	DES_PRO VARCHAR(50) NOT NULL,
	PRE_PRO MONEY NOT NULL,
	SAC_PRO INT NOT NULL,
	SMI_PRO INT NOT NULL,
	UNI_PRO VARCHAR(30) NOT NULL,
	LIN_PRO VARCHAR(30) NOT NULL,
	IMP_PRO VARCHAR(10) NOT NULL
)
GO

CREATE TABLE DETALLE_FACTURA(
	NUM_FAC VARCHAR(12) NOT NULL REFERENCES FACTURA,
	COD_PRO CHAR(5) NOT NULL REFERENCES PRODUCTO,
	CAN_VEN INT NOT NULL,
	PRE_VEN MONEY NOT NULL PRIMARY KEY(NUM_FAC,COD_PRO)
)
GO


CREATE TABLE DETALLE_COMPRA(
	NUM_OCO CHAR(5) NOT NULL REFERENCES ORDEN_COMPRA,
	COD_PRO CHAR(5) NOT NULL REFERENCES PRODUCTO,
	CAN_DET INT NOT NULL PRIMARY KEY( NUM_OCO,COD_PRO)
)
GO

CREATE TABLE ABASTECIMIENTO(
	COD_PRV CHAR(5) NOT NULL REFERENCES PROVEEDOR,
	COD_PRO CHAR(5) NOT NULL REFERENCES PRODUCTO,
	PRE_ABA MONEY NOT NULL PRIMARY KEY(COD_PRV, COD_PRO)
)
GO

