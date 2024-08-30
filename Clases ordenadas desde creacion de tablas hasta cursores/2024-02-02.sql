---------------------TRANSACCIÓN EN TRANSACT SQL SERVER------------------------
--EJM : 
--ABONAR DE UNA CUENTA A OTRA: "TODO O NADA "

--forma erronea
----INSERCIONES
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
SET saldo = saldo - @importe
WHERE numeroCuenta = @CuentaOrigen
 
/* Registramos el movimiento */
INSERT INTO Movimiento
(id, saldoAnt,saldoNue, fecha)
SELECT 
ID, saldo + @importe,saldo, 'ABCD'
FROM CUENTA
WHERE NUMEROCUENTA = @CuentaOrigen
 --Activamos el modo de transacciones implicitas

SET IMPLICIT_TRANSACTIONS ON--:si falla una transaccion falla todo("todo o nada")
/* Incrementamos el importe de la cuenta destino */
UPDATE CUENTAS 
SET SALDO = SALDO + @importe
WHERE NUMEROCUENTA  = @CuentaDestino
 
/* Registramos el movimiento */
INSERT INTO MOVIMIENTO 
(ID, SALDOANT, SALDONUE, FXMOVIMIENTO)
SELECT 
IDCUENTA, SALDO - @importe, SALDO, @importe, getdate()
FROM CUENTAS
WHERE NUMCUENTA = @CuentaDestino

-----------------------------------

--Desactivamos el modo de transacciones implicitas
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
 
 BEGIN TRANSACTION -- O solo BEGIN TRAN --se pone si no se ejecuta 
BEGIN TRY
/* Descontamos el importe de la cuenta origen */
UPDATE Cuenta 
SET saldo = saldo - @importe
WHERE numeroCuenta = @CuentaOrigen
 
/* Registramos el movimiento */
INSERT INTO Movimiento
(id, saldoAnt,saldoNue, fecha)
SELECT 
ID, saldo + @importe,saldo, 'ABCD'
FROM CUENTA
WHERE NUMEROCUENTA = @CuentaOrigen
 --Activamos el modo de transacciones implicitas
/* Incrementamos el importe de la cuenta destino */
UPDATE CUENTAS 
SET SALDO = SALDO + @importe
WHERE NUMEROCUENTA  = @CuentaDestino
 
/* Registramos el movimiento */
INSERT INTO MOVIMIENTO 
(ID, SALDOANT, SALDONUE, FXMOVIMIENTO)
SELECT 
IDCUENTA, SALDO - @importe, SALDO, @importe, getdate()
FROM CUENTAS
WHERE NUMCUENTA = @CuentaDestino

COMMIT TRANSACTION -- O solo COMMIT

end Try
begin catch
	ROLLBACK TRANSACTION -- O solo ROLLBACK--desace los cambios 
	PRINT 'Se ha producido un error!' 
END CATCH

