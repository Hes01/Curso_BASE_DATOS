----PROBLEMA PROPUESTO 
--actualizar info: 
cabPagos 
cCodigo 
...
NumRecibo ->formato :2003000585
					:2004000001 --se gerera por cada año con ese formato se reinicia y esta programado en el codigo 
--no habia una tabla donde cambiar el codigo 
--como podria hacer para poner manualmente el año o cambiar de formato 


--tabla cabpagos
create table CabPagos(
	codigo int identity(1,1),
	NumRecibo char(10),
	fecPago date)

---tabla Registros Correlativo 
create table Correlativo (
	--codigo int,
	Año char(4) primary key,--pk
	numero char(6))

-----trigger mas o menos bien :v

CREATE TRIGGER tr_ActualizaRecibo
ON CabPagos
AFTER INSERT 
AS 
BEGIN 
    DECLARE @n INT, @y INT, @ceros VARCHAR(5), @nc TINYINT;
    
    IF EXISTS(SELECT * FROM INSERTED)--si hay insercion
    BEGIN
        SELECT @y = YEAR(i.fecPago)--fecha de ultima insercion
		from inserted i
        
        IF NOT EXISTS(SELECT * FROM Correlativo WHERE Año = CAST(@y AS CHAR(4)))--sino hay correlativo 
			BEGIN
				INSERT INTO Correlativo ( Año, numero) VALUES ( CAST(@y AS CHAR(4)), '000001');--insertar

				UPDATE CabPagos --actualizamos el formato de NumRecibo
				SET NumRecibo = CAST(@y AS VARCHAR) + '000001'
				FROM CabPagos c
				join inserted i on i.codigo = c.codigo 

			END
        ELSE --si hay correlativo para esa ultima insercion por año
			BEGIN
				SELECT @n = CAST(numero AS INT) --numero correlativo para dicho año
				FROM Correlativo 
				WHERE Año = CAST(@y AS CHAR(4));
				
				SET @n += 1;--incremente en 1 
				
				SET @nc = 6 - LEN(@n); --el numero de ceros a tener 
				SET @ceros = REPLICATE('0', @nc);--ceros a concatenar

				UPDATE CabPagos --actualizamos el formato de NumRecibo
				SET NumRecibo = CAST(@y AS VARCHAR) + @ceros + CAST(@n AS VARCHAR), fecPago = i.fecPago
				FROM CabPagos c
				join inserted i on i.codigo = c.codigo 

				UPDATE Correlativo
				SET numero = RIGHT(@ceros + CAST(@n AS VARCHAR), 6)--actualiza el numero correlativo para el año actual
				WHERE Año = CAST(@y AS CHAR(4));

			END

    END
END;

drop trigger tr_ActualizaRecibo
truncate table CabPagos
truncate table [dbo].[Correlativo]
---puebas
-- Insertar datos de prueba en CabPagos con diferentes fechas de pago
INSERT INTO CabPagos (NumRecibo, fecPago) VALUES ('2023000001', '2023-01-01');
INSERT INTO CabPagos (NumRecibo, fecPago) VALUES ('2023000002', '2023-01-02');
INSERT INTO CabPagos (NumRecibo, fecPago) VALUES ('2024000003', '2024-01-01');
INSERT INTO CabPagos (NumRecibo, fecPago) VALUES ('2024000004', '2024-01-02');
INSERT INTO CabPagos (NumRecibo, fecPago) VALUES ('2025000112', '2025-01-02');
INSERT INTO CabPagos (NumRecibo, fecPago) VALUES ('2025000115', '2025-01-02');

-----consultas

select *
from CabPagos

select *
from Correlativo




