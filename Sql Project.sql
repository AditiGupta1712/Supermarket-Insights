##### Supermarket SQL Project  

###########################  DDL ############################

CREATE DATABASE IF NOT EXISTS supermarket;

USE supermarket;

CREATE TABLE IF NOT EXISTS aisles(
id INT(11),
aisle VARCHAR(100) NOT NULL,
PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS departments(
id INT(11),
department VARCHAR(30) NOT NULL,
PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS product(
id INT(11),
name VARCHAR(200) NOT NULL,
aisle_id INT(11) NOT NULL,
department_id INT(11) NOT NULL,

PRIMARY KEY(id),

FOREIGN KEY(aisle_id)
	REFERENCES aisles(id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    
FOREIGN KEY(department_id)
	REFERENCES departments(id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS orders(
id INT(11),
user_id INT(11) NOT NULL,
eval_set VARCHAR(10) NOT NULL,
order_number INT(11) NOT NULL,
order_dow INT(11),
order_hour_of_day INT(11),
days_since_prior_order INT(11),
PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS order_product(
order_id INT(11) NOT NULL,
product_id INT(11) NOT NULL,
add_to_cart_order INT(11) NOT NULL,
reordered INT(11) NOT NULL,

FOREIGN KEY(order_id)
	REFERENCES orders(id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    
FOREIGN KEY(product_id)
	REFERENCES product(id)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);

###########################  DML ############################

## Importing the Data

LOAD DATA LOCAL INFILE "E:\Aditi Gupta\SQL-for-supermarket-data-analysis-main\aisles.csv" INTO TABLE aisles
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "E:\Aditi Gupta\SQL-for-supermarket-data-analysis-main\departments.csv" INTO TABLE departments
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;


LOAD DATA LOCAL INFILE "E:\Aditi Gupta\SQL-for-supermarket-data-analysis-main\orders.csv" INTO TABLE orders
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "E:\Aditi Gupta\SQL-for-supermarket-data-analysis-main\products.csv" INTO TABLE product
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "E:\Aditi Gupta\SQL-for-supermarket-data-analysis-main\order_products.csv" INTO TABLE order_product
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- Top 10 Products Sales For Each Day of the Week

SET @rank := 0;

SELECT day, product_id, product_name, total_sales
FROM
    (SELECT product_id, product_name, total_sales, day,
    @rank := IF(@current_day = day, @rank + 1, 1) AS rank,
    @current_day := day
    FROM
        (SELECT p.id AS product_id, p.name AS product_name, COUNT(*) AS total_sales, o.order_dow AS day
        FROM product AS p
        INNER JOIN order_product AS op ON op.product_id = p.id
        INNER JOIN orders AS o ON op.order_id = o.id
        GROUP BY product_id, product_name, day
        HAVING day BETWEEN 1 AND 5) AS t1
    ORDER BY day, total_sales DESC) AS t2
WHERE rank <= 10;

-- 5 most popular products in each aisle from Monday to Friday
SET @rank := 0;

SELECT aisle, day, product_id
FROM
    (SELECT day, aisle, product_id, total_sales,
    @rank := IF(@current_aisle = aisle AND @current_day = day, @rank + 1, 1) AS rank,
    @current_day := day,
    @current_aisle := aisle
    FROM
        (SELECT p.id AS product_id, a.aisle AS aisle, COUNT(*) AS total_sales, o.order_dow AS day
        FROM product AS p
        INNER JOIN order_product AS op ON op.product_id = p.id
        INNER JOIN orders AS o ON op.order_id = o.id
        INNER JOIN aisles AS a ON p.aisle_id = a.id
        GROUP BY product_id, aisle, day
        HAVING day BETWEEN 1 AND 5) AS t1
    ORDER BY aisle, day, total_sales DESC) AS t2
WHERE rank <= 5;

-- Top 10 products with the highest reorder rate

SELECT product_id
FROM order_product
GROUP BY product_id
ORDER BY SUM(reordered) / COUNT(*) DESC
LIMIT 10;

-- Shopper’s aisle list for each order

SELECT op.order_id, a.id AS aisle_id
FROM order_product AS op
INNER JOIN aisles AS a ON op.product_id = a.id
GROUP BY op.order_id, aisle_id;

-- Most popular shopping paths

SELECT aisles, COUNT(*) AS count
FROM
    (SELECT order_id, GROUP_CONCAT(DISTINCT(a.id) ORDER BY a.id SEPARATOR ' ') AS aisles
    FROM order_product AS op
    INNER JOIN product AS p ON op.product_id = p.id
    INNER JOIN aisles AS a ON p.aisle_id = a.id
    GROUP BY order_id
    HAVING COUNT(DISTINCT(a.id)) >= 2) AS t
GROUP BY aisles
ORDER BY count DESC;

-- Top pairwise associations in products

SELECT p1.name AS product1, p2.name AS product2
FROM
    (SELECT op1.product_id AS product1, op2.product_id AS product2, COUNT(*) AS count
    FROM order_product AS op1
    INNER JOIN order_product AS op2 ON op1.order_id = op2.order_id
    WHERE op1.product_id < op2.product_id
    GROUP BY product1, product2
    ORDER BY count DESC
    LIMIT 100) AS t
INNER JOIN product AS p1 ON t.product1 = p1.id
INNER JOIN product AS p2 ON t.product2 = p2.id;


