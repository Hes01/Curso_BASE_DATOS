USE vorkov
GO

-----------------------------------------

----------------------------------------

INSERT INTO [dbo].[Cuenta]
           ([numcuenta]
           ,[saldo])
     VALUES
           ('1234567890'
           ,2000),
		   ('1234567891', 1000)
GO
select * from Cuenta

--Forma errónea, sn transacciones
DECLARE @importe DECIMAL(11,2),
	@CuentaOrigen CHAR(10),
	@CuentaDestino CHAR(10)
/* Asignamos el importe de la transferencia
* y las cuentas de origen y destino
*/
SET @importe = 150 
SET @CuentaOrigen  = '1234567890'
SET @CuentaDestino = '1234567891'
 
/* Descontamos el importe de la cuenta origen */
UPDATE Cuenta
SET SALDO = SALDO - @importe
WHERE NUMCUENTA = @CuentaOrigen
 
/* Registramos el movimiento */
INSERT INTO MOVIMIENTO
(IDCUENTA, saldoAnt, SaldoNue, fecha)
SELECT 
ID, SALDO + @importe, SALDO, 'abcd'
FROM Cuenta
WHERE NUMCUENTA = @CuentaOrigen
 
/* Incrementamos el importe de la cuenta destino */
UPDATE Cuenta
SET SALDO = SALDO + @importe
WHERE NUMCUENTA = @CuentaDestino
 
/* Registramos el movimiento */
INSERT INTO MOVIMIENTO 
(idcuenta, SALDOANT, SALDONue,  fecha)
SELECT 
ID, SALDO - @importe, SALDO,  getdate()
FROM CUENTA
WHERE NUMCUENTA = @CuentaDestino







--Transacciones Implicitas
SET IMPLICIT_TRANSACTIONS ON
DECLARE @importe DECIMAL(11,2),
	@CuentaOrigen CHAR(10),
	@CuentaDestino CHAR(10)
/* Asignamos el importe de la transferencia
* y las cuentas de origen y destino
*/
SET @importe = 150 
SET @CuentaOrigen  = '1234567890'
SET @CuentaDestino = '1234567891'
 
/* Descontamos el importe de la cuenta origen */
UPDATE Cuenta
SET SALDO = SALDO - @importe
WHERE NUMCUENTA = @CuentaOrigen
 
/* Registramos el movimiento */
INSERT INTO MOVIMIENTO
(IDCUENTA, saldoAnt, SaldoNue, fecha)
SELECT 
ID, SALDO + @importe, SALDO, 'abcd'
FROM Cuenta
WHERE NUMCUENTA = @CuentaOrigen
 
/* Incrementamos el importe de la cuenta destino */
UPDATE Cuenta
SET SALDO = SALDO + @importe
WHERE NUMCUENTA = @CuentaDestino
 
/* Registramos el movimiento */
INSERT INTO MOVIMIENTO 
(idcuenta, SALDOANT, SALDONue,  fecha)
SELECT 
ID, SALDO - @importe, SALDO,  getdate()
FROM CUENTA
WHERE NUMCUENTA = @CuentaDestino

select * from Cuenta







--Transacciones Explicitas
SET IMPLICIT_TRANSACTIONS OFF
DECLARE @importe DECIMAL(11,2),
	@CuentaOrigen CHAR(10),
	@CuentaDestino CHAR(10)
/* Asignamos el importe de la transferencia
* y las cuentas de origen y destino
*/
SET @importe = 150 
SET @CuentaOrigen  = '1234567890'
SET @CuentaDestino = '1234567891'
 
BEGIN TRANSACTION -- O solo BEGIN TRAN
BEGIN TRY

/* Descontamos el importe de la cuenta origen */
UPDATE Cuenta
SET SALDO = SALDO - @importe
WHERE NUMCUENTA = @CuentaOrigen
 
/* Registramos el movimiento */
INSERT INTO MOVIMIENTO
(IDCUENTA, saldoAnt, SaldoNue, fecha)
SELECT 
ID, SALDO + @importe, SALDO, '2024-02-02'
FROM Cuenta
WHERE NUMCUENTA = @CuentaOrigen
 
/* Incrementamos el importe de la cuenta destino */
UPDATE Cuenta
SET SALDO = SALDO + @importe
WHERE NUMCUENTA = @CuentaDestino
 
/* Registramos el movimiento */
INSERT INTO MOVIMIENTO 
(idcuenta, SALDOANT, SALDONue,  fecha)
SELECT 
ID, SALDO - @importe, SALDO,  getdate()
FROM CUENTA
WHERE NUMCUENTA = @CuentaDestino


/* Confirmamos la transaccion*/ 
COMMIT TRANSACTION -- O solo COMMIT
 
END TRY

