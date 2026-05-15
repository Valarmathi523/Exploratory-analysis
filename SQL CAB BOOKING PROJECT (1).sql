CREATE DATABASE CAB;
USE CAB;
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);
CREATE TABLE drivers (
    driver_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    rating DECIMAL(2,1)
);
CREATE TABLE rides (
    ride_id INT PRIMARY KEY,
    user_id INT,
    driver_id INT,
    distance DECIMAL(5,2),
    fare DECIMAL(10,2),
    status VARCHAR(20),
    ride_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    ride_id INT,
    payment_method VARCHAR(20),
    payment_status VARCHAR(20),
    FOREIGN KEY (ride_id) REFERENCES rides(ride_id)
);
SELECT * FROM rides WHERE fare > 200;
SELECT * FROM users WHERE signup_date > '2023-01-01';
SELECT * FROM drivers WHERE rating > 4.5;
SELECT * FROM rides WHERE distance BETWEEN 5 AND 15;
SELECT * FROM rides WHERE status = 'completed' AND fare > 100;
SELECT * FROM users WHERE city IN ('Chennai', 'Bangalore');
SELECT * FROM drivers WHERE name LIKE 'A%';
SELECT r.* 
FROM rides r
JOIN payments p ON r.ride_id = p.ride_id
WHERE p.payment_method = 'UPI';
SELECT * FROM rides WHERE fare <> 0;
SELECT * FROM users WHERE MONTH(signup_date) = 1;
#SELECT+WHERE+JOINS
SELECT u.name, r.fare
FROM rides r
JOIN users u ON r.user_id = u.user_id
WHERE r.fare > 200;
SELECT d.name, r.distance
FROM rides r
JOIN drivers d ON r.driver_id = d.driver_id
WHERE r.distance > 10;
SELECT u.name, r.*
FROM rides r
JOIN users u ON r.user_id = u.user_id
JOIN payments p ON r.ride_id = p.ride_id
WHERE p.payment_status = 'failed';
SELECT DISTINCT u.*
FROM users u
JOIN rides r ON u.user_id = r.user_id
JOIN drivers d ON r.driver_id = d.driver_id
WHERE u.city <> d.city;
SELECT u.name, d.name, r.*
FROM rides r
JOIN users u ON r.user_id = u.user_id
JOIN drivers d ON r.driver_id = d.driver_id
WHERE r.status = 'completed';
SELECT r.*
FROM rides r
JOIN drivers d ON r.driver_id = d.driver_id
WHERE d.rating > 4.5;
SELECT r.*
FROM rides r
JOIN payments p ON r.ride_id = p.ride_id
WHERE p.payment_method = 'Cash';
SELECT r.*
FROM rides r
JOIN users u ON r.user_id = u.user_id
JOIN drivers d ON r.driver_id = d.driver_id
WHERE u.city = d.city;
SELECT r.*
FROM rides r
JOIN payments p ON r.ride_id = p.ride_id
WHERE p.payment_status = 'failed' AND r.status = 'completed';
SELECT DISTINCT u.*
FROM users u
JOIN rides r ON u.user_id = r.user_id
WHERE r.fare > 500;
# GROUPBY
SELECT user_id, COUNT(*) AS total_rides
FROM rides
GROUP BY user_id
HAVING COUNT(*) > 2;
SELECT driver_id, SUM(fare) AS earnings
FROM rides
GROUP BY driver_id
HAVING SUM(fare) > 1000;
SELECT u.city, AVG(r.fare) AS avg_fare
FROM rides r
JOIN users u ON r.user_id = u.user_id
GROUP BY u.city
HAVING AVG(r.fare) > 150;
SELECT ride_date, COUNT(*) AS ride_count
FROM rides
GROUP BY ride_date
HAVING COUNT(*) > 5;
SELECT user_id, SUM(distance) AS total_distance
FROM rides
GROUP BY user_id
HAVING SUM(distance) > 50;
SELECT driver_id, COUNT(*) AS completed_rides
FROM rides
WHERE status = 'completed'
GROUP BY driver_id
HAVING COUNT(*) > 3;
SELECT payment_method, COUNT(*) 
FROM payments
GROUP BY payment_method
HAVING COUNT(*) > 2;
SELECT city, COUNT(*) 
FROM users
GROUP BY city
HAVING COUNT(*) > 10;
SELECT * FROM drivers WHERE rating > 4.2;
SELECT user_id, COUNT(*) AS cancelled
FROM rides
WHERE status = 'cancelled'
GROUP BY user_id
HAVING COUNT(*) > 1;
# ORDERBY+ LIMIT
SELECT * FROM rides ORDER BY fare DESC LIMIT 5;
SELECT * FROM rides ORDER BY distance ASC LIMIT 3;
SELECT user_id, SUM(fare) AS total_spending
FROM rides
GROUP BY user_id
ORDER BY total_spending DESC
LIMIT 5;
SELECT * FROM drivers ORDER BY rating DESC LIMIT 3;
SELECT * FROM rides
ORDER BY fare DESC
LIMIT 1 OFFSET 1;
#SUBQUERIES
SELECT user_id
FROM rides
GROUP BY user_id
HAVING SUM(fare) > (
    SELECT AVG(total_spending)
    FROM (
        SELECT SUM(fare) AS total_spending
        FROM rides
        GROUP BY user_id
    ) t
);
SELECT driver_id
FROM rides
GROUP BY driver_id
HAVING SUM(fare) > (
    SELECT AVG(total)
    FROM (
        SELECT SUM(fare) AS total
        FROM rides
        GROUP BY driver_id
    ) t
);
SELECT * FROM rides
WHERE fare > (SELECT AVG(fare) FROM rides);
SELECT * FROM users
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM rides);
SELECT * FROM drivers
WHERE driver_id NOT IN (
    SELECT driver_id FROM rides WHERE status = 'completed'
);SELECT * FROM drivers
WHERE driver_id NOT IN (
    SELECT driver_id FROM rides WHERE status = 'completed'
);
SELECT * FROM rides
WHERE fare = (SELECT MAX(fare) FROM rides);
SELECT user_id
FROM rides
GROUP BY user_id
ORDER BY COUNT(*) DESC
LIMIT 1;
SELECT driver_id
FROM rides
GROUP BY driver_id
ORDER BY SUM(fare) DESC
LIMIT 1 OFFSET 1;
SELECT *
FROM rides r
WHERE fare > (
    SELECT AVG(fare)
    FROM rides
    WHERE user_id = r.user_id
);
SELECT user_id
FROM rides
GROUP BY user_id
HAVING COUNT(*) = 1;
# UPDATES/DELETE
UPDATE rides r
JOIN payments p ON r.ride_id = p.ride_id
SET r.status = 'completed'
WHERE p.payment_status = 'success';
DELETE FROM rides
WHERE status = 'cancelled' AND fare = 0;
UPDATE drivers
SET rating = 3
WHERE rating < 3;
DELIMITER //

CREATE PROCEDURE GetUserRides(IN uid INT, IN min_fare DECIMAL(10,2))
BEGIN
    SELECT *
    FROM rides
    WHERE user_id = uid AND fare > min_fare;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE GetDriversByRating(IN min_rating DECIMAL(2,1))
BEGIN
    SELECT *
    FROM drivers
    WHERE rating > min_rating;
END //

DELIMITER ;









