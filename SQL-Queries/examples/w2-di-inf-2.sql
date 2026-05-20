USE classicmodels;



-- 5.1 Ermitteln Sie alle Untergebenen eines bestimmten Angestellten (z.B.: President, Sales Manager, ...)

WITH RECURSIVE Superiors AS (
  SELECT *, 0 AS LEVEL FROM employees WHERE `jobTitle` = 'President' UNION ALL
  SELECT e.*, s.LEVEL +1 FROM employees e JOIN subordinates s ON e.`reportsTo` = s.`employeeNumber`
) SELECT * FROM Superiors WHERE LEVEL > 0 ORDER BY LEVEL, `employeeNumber`;


-- 5.2 Ermitteln Sie alle Vorgesetzten eines gegebenen Angestellten.

WITH RECURSIVE manager AS (
  SELECT e.* FROM employees e WHERE employeeNumber = 1143 UNION
  SELECT e1.* FROM employees e1, manager m WHERE e1.reportsTo = m.employeeNumber
) SELECT * FROM manager;


-- 5.3 Geben Sie nur die Ersten beiden Ebenen von Untergebenen aus.

WITH RECURSIVE subordinates AS (
  SELECT *, 0 AS LEVEL FROM employees WHERE `jobTitle` = 'President' UNION ALL
  SELECT e.*, s.LEVEL +1 FROM employees e JOIN subordinates s ON e.`reportsTo` = s.employeeNumber
) SELECT * FROM subordinates WHERE LEVEL BETWEEN 1 AND 2 ORDER BY LEVEL, `employeeNumber`;


-- 6.1 Find all customers who experienced a shipping delay.
-- The query should list all customers who have orders that took strictly longer than 4 days.

WITH Base AS (
  SELECT o.customerNumber FROM orders o WHERE DATEDIFF (o.shippedDate, o.orderDate) > 4
) SELECT DISTINCT c.customerNumber FROM customers c JOIN Base b ON c.customerNumber = b.customerNumber;


SELECT c.* FROM customers c WHERE EXISTS (
  SELECT 0 FROM orders o WHERE DATEDIFF (o.shippedDate, o.orderDate) > 4
  AND c.customerNumber = o.customerNumber
);