BEGIN CATCH
/* Hay un error, deshacemos los cambios*/ 
ROLLBACK TRANSACTION -- O solo ROLLBACK
PRINT 'Se ha producido un error!'
END CATCH


select * from Cuenta
select * from Movimiento


--0000000000000000000000000000000000000000000000000000000000000000000000000000000
--0000000000000000000000000000000000000000000000000000000000000000000000000000000
--0000000000000000000000000000000000000000000000000000000000000000000000000000000
--0000000000000000000000000000000000000000000000000000000000000000000000000000000
--0000000000000000000000000000000000000000000000000000000000000000000000000000000
CREATE TABLE CUENTAS (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	NUMCUENTA VARCHAR(20),
	SALDO INT
)

CREATE TABLE MOVIMIENTOS(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	IDCUENTA INT REFERENCES CUENTAS(ID),
	SALDO_ANTERIOR INT,
	SALDO_POSTERIOR INT,
	IMPORTE INT,
	FXMOVIMIENTO DATE
)

insert into CUENTAS values('001',1000),('002',1000)

drop table CUENTAS
drop table MOVIMIENTOS 
---------------------------------------------
--transacciones implicitas :modo automatico commit y rollback


SET IMPLICIT_TRANSACTIONS OFF --Activamos el modo transacciones implicitas 

select @@trancount 
--FORMA ERRONEA

DECLARE @CO CHAR(3)='001',
		@CD CHAR(3)='002',
		@importe int =50

			/*descontamos el importe a retirar de la cuenta de origen */
			--retiramos 50 soles 
			update cuentas
			set saldo -=@importe
			where numcuenta= @CO

			/*registramos el movimiento */ 
			insert into movimientos(idcuenta, saldo_anterior,saldo_posterior,importe,fxmovimiento)
			select id,saldo + @importe,saldo,@importe,getdate()
			from cuentas 
			where numcuenta =@CO
			/*abonamos en la cuenta de destino*/

			update cuentas
			set saldo +=@importe
			where numcuenta =@CD
			/*registramos el movimiento */

			insert into movimientos(idcuenta,saldo_anterior,saldo_posterior,importe,fxmovimiento)
			select id,saldo-@importe,saldo, @importe,getdate()
			from cuentas 
			where numcuenta=@CD
			


--TRANSACCIONES IMPLICITAS 
SET IMPLICIT_TRANSACTIONS ON 

DECLARE @CO CHAR(3)='008',
		@CD CHAR(3)='006',
		@importe int =50

			/*descontamos el importe a retirar de la cuenta de origen */
			--retiramos 50 soles 
			update cuentas
			set saldo -=@importe
			where numcuenta= @CO

			/*registramos el movimiento */ 
			insert into movimientos(idcuenta, saldo_anterior,saldo_posterior,importe,fxmovimiento)
			select id,saldo + @importe,saldo,@importe,getdate()
			from cuentas 
			where numcuenta =@CO
			/*abonamos en la cuenta de destino*/

			update cuentas
			set saldo +=@importe
			where numcuenta =@CD
			/*registramos el movimiento */

			insert into movimientos(idcuenta,saldo_anterior,saldo_posterior,importe,fxmovimiento)
			select id,saldo-@importe,saldo, @importe,getdate()
			from cuentas 
			where numcuenta=@CD


SELECT * FROM CUENTAS 
SELECT * FROM MOVIMIENTOS 

	UPDATE CUENTAS 
	SET SALDO =1000
	WHERE NUMCUENTA='001'



--TRANSACCIONES EXPLICITAS 
SELECT @@TRANCOUNT

DECLARE @CO CHAR(3)='008',
		@CD CHAR(3)='006',
		@importe int =1100

		BEGIN TRAN

		BEGIN TRY
			/*descontamos el importe a retirar de la cuenta de origen */
			--retiramos 50 soles 
			update cuentas
			set saldo -=@importe
			where numcuenta= @CO

			/*registramos el movimiento */ 
			insert into movimientos(idcuenta, saldo_anterior,saldo_posterior,importe,fxmovimiento)
			select id,saldo + @importe,saldo,@importe,getdate()
			from cuentas 
			where numcuenta =@CO
			/*abonamos en la cuenta de destino*/

			update cuentas
			set saldo +=@importe
			where numcuenta =@CD
			/*registramos el movimiento */

			insert into movimientos(idcuenta,saldo_anterior,saldo_posterior,importe,fxmovimiento)
			select id,saldo-@importe,saldo, @importe,getdate()
			from cuentas 
			where numcuenta=@CD
			COMMIT TRAN 

			END TRY 
			BEGIN CATCH
			ROLLBACK TRAN
			END CATCH

SELECT * FROM CUENTAS 
SELECT * FROM MOVIMIENTOS 

	UPDATE CUENTAS 
	SET SALDO =1000
	WHERE NUMCUENTA='002'