---------------------------------------------
--
-- Estudiante: Sergio Munoz Paino
--
---------------------------------------------
---------------------------------------------
--
--  Creacion de la base de datos (Comentado como indicado en la PEC)
--
---------------------------------------------


--             CREATE DATABASE sgad_pec2;


---------------------------------------------
---------------------------------------------


--   EJECUTAMOS LOS SCRIPTS PROPORCIONADOS PARA LA PRACTICA

--   BBDD_Movies_(structures).sql y BBDD_Movies_(data).sql

---------------------------------------------

---------------------------------------------
--
-- Configuración de la sesión e inicio (A ejecutar una vez la base de datos ha sido creada)
--
---------------------------------------------
SET datestyle = YMD;        -- Formato de fecha día-mes-año
SET TRANSACTION READ WRITE; 
BEGIN WORK;

---------------------------------------------
--
-- Borrado de tablas tb_movie_agg si existen. 
--
---------------------------------------------

DROP TABLE IF EXISTS movies_dw.tb_movie_agg;

---------------------------------------------
--
-- Creación del esquema movies
--
---------------------------------------------

DROP SCHEMA IF EXISTS movies_dw;
CREATE SCHEMA movies_dw;
SET SEARCH_PATH TO movies;

---------------------------------------------
--
-- Creación de la tabla tb_movie_agg
--
---------------------------------------------

CREATE TABLE movies_dw.tb_movie_agg(
    movie_id           INTEGER NOT NULL CONSTRAINT pk_movie PRIMARY KEY,
    movie_title        CHARACTER VARYING(80) NOT NULL,
    movie_date         DATE,
    movie_format       CHARACTER VARYING(40),
    movie_genre_name   CHARACTER VARYING(40)NOT NULL,
    actor_count        INTEGER NOT NULL,
    usa_actor_count    INTEGER NOT NULL,
    esp_actor_count    INTEGER NOT NULL,
    award_count        INTEGER NOT NULL
);

---------------------------------------------
--
-- Creación de la tabla tb_person_agg
--
---------------------------------------------

CREATE TABLE movies_dw.tb_person_agg(
    person_id          INTEGER NOT NULL CONSTRAINT pk_person PRIMARY KEY,
    person_name        CHARACTER VARYING(80) NOT NULL,
    person_dob         DATE,
    movie_count        INTEGER NOT NULL,
    actor_count        INTEGER NOT NULL,
    director_count     INTEGER,
    productor_count    INTEGER,
    other_role_count   INTEGER,
    award_count        INTEGER
);

COMMIT;