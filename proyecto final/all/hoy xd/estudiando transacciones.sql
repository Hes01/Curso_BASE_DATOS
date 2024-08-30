--transactions 
use vorkov
select *
from CUENTAS

select *
from MOVIMIENTOS


---TRANSACCIONES IMPLICITAS
SET IMPLICIT_TRANSACTIONS Off

---se desea mover de la cuenta 001 a cuenta 002 para que 
---esten iguales es decir tien la primer 4k tiene que abonar 2k 

declare @monto decimal(9,2)=1000,
		@CO char(3)='001',
		@CD CHAR(3)='002'
--Restamos a la primer cuenta 
BEGIN TRY
	if not exists ( select * from CUENTAS where NUMCUENTA=@CO)
		begin 
			Raiserror('Se produjo un error',11,12) 
		end
	else 
		begin 
			update CUENTAS 
			set saldo -=@monto
			where NUMCUENTA =@CO
			print 'retiro exitoso'
		end
END TRY 
BEGIN CATCH 
	print 'rollback'
END CATCH

--registramos el movimiento 


declare @monto decimal(9,2)=1000,
		@CO char(3)='001',
		@CD CHAR(3)='002'

BEGIN TRY

	if not exists ( select * from CUENTAS where NUMCUENTA=@CO)
		begin 
			Raiserror('Se produjo un error',11,12) 
		end
	else 
		begin 
			insert into MOVIMIENTOS 
			select id,@monto+SALDO,SALDO,@monto,GETDATE(),SYSTEM_USER
			from CUENTAS 
			where NUMCUENTA =@CO
		end

	
END TRY 
BEGIN CATCH 
	print 'rollback'
END CATCH
--abonamos el monto a la segunda cuenta 


declare @monto decimal(9,2)=1000,
		@CO char(3)='001',
		@CD CHAR(3)='002'
BEGIN TRY
	
	if not exists ( select * from CUENTAS where NUMCUENTA=@CD)
		begin 
			Raiserror('Se produjo un error',11,12) 
		end
	else 
		begin 
			update CUENTAS
			set SALDO +=@monto
			where NUMCUENTA=@CD 
		end

	
END TRY 
BEGIN CATCH 
	print 'rollback'
END CATCH


--registramos el movimiento a la segunda cuenta 


declare @monto decimal(9,2)=1000,
		@CO char(3)='001',
		@CD CHAR(3)='002'

BEGIN TRY

	if not exists ( select * from CUENTAS where NUMCUENTA=@CO)
		begin 
			Raiserror('Se produjo un error',11,12) 
		end
	else 
		begin 
			insert into MOVIMIENTOS 
			select id, SALDO - @monto , SALDO,@monto ,getdate(),SYSTEM_USER
			from CUENTAS 
			where NUMCUENTA=@CD
		end
	
END TRY 
BEGIN CATCH 
	print 'rollback'
END CATCH

--==================================================

select *
from MOVIMIENTOS

SELECT * FROM CUENTAS

UPDATE CUENTAS 
SET SALDO =2000
WHERE ID>=1
TRUNCATE TABLE MOVIMIENTOS 

select @@TRANCOUNT
------------------------------

SP_TABLES 


SELECT A.TABLE_NAME ,A.TABLE_TYPE,A.TABLE_CATALOG
FROM INFORMATION_SCHEMA.TABLES A

SELECT *
FROM ejm
-------------------------
SET IMPLICIT_TRANSACTIONS OFF

BEGIN TRAN T1

INSERT INTO ejm VALUES ('BREYNER')

SAVE TRAN S1

SELECT * FROM ejm

INSERT INTO ejm VALUES ('ELVIS')
SAVE TRAN S2
SELECT * FROM ejm

INSERT INTO ejm VALUES ('LUCAS')
SAVE TRAN S3
SELECT * FROM ejm

INSERT INTO ejm VALUES ('MADELEY')
SAVE TRAN S4
SELECT * FROM ejm

---AFTER
ROLLBACK TRAN S2

COMMIT TRAN T1








select @@TRANCOUNT

BEGIN TRAN X
DELETE FROM EJM
COMMIT TRAN X



SELECT * FROM ejm