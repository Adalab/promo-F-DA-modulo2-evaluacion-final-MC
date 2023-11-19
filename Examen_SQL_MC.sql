use sakila;
-- Ejercicio 1 Selecciona todos los nombres de las pelis sin duplicados --

SELECT `title`
	FROM `film`
	GROUP BY `title`
	HAVING COUNT(DISTINCT `title`)=1;

-- Ejercicio 2 Muestra los nombres de las películas con PG 13 --

SELECT `title`
	FROM `film`
	WHERE `rating` = 'PG-13';

-- Ejercicio 3 Encuentra el título y descripción de películas "amazing" --

SELECT `title`, `description`
	FROM `film`
	WHERE `description` LIKE '%AMAZING%';

-- Ejercicio 4 Encuentra el título de películas con más de 120 --

SELECT `title`
	FROM `film`
	WHERE `length` > 120;

-- Ejercicio 5 Recupera el nombre de todos los actores--

SELECT `first_name`, `last_name`
	FROM `actor`

-- Ejercicio 6 Encuentra el nombre y apellido de actores con apellido Gibson --


SELECT `first_name`, `last_name`
	FROM `actor`
	WHERE `last_name`  LIKE '%Gibson%';

-- Ejercicio 7 actores con ID entre 10 y 20.

SELECT `first_name`, `last_name`,`actor_id`
	FROM `actor`
	WHERE `actor_id`BETWEEN 10 AND 20;

-- Ejercicio 8 películas que no sean ni "R" ni "PG13" --

SELECT `title`
	FROM `film`
	WHERE `rating` NOT IN ('R', 'PG-13');

-- Ejercicio 9 encuentra la cantidad total de películas en cada clasificación de la tabla y muestra su recuento --

SELECT `rating`, COUNT(*) as `cantidad_total_peliculas`
	FROM `film`
	GROUP BY `rating`;
    
-- En este casi el COUNT cuenta el nº total de filas por cada grupo especificado en el GROUP BY. 
-- Ejercicio 10 encuentra total películas alquiladas y muestra id, nombre y apellido junto a las películas alquiladas --

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS cantidad_películas_alquiladas
	FROM customer AS c
	INNER JOIN rental AS r
	ON c.customer_id = r.customer_id
	GROUP BY c.customer_id, c.first_name, c.last_name;
    
-- Ejercicio 11 total de películas alquiladas por categoría y muestra la categoría  y el recuento de alquileres -- 

SELECT  c.name  AS  categoria , COUNT(r.rental_id) AS  recuento_peliculas_alquiladas 
	FROM category AS c
	INNER JOIN film_category AS fc
	ON c.category_id = fc.category_id
	INNER JOIN film AS f
    ON fc.film_id = f.film_id
	INNER JOIN inventory AS i 
    ON f.film_id = i.film_id
	INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
	GROUP BY c.name;
    
-- Ejercicio 12 Promedio de duración de las películas para cada clasificación de la tabla film -- 

SELECT DISTINCT`rating`
	FROM `film`;

SELECT `rating`, AVG(`length`) AS `promedio_duracion`
	FROM `film`
	GROUP BY `rating`;

-- Ejercicio 13 nombre y apellidos de actores que aparecen en la película "Indian Love" --

SELECT a.first_name, a.last_name
	FROM actor AS a
	WHERE a.actor_id IN (
		SELECT fa.actor_id
		FROM film_actor AS fa
		INNER JOIN film AS f 
		ON fa.film_id = f.film_id
		WHERE f.title = 'Indian Love'
);

-- Ejercicio 14 películas cuyo título contengan la palabra "dog" o "cat" en la descripción --

SELECT `title`, `description`
	FROM `film`
	WHERE `description` LIKE '%dog%' OR `description` LIKE '%cat%';

-- Sé que no es necesario que parezca la descripción, pero es la única manera de asesorarme de que el ejercicio está bien --

