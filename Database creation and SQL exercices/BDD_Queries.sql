--a) Obtener el nombre, país y fecha de nacimiento de aquellas personas que todavía no hayan
--  fallecido, según consta en la base de datos, ordenado por fecha de nacimiento.

SELECT tb_person.person_name, tb_person.person_country, tb_person.person_dob
FROM movies.tb_person
WHERE tb_PERSON.person_dod IS NULL
ORDER BY tb_PERSON.person_dob ASC;

--B)Obtener el nombre de género y el número total de películas asociadas a dicho género,
--excluyendo las películas de ‘Terror’, ordenado descendentemente por número total de
--películas.

SELECT tb_genre.genre_name, COUNT(tb_genre.genre_name)
FROM movies.tb_movie
JOIN movies.tb_genre
ON tb_movie.movie_genre_id = tb_genre.genre_id
WHERE tb_genre.genre_name != 'Terror'
GROUP BY tb_genre.genre_name
ORDER BY COUNT(tb_genre.genre_name) DESC;
;

--c) Obtener, para cada persona, su nombre, así como el máximo número de roles diferentes
--que haya asumido en una misma película. Mostrar únicamente aquellas personas que, en
--alguna película, hayan asumido más de un rol diferente.

SELECT tb_person.person_name, COUNT(tb_movie_person.role_id) Different_Roles
FROM movies.tb_person
JOIN movies.tb_movie_person ON tb_person.person_id = tb_movie_person.person_id
GROUP BY tb_person.person_name, tb_movie_person.movie_id
HAVING COUNT(tb_movie_person.role_id) > 1
ORDER BY COUNT(tb_movie_person.role_id) DESC;

--D)Obtener el título de la película, su género, y el número total de actores que han participado
--en dicha película, ordenado ascendentemente por número de actores. Deben incluirse
--aquellas películas para las que no consta ningún actor en la base de datos.

SELECT tb_movie.movie_title,tb_genre.genre_name, SUM(CASE WHEN tb_role.role_name = 'Actor' THEN 1 ELSE 0 END) Total_Actors
FROM movies.tb_movie 
LEFT OUTER JOIN movies.tb_movie_person  ON tb_movie.movie_id = tb_movie_person.movie_id
LEFT OUTER JOIN movies.tb_genre ON tb_movie.movie_genre_id = tb_genre.genre_id
LEFT OUTER JOIN movies.tb_role ON tb_role.role_id = tb_movie_person.role_id
GROUP BY tb_movie.movie_title,tb_genre.genre_name
ORDER BY count(distinct tb_movie_person.person_id) ASC;

--e)Obtener la lista completa de personas (aunque no hayan participado en ninguna película),
--mostrando el país, el nombre, la fecha de nacimiento, y el número de películas en la que
--dicha persona ha participado, únicamente, como Actor. Mostrar el resultado ordenado
--descendentemente por país y ascendentemente por número de películas.

SELECT tb_person.person_country,tb_person.person_name,tb_person.person_dob, SUM(CASE WHEN tb_role.role_name = 'Actor' THEN 1 ELSE 0 END) Total_Films
FROM movies.tb_person
LEFT OUTER JOIN movies.tb_movie_person ON tb_person.person_id = tb_movie_person.person_id
LEFT OUTER JOIN movies.tb_role ON tb_role.role_id = tb_movie_person.role_id
GROUP BY tb_person.person_country,tb_person.person_name,tb_person.person_dob
ORDER BY 
	tb_person.person_country DESC, 
	Total_Films ASC;