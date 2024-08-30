------------------------------TRABAJO 02-----------------------------
--En la BD que modelaron en el trabajo 01, elaborar lo siguiente:




--1.identificar de todas las tablas donde se necesitan Procedimientos almacenados 
--para la inserción y modificación de las tablas del sistema,
--dichos procedimientos deberán tener como nombre paActualizaTabla, 
--donde Tabla es el nombre de cada una de las tablas. Tener en cuenta 
--que un mismo procedimiento se usará para Insert y Update.




--2. Dos funciones escalares, deberá describir cuál es su funcionalidad agregando
--comentarios dentro de la función.




--3. Dos vistas en las que use JOIN. Igual agregar comentarios al script
--en el cual expliquen la utilidad de las vistas.




--4. En dos tablas que consideren críticas crear para cada una de ellas una tabla de
--Auditoría que contenga los datos de dos columnas que también considere críticas en
--las cuales se guardarán los valores antiguos y los valores nuevos, 
--agregar también las otras columnas que consideren necesarias para una adecuada auditoría de los
--cambios. Luego generar un desencadenador (Trigger) para cada una de las tablas y que
--se dispare cuando se haga Update a esas tablas críticas. También debe tener en cuenta
--que las inserciones a las tablas de auditoría se harán sólo si se hacen cambios a esas
--columnas que identificó como críticas.




--5. Crear también dos triggers que considere importantes y explicar en qué consisten
--y porqué es importante implementarlos.




--6. Identificar un proceso en el cual se requiera usar una transacción y elaborar un
--procedimiento almacenado que lo implemente. Por ejemplo, si el proceso es transferir
--productos de un almacén a otro, la transacción debe incluir la salida del producto
--de un almacén y la entrada al otro, por lo cual ambas operaciones deberán estar incluidas en una transacción.





--7. Elaborar un procedimiento almacenado que incluya el uso de cursores, justificar 
--con comentarios dentro del procedimiento en el que se explique porqué es necesario
--usar el cursor en el cual se va recorriendo fila por fila y no hacerlo en un solo comando Transact-SQL.
