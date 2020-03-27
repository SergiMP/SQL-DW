
---------------------------------------------
--
-- Estudiante: Sergio Munoz Paino
--
---------------------------------------------

---------------------------------------------
--
-- Configuración de la sesión e inicio
--
---------------------------------------------
SET datestyle = YMD;        -- Formato de fecha día-mes-año
SET TRANSACTION READ WRITE;  

BEGIN WORK;

---------------------------------------------
--
-- Borrado de tablas si existen. Añadimos cascade para eliminar posibles
-- conflictos por dependencias.
--
---------------------------------------------

DROP TABLE IF EXISTS movies.tb_genre CASCADE;
DROP TABLE IF EXISTS movies.tb_movie CASCADE;
DROP TABLE IF EXISTS movies.tb_role CASCADE;
DROP TABLE IF EXISTS movies.tb_person CASCADE;
DROP TABLE IF EXISTS movies.tb_movie_person CASCADE;

---------------------------------------------
--
-- Creación del esquema movies
--
---------------------------------------------

DROP SCHEMA IF EXISTS movies;

CREATE SCHEMA movies;

---------------------------------------------
--
-- Creación de la tabla tb_genre
--
---------------------------------------------

CREATE TABLE movies.tb_genre (
   genre_id        INTEGER NOT NULL CONSTRAINT pk_genre PRIMARY KEY, 
   genre_name      CHAR(40) NOT NULL, 
   created_by_user CHAR(10) NOT NULL DEFAULT 'OS_SGAD',
   created_date    DATE,
   updated_date    DATE 
);

---------------------------------------------
--
-- Creación de la tabla tb_movie
--
---------------------------------------------

CREATE TABLE movies.tb_movie (
    movie_id         INTEGER NOT NULL CONSTRAINT pk_movie PRIMARY KEY,
    movie_title      CHAR(100) NOT NULL,
    movie_date       DATE,  
    movie_format     CHAR(50),
    movie_genre_id   INTEGER,
    created_by_user  CHAR(10) NOT NULL DEFAULT 'OS_SGAD',
    created_date     DATE,
    updated_date     DATE, 
    CONSTRAINT fk_movie_genre_id FOREIGN KEY (movie_genre_id) REFERENCES movies.tb_genre(genre_id)
);

---------------------------------------------
--
-- Creación de la tabla tb_role
--
---------------------------------------------

CREATE TABLE movies.tb_role (
    role_id          INTEGER NOT NULL CONSTRAINT pk_role PRIMARY KEY,      
    role_name        CHAR(60) NOT NULL,
    created_by_user  CHAR(10) NOT NULL DEFAULT 'OS_SGAD',
    created_date     DATE,
    updated_date     DATE
);
---------------------------------------------
--
-- Creación de la tabla tb_person
--
---------------------------------------------

CREATE TABLE movies.tb_person (
    person_id          INTEGER NOT NULL CONSTRAINT pk_person PRIMARY KEY,
    person_name        CHAR(100) NOT NULL,
    person_country     CHAR(40),
    person_dob         DATE NOT NULL,
    person_dod         DATE,
    person_parent_id   INTEGER,
    created_by_user    CHAR(10) NOT NULL DEFAULT 'OS_SGAD',
    created_date       DATE,
    updated_date       DATE,
    CONSTRAINT fk_parent_id FOREIGN KEY (person_id) REFERENCES movies.tb_person(person_id )

);


---------------------------------------------
--
-- Creación de la tabla tb_movie_person
--
---------------------------------------------

CREATE TABLE movies.tb_movie_person (
    movie_id         INTEGER NOT NULL,
    person_id        INTEGER NOT NULL,
    role_id          INTEGER NOT NULL,
    movie_award_ind  CHAR(1) NOT NULL,
    created_by_user  CHAR(10) NOT NULL DEFAULT 'OS_SGAD',
    created_date     DATE,
    updated_date     DATE,
    CONSTRAINT fk_movie_id FOREIGN KEY(movie_id) REFERENCES movies.tb_movie(movie_id),
    CONSTRAINT fk_person_id FOREIGN KEY(person_id) REFERENCES movies.tb_person(person_id),
    CONSTRAINT fk_role_id FOREIGN KEY(role_id) REFERENCES movies.tb_role(role_id )

);

COMMIT;