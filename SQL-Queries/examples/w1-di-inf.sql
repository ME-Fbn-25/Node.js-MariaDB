/*
AUFGABEN - Column Expressions:
Lösen Sie die folgende Aufgabe einmal unter der Verwendung einer Subquery (SQ) und einmal mittels eines Joins.

-- Show all the orders shipped on October 3, 2017, and each order's related customer last name.
-- List all the customer names and a count of the orders they placed.
-- Show a list of customers and the last date on which they placed an order.

AUFGABEN - Filters:
-- List cutomers and all the details from their last order.
-- [OPTIONAL] Find all accessories that are priced greater than any clothing item.
*/
USE SalesOrders;


SELECT OrderNumber, ShipDate, (
  SELECT CustLastName FROM Customers c WHERE c.CustomerID = o.CustomerID
) AS CustLastName FROM Orders o WHERE ShipDate = '2017-10-03';

SELECT o.OrderNumber, o.ShipDate, c.CustLastName FROM Orders o
JOIN Customer c ON o.CustomerID = c.CustomerID
WHERE o.ShipDate = '2017-10-03';


SELECT c.CustFirstName, c.CustLastName, (
  SELECT COUNT(o.OrderNumber) FROM Orders o
  WHERE o.CustomerID = c.CustomerID
) AS OrderCount FROM Customers c;

SELECT c.CustFirstName, c.CustLastName, COUNT(o.OrderNumber) AS OrderCount FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID GROUP BY c.CustomerID, c.CustFirstName, c.CustLastName;


SELECT c.CustFirstName, c.CustLastName, (
  SELECT MAX(OrderDate) FROM Orders o WHERE o.CustomerID = c.CustomerID
) AS LastOrderDate FROM Customers c;

SELECT c.CustFirstName, c.CustLastName, MAX(o.OrderDate) LastOrderDate FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID GROUP BY c.CustomerID, c.CustFirstName, c.CustLastName;


SELECT c.CustFirstName, c.CustLastName, o.* FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID WHERE o.OrderDate = (
  SELECT MAX(OrderDate) FROM Orders i_o WHERE i_o.CustomerID = c.CustomerID
);


SELECT ProductName, RetailPrice FROM Products WHERE CategoryID = (SELECT CategoryID FROM Categories WHERE CategoryDescription = 'Accessories')
AND RetailPrice > (SELECT MAX(RetailPrice) FROM Products WHERE CategoryID = (SELECT CategoryID FROM Categories WHERE CategoryDescription = 'Clothing'));





-- CTE -> AUFGABE 1: Find customers who purchased 'Wheels', 'Helmet', 'Glasses' & 'Gloves' (Use SalesOrders DB)

WITH CustPurchases AS (
  SELECT c.CustomerID, c.CustFirstName, c.CustLastName, p.ProductName,
  CASE
    WHEN p.ProductName LIKE '%Wheels%' THEN 'Wheels'
    WHEN p.ProductName LIKE '%Helmet%' THEN 'Helmet'
    WHEN p.ProductName LIKE '%Glasses%' THEN 'Glasses'
    WHEN p.ProductName LIKE '%Gloves%' THEN 'Gloves'
  END AS Category FROM Customers c
  INNER JOIN Orders o ON c.CustomerID = o.CustomerID
  INNER JOIN Order_Details od ON o.OrderNumber = od.OrderNumber
  INNER JOIN Products p ON od.ProductNumber = p.ProductNumber
  WHERE p.ProductName REGEXP 'Wheels|Helmet|Glasses|Gloves'
)
SELECT CustomerID, CustFirstName, CustLastName FROM CustPurchases
GROUP BY CustomerID, CustFirstName, CustLastName HAVING COUNT(DISTINCT Category) = 4;
