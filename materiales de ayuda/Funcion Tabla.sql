alter FUNCTION dbo.Direccion(@codigo char(11))
RETURNS @retDireccion TABLE 
(
    -- Columnas que returna la función
    codCont char(11) PRIMARY KEY NOT NULL, 
    Nombre varchar(100) not NULL, 
    Lugar varchar(100) NULL, 
    Calle varchar(100) NULL, 
    Numero char(4) not null,
    Manzana char(4) not null,
    Lote char(4) not null
)
AS 
BEGIN
    DECLARE 
		@Nombre varchar(100),
		@Lugar varchar(100), 
		@Calle varchar(100), 
		@Numero char(4),
		@Manzana char(4),
		@Lote char(4)
    -- Get common contact information
    SELECT 
        @Nombre = c.cnombre, 
        @Lugar = l.cnombre, 
        @Calle = ca.cnombre,
        @Numero = cNumero,
        @Manzana = cManzana,
        @Lote = cLote
    FROM tContribuyente c
    left join tLugares l on c.cCod_Lug = l.cCod_Lug
    left join tCalles ca on c.ccod_calle = ca.ccod_calle
    WHERE ccod_cont = @codigo;
    --Insertamos los valores en la tabla
        INSERT @retDireccion
        SELECT @codigo, @Nombre, @Lugar, @Calle, @Numero, @Manzana, @Lote;
    RETURN;
END;
GO

select top 100 * from tContribuyente

select *
from dbo.Direccion('70102585309')
