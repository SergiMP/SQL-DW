------------------------------------------------------------------------------------------
---                                                                                                                   
---  ---              Ejercicio 2 - Procedimientos Almacenados               ---      ---  
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
---
--- 1.	Definimos SEARCH_PATH  
---     
---
------------------------------------------------------------------------------------------
-- Para asegurar la atomicidad de la operacion añadimos un bloque BEGIN WORK, COMMIT

BEGIN WORK;
SET SEARCH_PATH TO movies_dw;
DROP FUNCTION IF EXISTS movies_dw.sp_load_movie_agg;

------------------------------------------------------------------------------------------
---
--- 2.	Procedemos con la definicion  procedimiento sp_load_movie_agg. 
---     
---
------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION sp_load_movie_agg()
RETURNS void AS $$

DECLARE v_row_movie_agg movies_dw.tb_movie_agg%rowtype;   

BEGIN

    -- Añadimos mensaje de inicio como visto en la resolucion del ejercicio.
    RAISE INFO 'Iniciando la carga de la tabla de agregados ...';

    -- Limpiamos los datos de la tabla como visto en la resolucion del ejercicio.
  	DELETE FROM movies_dw.tb_movie_agg;

    
    FOR v_row_movie_agg IN 
        -- Procedemos a escribir la consulta que devuelva los datos que necesitamos.
        -- Creamos una Common table expression que contenga los campos agregados que necesitaremos en los
        -- campos actor_count, usa_actor_count etc.
        -- La razon principal es simplificar la consulta para poder escribir simplemente JOIN datos_agregados c
        -- en vez de escribir un sub-query.

    WITH datos_agregados AS(
        SELECT movie_id, 
              COUNT(role_name) actor_count,
              SUM(CASE WHEN p.person_country = 'United States' THEN 1 ELSE 0 END) usa_actor_count,
              SUM(CASE WHEN p.person_country = 'Spain' THEN 1 ELSE 0 END) esp_actor_count,
              SUM(CASE WHEN mp.movie_award_ind = 'Y' THEN 1 ELSE 0 END) award_count
        FROM movies.tb_role r
        JOIN movies.tb_movie_person mp
          ON mp.role_id = r.role_id
        JOIN movies.tb_person p
          ON p.person_id = mp.person_id
        WHERE role_name = 'Actor'
        GROUP BY movie_id)

    SELECT m.movie_id,
          m.movie_title,
          m.movie_date,
          m.movie_format,
          g.genre_name,
          c.actor_count,
          c.usa_actor_count,
          c.esp_actor_count,
          c.award_count
    FROM movies.tb_movie m 
    JOIN movies.tb_genre g 
      ON  m.movie_genre_id = g.genre_id 
    JOIN datos_agregados c
      ON m.movie_id = c.movie_id
        -- Inicializamos el Loop
  LOOP 
        -- Nuestra variable v_row_movie_agg contiene todos los campos que necesitamos
        -- Por lo tanto lo unico que debemos de realizar es la insercion dentro de la tabla

    RAISE NOTICE '--> INSERTANDO fila en la tabla tb_movie_agg .... %',v_row_movie_agg;

    INSERT INTO movies_dw.tb_movie_agg  SELECT v_row_movie_agg.*;

    RAISE INFO 'Los datos se han cargcado correctamente.';

  END LOOP;    

END;
$$ LANGUAGE plpgsql;

COMMIT;

------------------------------------------------------------------------------------------
---
--- 3.	Procedemos con la definicion  procedimiento tb_person_agg. 
---     
---
------------------------------------------------------------------------------------------

-- Para asegurar la atomicidad de la operacion añadimos un bloque BEGIN WORK, COMMIT
BEGIN WORK;

CREATE OR REPLACE FUNCTION tb_person_agg()
RETURNS void AS $$

DECLARE v_row_person_agg movies_dw.tb_person_agg%rowtype;   

