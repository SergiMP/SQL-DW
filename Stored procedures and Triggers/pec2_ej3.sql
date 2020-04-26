BEGIN WORK;
------------------------------------------------------------------------------------------
-- Definimos la funcion que devuelve el valor trigger que necesitamos
------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS update_movie_agg() CASCADE;
CREATE FUNCTION update_movie_agg()
RETURNS trigger AS 
$$BEGIN  
SELECT sp_load_movie_agg();  
RETURN NULL;
END
$$ LANGUAGE plpgsql;
------------------------------------------------------------------------------------------
-- Creamos los Triggers para actualizar la tabla tb_movie_agg, para ello tenemos que 
-- crear triggers especificos para cada tabla.
-- Para ver que tablas necesitamos indicar en cada trigger nos hemos ayudado de las tablas
-- utilizadas para el ejercicio pec2_ej2.sql 
------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trig_genre_table ON movies_dw.tb_movie_agg;
CREATE TRIGGER trig_genre_table 
AFTER UPDATE ON movies.tb_genre 
FOR EACH STATEMENT 
EXECUTE PROCEDURE update_movie_agg();

DROP TRIGGER IF EXISTS trig_movie_table ON movies_dw.tb_movie_agg;
CREATE TRIGGER trig_movie_table
AFTER UPDATE ON movies.tb_movie
FOR EACH STATEMENT 
EXECUTE PROCEDURE update_movie_agg();

DROP TRIGGER IF EXISTS trig_movie_person_table ON movies_dw.tb_movie_agg;
CREATE TRIGGER trig_movie_person_table
AFTER UPDATE ON movies.tb_movie_person
FOR EACH STATEMENT 
EXECUTE PROCEDURE update_movie_agg();

DROP TRIGGER IF EXISTS trig_person_table ON movies_dw.tb_movie_agg;
CREATE TRIGGER trig_person_table
AFTER UPDATE ON movies.tb_person
FOR EACH STATEMENT 
EXECUTE PROCEDURE update_movie_agg();

DROP TRIGGER IF EXISTS trig_role_table ON movies_dw.tb_movie_agg;
CREATE TRIGGER trig_role_table
AFTER UPDATE ON movies.tb_role
FOR EACH STATEMENT 
EXECUTE PROCEDURE update_movie_agg();

------------------------------------------------------------------------------------------
-- Definimos la funcion que devuelve el valor trigger que necesitamos
------------------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS update_person_agg() CASCADE;
CREATE FUNCTION update_person_agg()
RETURNS trigger AS 
$$BEGIN  
SELECT tb_person_agg();  
RETURN NULL;
END
$$ LANGUAGE plpgsql;

------------------------------------------------------------------------------------------
-- Creamos los Triggers para actualizar la tabla tb_person_agg, para ello tenemos que 
-- crear triggers especificos para cada tabla.
------------------------------------------------------------------------------------------


DROP TRIGGER IF EXISTS trig_person_agg_table ON movies_dw.tb_person_agg;
CREATE TRIGGER trig_person_agg_table
AFTER UPDATE ON movies.tb_person
FOR EACH STATEMENT 
EXECUTE PROCEDURE update_person_agg();

DROP TRIGGER IF EXISTS trig_movie_personagg_table ON movies_dw.tb_person_agg;
CREATE TRIGGER trig_movie_personagg_table
AFTER UPDATE ON movies.tb_movie_person
FOR EACH STATEMENT 
EXECUTE PROCEDURE update_person_agg();


DROP TRIGGER IF EXISTS trig_role_table ON movies_dw.tb_person_agg;
CREATE TRIGGER trig_roleagg_table
AFTER UPDATE ON movies.tb_role
FOR EACH STATEMENT 
EXECUTE PROCEDURE update_person_agg();

COMMIT;
