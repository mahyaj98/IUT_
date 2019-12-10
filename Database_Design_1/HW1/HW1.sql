-- DATABASE DESIGN 1 3981 @ IUT
-- YOUR NAME:   Mahya Jamshidian
-- YOUR STUDENT NUMBER:   9525133


---- Q10-a

SELECT first_name, last_name, city FROM customer 
INNER JOIN address ON address.address_id = customer.address_id
INNER JOIN city ON city.city_id = address.city_id
WHERE country_id = 46



---- Q10-b

SELECT first_name, last_name FROM actor 
INNER JOIN film_actor ON film_actor.actor_id = actor.actor_id
INNER JOIN film ON film.film_id = film_actor.film_id
INNER JOIN inventory ON inventory.film_id = film.film_id
INNER JOIN rental on rental.inventory_id = inventory.inventory_id
WHERE customer_id IN (SELECT customer_id
    FROM customer
    INNER JOIN address ON customer.address_id = address.address_id
    INNER JOIN city ON city.city_id = address.city_id
    WHERE country_id = 46)
GROUP BY actor.first_name, actor.last_name





---- Q10-c



SELECT  first_name, last_name, rental_date, return_date 
FROM rental
INNER join (
    SELECT customer_id, first_name, last_name
    FROM customer
    INNER JOIN address ON customer.address_id = address.address_id
    INNER JOIN city ON city.city_id = address.city_id
    where country_id = 46
) AS IRAN  ON IRAN.customer_id = rental.customer_id
WHERE date(return_date) = date(rental_date)



---- Q10-d

SELECT first_name, last_name FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
INNER JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE rental_rate > 4 OR length > 100
GROUP BY first_name, last_name;




---- Q10-e


SELECT name 
FROM category 
INNER JOIN film_category ON film_category.category_id = category.category_id
INNER JOIN film ON film.film_id = film_category.film_id
WHERE film.film_id IN ((
    SELECT film_id
    FROM inventory
    INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
    WHERE store_id = 2 AND date(return_date) - date(rental_date) > 9)
    EXCEPT
    (SELECT film_id 
    FROM inventory 
    WHERE store_id = 1))
GROUP BY name;




---- Q10-f

SELECT * 
FROM film, (
    SELECT MAX(char_length(tmp1.title))
    FROM (
    SELECT title FROM film
    WHERE title LIKE '%s%s%' OR title LIKE '%S%S%' OR title LIKE '%s%S%' OR title LIKE '%S%s%' OR title LIKE '%g' OR title LIKE '%G') 
    as tmp1
    ) AS tmp2

where  char_length(title) > tmp2.max




---- Q10-g


WITH T1(customer_id, first_name,last_name, C1) AS (SELECT customer_id, customer.first_name, customer.last_name, COUNT(customer_id)
    FROM customer INNER JOIN rental USING(customer_id)
    INNER JOIN staff USING(staff_id)
    WHERE staff_id =1
    GROUP BY customer_id)
,T2(customer_id, first_name,last_name, C2) AS (SELECT customer_id, customer.first_name, customer.last_name, COUNT(customer_id)
    FROM customer INNER JOIN rental USING(customer_id)
    INNER JOIN staff USING(staff_id)
    WHERE staff_id =2
    GROUP BY customer_id)

SELECT T1.first_name, T1.last_name, C1, C2
FROM T1 FULL OUTER JOIN T2 USING(customer_id)
ORDER BY C1 DESC, C2 DESC



---- Q10-h


CREATE TABLE category_rating(category_id, category_name, avg_rate, max_len)
AS (SELECT category_id, category.name, AVG(rental_rate), MAX(length)
    FROM category
    INNER JOIN film_category USING (category_id)
    INNER JOIN film USING (film_id)
    GROUP BY category_id)



---- Q10-i





---- Q10-j