-- Ejercicio 15 hay algún actor que no aparece en ninguna película en la tabla film_actor --

SELECT `first_name`, `last_name`
FROM `actor`
WHERE `actor_id` NOT IN (
    SELECT DISTINCT `actor_id`
    FROM `film_actor`
);


-- El resultado es una columna vacía, por lo tanto, todos los actores aparecen en la tabla film_actor --

-- Ejercicio 16 Encuentra el título de todas las películas lanzadas entre el año 2005 y 2010.

SELECT  `title`, `release_year`
	FROM `film`
	WHERE `release_year` BETWEEN 2005 AND 2010;

-- Ejercicio 17 Encuentra el título de todas las películas que son de la misma categoría que family --

SELECT `name`
FROM `category`;  

SELECT f.title
	FROM film AS f
	INNER JOIN film_category AS fc 
	ON f.film_id = fc.film_id
	INNER JOIN category AS c 
	ON fc.category_id = c.category_id
	WHERE c.name = 'Family';
    
-- Ejercicio 18 Muestra el nombre y apellido de los actores que aparecen en más de 10 películas --

SELECT a.first_name, a.last_name, COUNT(fa.film_id) As mas_diez_películas
	FROM actor AS a
	INNER JOIN film_actor AS fa 
	ON a.actor_id = fa.actor_id
	GROUP BY a.actor_id
	HAVING COUNT(fa.film_id) > 10;

-- Ejercicio 19 Encuentra el título de las pelis que son "R" y tienen más de dos horas de duración --

SELECT title
	FROM film
	WHERE rating = 'R' AND length > 120;

-- Ejercicio 20 Encuentra las categorías de películas que tiene más de 120 minutos y muestra el nombre de la categoría junto al promedio de duración --

SELECT c.name AS nombre_categorías, AVG(f.length) AS duración_promedio
	FROM category AS c
	INNER JOIN film_category AS fc 
	ON c.category_id = fc.category_id
	INNER JOIN film AS f 
	ON fc.film_id = f.film_id
	GROUP BY c.category_id
	HAVING AVG(f.length) > 120;
    

    
-- Ejercicio 21 Actores que han actuado en al menos en 5 películas. Muestra el nombre del actor junto al de las películas.  

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS cantidad_películas
	FROM actor AS a
	INNER JOIN film_actor AS fa 
	ON a.actor_id = fa.actor_id
	GROUP BY a.actor_id
	HAVING COUNT(fa.film_id) >= 5
	ORDER BY COUNT(fa.film_id)  ASC;

-- El orden no lo pedía, pero me quería asesorar de que eran más de 5.

-- Ejercicio 22 Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Subconsulta para encontar los rentals_ids y selecciona las películas correspondientes.

SELECT title
FROM film
WHERE film_id IN (
    SELECT DISTINCT film_id
    FROM rental 
    WHERE (rental.return_date - rental.rental_date) > 5
);

-- Ejercicio 23 Encuentra el nombre y apellido de actores que no han actuado en Horror. Utiliza subconsulta para encontrar los actores que han actuado en Horror y exclúyelos de la lista de actores.


SELECT DISTINCT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id NOT IN (
    SELECT film_actor.actor_id
    FROM film_actor
    INNER JOIN film_category ON film_actor.film_id = film_category.film_id
    INNER JOIN category ON film_category.category_id = category.category_id
    WHERE category.name = "Horror"
);


-- BONUS: Ejercicio 24. Encuentra el título de las comedias con una duración de las de 180 minutos en la tabla film.

SELECT title
FROM film
WHERE film_id IN (
    SELECT film_category.film_id
    FROM film_category
    INNER JOIN category 
    ON film_category.category_id = category.category_id
    WHERE category.name = "Comedy"
)
AND length > 180;

-- BONUS: Ejercicio 25. Encuentra todos los actores que han actuado juntos en al menos una película. Muestra nombre, apellido y número de películas en las que han actuado juntos.

