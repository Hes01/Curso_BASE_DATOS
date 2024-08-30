---------transact sql server ------------
/*
este es mas de un comentario
*/

begin try 
	select 9/0
end try
begin catch
	select 
		ERROR_NUMBER() AS [NUMERO DE ERROR ]
		, ERROR_SEVERITY() AS [GRAVEDAD DE ERROR]
		, ERROR_STATE() AS [ESTADO DE ERROR]
		, ERROR_PROCEDURE() AS [PROCEDIMIENTO DEL ERROR]
		, ERROR_LINE() AS [LINEA DE ERROR]
		, ERROR_MESSAGE() AS [MENSAJE DE ERROR]
end catch



BEGIN TRY 
	
	DECLARE @COD CHAR(3)='D01',
		@DIS VARCHAR(40)='SAN JUAN DE ASIS'
	INSERT INTO DISTRITO VALUES(@COD,@DIS)
	IF @@ERROR <>0 --:ERROR GENERADO POR LA ULTIMA INSTRUCCIÓN
		BEGIN 
			PRINT  N'ERROR AL INTENTAR REALIZAR INSERCIÓN  ' 
		END 
	ELSE 
		BEGIN	
			PRINT N'LA INSERCIÓN SE REALIZO EXITOSAMENTE!'
		END

END TRY
BEGIN CATCH
	PRINT (CAST(ERROR_MESSAGE() AS VARCHAR))+', NUMERO DE ERROR: '+CAST(ERROR_NUMBER() AS VARCHAR(10))+' EN LA LINEA '+CAST(ERROR_LINE() AS VARCHAR)
END CATCH

 
BEGIN
    UPDATE DISTRITO
    SET COD_DIS = 4  
    WHERE COD_DIS = 'D01';  

    IF @@ERROR = 547
    BEGIN
        DECLARE @errorMessage NVARCHAR(1000);
        SET @errorMessage = N'OCURRIO UNA VIOLACIÓN EN LA RESTRICCION CHECK DE VERIFICACIÓN. ' 
    END
END

----------------------
SELECT *
INTO #DISTRITO
FROM DISTRITO

UPDATE #DISTRITO  
SET COD_DIS = 'D39'
WHERE NOM_DIS LIKE '%I%'
DECLARE @CONTAR INT=@@ROWCOUNT 
IF @CONTAR <> 0  
PRINT 'se afectaron filas : '+CAST(@CONTAR AS VARCHAR) 


DELETE FROM DISTRITO
WHERE COD_DIS='D39  '--SANTA MARIA
----------------------
--Display the value of LocationID in the last row in the table.  
create table #prueba(
	id int identity(1,1),
	nombre varchar(20))
	


SELECT MAX(id) FROM #prueba 
GO  
INSERT INTO #prueba 
VALUES ('venezuela');  
GO  
SELECT @@IDENTITY AS 'Identity';  
GO  
--Display the value of LocationID of the newly inserted row.  
SELECT MAX(id) FROM #prueba
GO
----------------------

SELECT * FROM #DISTRITO

begin try 
	print 1/0
end try
begin catch
	declare @msmError varchar(40),
			@serveridad int ,
			@estado int,
			@linea int
	select 
			@msmError =Error_message(),
			@serveridad=14,--0-18
			@estado=200,--0-255
			@linea = Error_line()
	raiserror(@msmError,@serveridad,@estado)
end catch
---------------------------
RAISERROR ('El mensaje esta en la %s %d.', -- Message text.
           11, -- Severity,
           1, -- State,
           'linea', -- First argument.
           5); -- Second argument.
-- The message text returned is: This is message number 5.
GO
----------------------------------------------------
BEGIN TRY
    -- RAISERROR with severity 11-19 will cause execution to
    -- jump to the CATCH block.
    RAISERROR ('Error raised in TRY block.', -- Message text.
               11, -- Severity.
               1 -- State.
               );
	print 'try'
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    -- Use RAISERROR inside the CATCH block to return error
    -- information about the original error that caused
    -- execution to jump to the CATCH block.
	print 'catch'
    RAISERROR (@ErrorMessage, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );
END CATCH;