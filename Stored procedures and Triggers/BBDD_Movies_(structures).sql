------------------------------------------------------------------------------------------------
---                         Asignatura B0.472 SQL PARA ANÁLISIS DE DATOS                     --- 
---              Creación de la dase de datos Movies, para la realización de la              ---
--                               PRUEBA de EVALUACIÓN CONTINUA (PEC) 2                       ---
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
--
-- Create database
--
------------------------------------------------------------------------------------------------

-- CREATE DATABASE sgad_pec2;

SET TRANSACTION READ WRITE;  
BEGIN WORK;

------------------------------------------------------------------------------------------------
--
-- Drop tables
--
------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS movies.tb_movie_person;
DROP TABLE IF EXISTS movies.tb_person;
DROP TABLE IF EXISTS movies.tb_role;
DROP TABLE IF EXISTS movies.tb_movie;
DROP TABLE IF EXISTS movies.tb_genre;

------------------------------------------------------------------------------------------------
--
-- Drop schema
--
------------------------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS movies;


------------------------------------------------------------------------------------------------
--
-- Create schema
--
------------------------------------------------------------------------------------------------

CREATE SCHEMA movies;


------------------------------------------------------------------------------------------------
--
-- Create table tb_genre
--
------------------------------------------------------------------------------------------------

CREATE TABLE movies.tb_genre (
  genre_id         INTEGER NOT NULL ,
  genre_name       CHARACTER VARYING(40) NOT NULL ,
  created_by_user  CHARACTER VARYING(10) NOT NULL DEFAULT 'OS_SGAD' ,
  created_date     DATE ,
  updated_date     DATE ,
  CONSTRAINT pk_genre PRIMARY KEY (genre_id)
);


------------------------------------------------------------------------------------------------
--
-- Create table tb_movie
--
------------------------------------------------------------------------------------------------

CREATE TABLE movies.tb_movie (
  movie_id         INTEGER NOT NULL ,
  movie_title      CHARACTER VARYING(100) NOT NULL ,
  movie_date       DATE ,
  movie_format     CHARACTER VARYING(50) ,
  movie_genre_id   INTEGER ,
  created_by_user  CHARACTER VARYING(10) NOT NULL DEFAULT 'OS_SGAD' ,
  created_date     DATE ,
  updated_date     DATE ,
  CONSTRAINT pk_movie PRIMARY KEY (movie_id) ,
  CONSTRAINT fk_movie_genre FOREIGN KEY (movie_genre_id) REFERENCES movies.tb_genre (genre_id)
);


------------------------------------------------------------------------------------------------
--
-- Create table tb_role
--
------------------------------------------------------------------------------------------------

CREATE TABLE movies.tb_role (
  role_id          INTEGER NOT NULL ,
  role_name        CHARACTER VARYING(60) NOT NULL ,
  created_by_user  CHARACTER VARYING(10) NOT NULL DEFAULT 'OS_SGAD' ,
  created_date     DATE ,
  updated_date     DATE ,
  CONSTRAINT pk_role PRIMARY KEY (role_id)
);


------------------------------------------------------------------------------------------------
--
-- Create table tb_person
--
------------------------------------------------------------------------------------------------

CREATE TABLE movies.tb_person (
  person_id        INTEGER NOT NULL ,
  person_name      CHARACTER VARYING(100) NOT NULL ,
  person_country   CHARACTER VARYING(40) , 
  person_dob       DATE NOT NULL ,
  person_dod       DATE ,
  person_parent_id INTEGER ,
  created_by_user  CHARACTER VARYING(10) NOT NULL DEFAULT 'OS_SGAD' ,
  created_date     DATE ,
  updated_date     DATE ,
  CONSTRAINT pk_person PRIMARY KEY (person_id) ,
  CONSTRAINT fk_person_parent FOREIGN KEY (person_parent_id) REFERENCES movies.tb_person (person_id)
);


------------------------------------------------------------------------------------------------
--
-- Create table tb_movie_person
--
------------------------------------------------------------------------------------------------

CREATE TABLE movies.tb_movie_person (
  movie_id         INTEGER NOT NULL ,
  person_id        INTEGER NOT NULL ,
  role_id          INTEGER NOT NULL ,
  movie_award_ind  CHAR(1) NOT NULL ,
  created_by_user  CHARACTER VARYING(10) NOT NULL DEFAULT 'OS_SGAD' ,
  created_date     DATE ,
  updated_date     DATE ,
  CONSTRAINT pk_movper PRIMARY KEY (movie_id, person_id, role_id) ,
  CONSTRAINT fk_movper_movie FOREIGN KEY (movie_id) REFERENCES movies.tb_movie (movie_id) ,
  CONSTRAINT fk_movper_person FOREIGN KEY (person_id) REFERENCES movies.tb_person (person_id) ,
  CONSTRAINT fk_movper_role FOREIGN KEY (role_id) REFERENCES movies.tb_role (role_id)
);
	 
COMMIT;
