--Returns apps from the play store that are in the game category
SELECT *
FROM play_store_apps
WHERE category = 'GAME'
ORDER BY name DESC;


--Returns apps in both app stores with a rating better than 4
SELECT DISTINCT(a.name), a.rating AS appl_rat, p.rating AS goog_rat, p.price
FROM play_store_apps AS p FULL JOIN app_store_apps AS a 
USING(name)
WHERE a.rating > 4.0 AND p.rating > 4.0
ORDER BY name;

--returns the name, total revenue based on lifespan, installs, and category for apps in both app stores
SELECT name, (lifespan*4000*12 - purchase_price) AS total_rev, install_count, category
FROM
(SELECT a.name, a.rating, MAX(a.review_count) AS review_count_max, a.price, p.install_count, p.category, 
	CASE
		WHEN a.price <1 THEN 10000
		WHEN a.price >1 THEN 10000 * a.price
	END purchase_price, 
	CASE 
		WHEN a.rating BETWEEN 0 AND 1 THEN 3
	 	WHEN a.rating BETWEEN 1 AND 1.5 THEN 4
		WHEN a.rating BETWEEN 1.5 AND 2 THEN 5
	 	WHEN a.rating BETWEEN 2 AND 2.5 THEN 6
		WHEN a.rating BETWEEN 2.5 AND 3 THEN 7
		WHEN a.rating BETWEEN 3 AND 3.5 THEN 8
	 	WHEN a.rating BETWEEN 3.5 AND 4 THEN 9
		WHEN a.rating BETWEEN 4 AND 4.5 THEN 10
	 	WHEN a.rating BETWEEN 4.5 AND 5 THEN 11
	END lifespan
FROM play_store_apps AS p INNER JOIN app_store_apps AS a
	ON p.name = a.name
WHERE a.rating IS NOT NULL
GROUP BY a.name, a.rating, a.price, lifespan, p.install_count, p.category) AS first_query
GROUP BY name, lifespan, purchase_price, category, install_count
ORDER BY total_rev DESC, install_count DESC;

