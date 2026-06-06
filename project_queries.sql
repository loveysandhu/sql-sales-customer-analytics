-- How many customers are there in total?
use sample;
   SELECT COUNT(*) as total_customers
   FROM customers;
  
-- Which countries have the most customers?
   SELECT country , COUNT(*) as customers_per_country
   FROM customers
   GROUP BY country
   ORDER BY customers_per_country DESC;
   
   
-- Who are the top 5 customers by credit limit?
   SELECT custId , customerName ,country, creditLimit
   FROM customers
   ORDER BY creditLimit DESC
   LIMIT 5;
   
   
-- How many employees work in each office?
   SELECT o.city, COUNT(e.eId) AS total_employees
   FROM employees e
   JOIN offices o ON e.officeCode = o.officeCode
   GROUP BY o.city
   ORDER BY total_employees DESC;


-- What is the average salary by department?
   SELECT department , AVG(salary) as avg_salary
   FROM employees
   GROUP BY department
   ORDER BY avg_salary DESC;
   
   
   
-- Who are the top 5 highest paid employees?
  SELECT empName , jobTitle , salary
  FROM employees
  ORDER BY salary DESC
  LIMIT 5;
  
  
-- How many orders are there per year?
   SELECT YEAR(orderDate) as year , COUNT(orderNumber) as total_orders
   FROM orders
   GROUP BY year
   ORDER BY year;
-- Which customers placed the most orders?
   SELECT c.customerName ,COUNT(o.custId) as total_orders
   FROM customers c
   JOIN orders o
   ON c.custId = o.custId
   GROUP BY c.customerName 
   ORDER BY total_orders DESC
   LIMIT 10;
   
-- What is the total sales revenue by year?
   SELECT YEAR(o.orderDate) AS year, SUM(od.quantityOrdered * od.priceEach) AS total_sales
   FROM orders o
   JOIN orderdetails od ON o.orderNumber = od.orderNumber
   GROUP BY YEAR(o.orderDate)
   ORDER BY year;
-- Which product categories generate the most revenue?
   SELECT p.category, SUM(od.quantityOrdered * od.priceEach) AS total_revenue
   FROM orderdetails od
   JOIN products p 
   ON od.productCode = p.productCode
   GROUP BY p.category
   ORDER BY total_revenue DESC;

-- What are the top 10 best-selling products by quantity?
   SELECT p.productName, SUM(od.quantityOrdered) AS total_quantity
   FROM orderdetails od
   JOIN products p ON od.productCode = p.productCode
   GROUP BY p.productName
   ORDER BY total_quantity DESC
   LIMIT 10;

-- What is the average order value (AOV)?
    SELECT AVG(order_total) AS avg_order_value
    FROM (
    SELECT o.orderNumber, SUM(od.quantityOrdered * od.priceEach) AS order_total
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    GROUP BY o.orderNumber
	) AS order_summary;

-- Is there a trend of increasing or decreasing sales over time?
   SELECT YEAR(o.orderDate) AS year, MONTH(o.orderDate) AS month,
   SUM(od.quantityOrdered * od.priceEach) AS monthly_sales
   FROM orders o
   JOIN orderdetails od
   ON o.orderNumber = od.orderNumber
   GROUP BY YEAR(o.orderDate), MONTH(o.orderDate)
   ORDER BY year, month;

-- Which sales reps handle the most customers?
  SELECT e.empName, COUNT(c.custId) AS total_customers
  FROM employees e
  JOIN customers c ON e.eId = c.salesRepEmployeeNumber
  GROUP BY e.empName
  ORDER BY total_customers DESC;

-- What is the distribution of customer credit limits by country?
  SELECT country, AVG(creditLimit) AS avg_credit_limit, MAX(creditLimit) AS max_credit_limit
  FROM customers
  GROUP BY country
  ORDER BY avg_credit_limit DESC;

-- Rank customers by total spending ?
   SELECT c.customerName, 
       SUM(od.quantityOrdered * od.priceEach) AS total_spent,
       RANK() OVER (ORDER BY SUM(od.quantityOrdered * od.priceEach) DESC) AS customer_rank
   FROM customers c
   JOIN orders o ON c.custId = o.custId
   JOIN orderdetails od ON o.orderNumber = od.orderNumber
   GROUP BY c.customerName
   ORDER BY total_spent DESC
   LIMIT 10;

-- Running total of monthly sales ? 
   SELECT YEAR(o.orderDate) AS year, 
       MONTH(o.orderDate) AS month,
       SUM(od.quantityOrdered * od.priceEach) AS monthly_sales,
       SUM(SUM(od.quantityOrdered * od.priceEach)) 
            OVER (ORDER BY YEAR(o.orderDate), MONTH(o.orderDate)) AS running_total_sales
   FROM orders o
   JOIN orderdetails od ON o.orderNumber = od.orderNumber
   GROUP BY YEAR(o.orderDate), MONTH(o.orderDate)
   ORDER BY year, month;


-- ⏳ Average delivery time per country ? 
   WITH delivery_times AS (
    SELECT c.country,
           DATEDIFF(o.shippedDate, o.orderDate) AS delivery_days
    FROM orders o
    JOIN customers c ON o.custId = c.custId
    WHERE o.shippedDate IS NOT NULL
   )
  SELECT country, AVG(delivery_days) AS avg_delivery_time
  FROM delivery_times
  GROUP BY country
  ORDER BY avg_delivery_time ASC;

-- 💳 Do higher credit limits lead to more orders?
   SELECT c.customerName, c.creditLimit,
          COUNT(o.orderNumber) AS total_orders
   FROM customers c
   JOIN orders o 
   ON c.custId = o.custId
   GROUP BY c.customerName, c.creditLimit
   ORDER BY c.creditLimit DESC;



   
-- Top employees by total sales generated
SELECT e.empName, e.jobTitle, 
       SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM employees e
JOIN customers c ON e.eId = c.salesRepEmployeeNumber
JOIN orders o ON c.custId = o.custId
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY e.empName, e.jobTitle
ORDER BY total_sales DESC
LIMIT 10;



   
   
   
   
   
   
   
   
   
   
   
   
   