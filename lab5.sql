USE sakila;

#1 Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT COUNT(*)
FROM inventory as inv
INNER JOIN (SELECT title, film_id
			FROM film
            WHERE title = "Hunchback Impossible") as f
ON inv.film_id = f.film_id;


#2 List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT * 
FROM film
WHERE length > (SELECT AVG(length) FROM film);


#3 Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT first_name, last_name
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
INNER JOIN (SELECT film_id
			FROM film
            WHERE title = "Alone Trip") as film
ON film_actor.film_id = film.film_id;

#4 Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT film.film_id, title, category_name
FROM film
INNER JOIN film_category as fc
ON film.film_id = fc.film_id
INNER JOIN (SELECT category_id, name as category_name
			FROM category
            WHERE name = "Family") as cat
ON fc.category_id = cat.category_id;

#5 Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary 
# and foreign keys.

SELECT c.first_name, c.last_name, c.email, country.country
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city 
ON a.city_id = city.city_id
JOIN (SELECT country_id, country FROM country WHERE country = "Canada") country
ON city.country_id = country.country_id;

#6 Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. 
#First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

SELECT film.title 
FROM film 
JOIN film_actor ON film.film_id = film_actor.film_id 
WHERE film_actor.actor_id = (
    SELECT actor_id 
    FROM (
        SELECT actor_id, COUNT(film_id) AS films 
        FROM film_actor 
        GROUP BY actor_id 
        ORDER BY films DESC 
        LIMIT 1
    ) AS subquery
);

#7 Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., 
#the customer who has made the largest sum of payments.

SELECT film.title 
FROM film 
JOIN inventory ON film.film_id = inventory.film_id 
JOIN rental ON inventory.inventory_id = rental.inventory_id 
JOIN payment ON rental.rental_id = payment.rental_id 
WHERE payment.customer_id = (
    SELECT customer_id 
    FROM payment 
    GROUP BY customer_id 
    ORDER BY SUM(amount) DESC 
    LIMIT 1
);

#8 Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
#You can use subqueries to accomplish this.

SELECT customer_id, SUM(amount) as total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent > (SELECT AVG(amount) FROM payment);