------------------------------TRABAJO 02-----------------------------
--En la BD que modelaron en el trabajo 01, elaborar lo siguiente:




--1.identificar de todas las tablas donde se necesitan Procedimientos almacenados 
--para la inserci�n y modificaci�n de las tablas del sistema,
--dichos procedimientos deber�n tener como nombre paActualizaTabla, 
--donde Tabla es el nombre de cada una de las tablas. Tener en cuenta 
--que un mismo procedimiento se usar� para Insert y Update.




--2. Dos funciones escalares, deber� describir cu�l es su funcionalidad agregando
--comentarios dentro de la funci�n.




--3. Dos vistas en las que use JOIN. Igual agregar comentarios al script
--en el cual expliquen la utilidad de las vistas.




--4. En dos tablas que consideren cr�ticas crear para cada una de ellas una tabla de
--Auditor�a que contenga los datos de dos columnas que tambi�n considere cr�ticas en
--las cuales se guardar�n los valores antiguos y los valores nuevos, 
--agregar tambi�n las otras columnas que consideren necesarias para una adecuada auditor�a de los
--cambios. Luego generar un desencadenador (Trigger) para cada una de las tablas y que
--se dispare cuando se haga Update a esas tablas cr�ticas. Tambi�n debe tener en cuenta
--que las inserciones a las tablas de auditor�a se har�n s�lo si se hacen cambios a esas
--columnas que identific� como cr�ticas.




--5. Crear tambi�n dos triggers que considere importantes y explicar en qu� consisten
--y porqu� es importante implementarlos.




--6. Identificar un proceso en el cual se requiera usar una transacci�n y elaborar un
--procedimiento almacenado que lo implemente. Por ejemplo, si el proceso es transferir
--productos de un almac�n a otro, la transacci�n debe incluir la salida del producto
--de un almac�n y la entrada al otro, por lo cual ambas operaciones deber�n estar incluidas en una transacci�n.





--7. Elaborar un procedimiento almacenado que incluya el uso de cursores, justificar 
--con comentarios dentro del procedimiento en el que se explique porqu� es necesario
--usar el cursor en el cual se va recorriendo fila por fila y no hacerlo en un solo comando Transact-SQL.