BEGIN

    -- Añadimos mensaje de inicio como visto en la resolucion del ejercicio.
    RAISE INFO 'Iniciando la carga de la tabla de agregados ...';

    -- Limpiamos los datos de la tabla como visto en la resolucion del ejercicio.
  	DELETE FROM movies_dw.tb_person_agg;

    
    FOR v_row_person_agg IN 
        -- Procedemos a escribir la consulta que devuelva los datos que necesitamos.
        -- En esta ocasion hemos creado dos CTE ya que despues de haber probado varias posibilidades
        -- nos parecio que esta era la mejor manera.
        -- En la primera tabla tenemos el numero total de peliculas diferentes en las cuales una persona
        -- ha participado independientemente del rol.

    WITH total_movies AS (
    SELECT c.person_name,
           count(c.person_name) movie_count
    FROM (
       SELECT mp.movie_id, mp.person_id, p.person_name, count(distinct mp.movie_id)
       FROM movies.tb_person p 
       JOIN movies.tb_movie_person mp 
        ON p.person_id = mp.person_id
       JOIN movies.tb_role r
        ON r.role_id = mp.role_id
      GROUP BY mp.movie_id, mp.person_id, p.person_name
    	  ) c
    GROUP BY  c.person_name
      ),
        -- En la segunda tabla calculamos la mayoria de agregados que necesitamos siguiendo una logica identica
        -- al ejemplo anterior.
        -- El razonamiento que hemos seguido es crear tablas que contengan la informacion que necesitamos, para
        -- unicamente tener que indicar la columna que queremos de cada tabla en la consulta principal.

   roles_and_awards_count AS(
  
  SELECT P.PERSON_NAME,
       SUM( CASE WHEN r.role_name = 'Actor' THEN 1 ELSE 0 END) actor_count,
	     SUM( CASE WHEN r.role_name = 'Director' THEN 1 ELSE 0 END) director_count,
	     SUM( CASE WHEN r.role_name = 'Producer' THEN 1 ELSE 0 END) productor_count,
	     SUM( CASE WHEN r.role_name NOT IN ('Actor','Director', 'Producer') THEN 1 ELSE 0 END) other_role_count,
	     SUM( CASE WHEN mp.movie_award_ind = 'Y' THEN 1 ELSE 0 END) award_count
  FROM movies.tb_role r
  JOIN movies.tb_movie_person mp
   ON r.role_id = mp.role_id
  JOIN movies.tb_person p 
   ON p.person_id = mp.person_id
  GROUP BY  P.PERSON_NAME	   
  ORDER BY P.PERSON_NAME
)
      SELECT p.person_id,
             tm.person_name,
             p.person_dob,
             tm.movie_count,
             rac.actor_count,
             rac.director_count,
             rac.productor_count,
             rac.other_role_count,
             rac.award_count
      FROM movies.tb_person p
      JOIN total_movies tm 
      ON tm.person_name = p.person_name
      JOIN roles_and_awards_count rac 
      ON rac.person_name = p.person_name

      --Una vez hemos definido la tabla sobre la cual realizar la iteracion, inicializamos el loop.
      --Como en el ejemplo anterior, dado que ya tenemos todos los campos que necesitamos, solo hemos
      -- de insertarlos en la tabla.

  LOOP 
      
    RAISE NOTICE '--> INSERTANDO fila en la tabla tb_person_agg .... %',v_row_person_agg;

    INSERT INTO movies_dw.tb_person_agg  SELECT v_row_person_agg.*;

    RAISE INFO 'Los datos se han cargcado correctamente.';

  END LOOP;    

END;
$$ LANGUAGE plpgsql;
COMMIT;

/**
-- Esta tabla nos permite ver el numero total de peliculas en los que la persona ha participado
-- independientemente del rol
-- Puedes hacer el Join en person_name con la tabla tb_person
WITH total_movies AS (
  SELECT c.person_name, count(c.person_name) movie_count
FROM (
SELECT mp.movie_id, mp.person_id, p.person_name, count(distinct mp.movie_id)
FROM movies.tb_person p 
 JOIN movies.tb_movie_person mp 
 ON p.person_id = mp.person_id
JOIN movies.tb_role r
 ON r.role_id = mp.role_id
 GROUP BY mp.movie_id, mp.person_id, p.person_name
	) c
GROUP BY  c.person_name
ORDER BY c.person_name
)

-- Creamos otra table donde podamos contabilizar el numero de roles y premios
   WITH roles_and_awards_count AS(
  
  SELECT P.PERSON_NAME,
       SUM( CASE WHEN r.role_name = 'Actor' THEN 1 ELSE 0 END) actor_count,
	     SUM( CASE WHEN r.role_name = 'Director' THEN 1 ELSE 0 END) director_count,
	     SUM( CASE WHEN r.role_name = 'Producer' THEN 1 ELSE 0 END) productor_count,
	     SUM( CASE WHEN r.role_name NOT IN ('Actor','Director', 'Producer') THEN 1 ELSE 0 END) other_role_count,
	     SUM( CASE WHEN mp.movie_award_ind = 'Y' THEN 1 ELSE 0 END) award_count
  FROM movies.tb_role r
  JOIN movies.tb_movie_person mp
   ON r.role_id = mp.role_id
  JOIN movies.tb_person p 
   ON p.person_id = mp.person_id
  GROUP BY  P.PERSON_NAME	   
  ORDER BY P.PERSON_NAME
)

SELECT * FROM roles_and_awards_count;
**/