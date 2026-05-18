USE SalesOrders;


-- 1. Display products and the latest date each product was ordered.

SELECT p.ProductName, MAX(o.OrderDate) AS LatestOrderDate FROM Products p
JOIN Order_Details od ON p.ProductNumber = od.ProductNumber
JOIN Orders o ON od.OrderNumber = o.OrderNumber
GROUP BY p.ProductName;

SELECT p.ProductName, (
  SELECT MAX(o.OrderDate) FROM Orders o
  JOIN Order_Details od ON o.OrderNumber = od.OrderNumber
  WHERE od.ProductNumber = p.ProductNumber IS NOT NULL
) AS LatestOrderDate FROM Products p
WHERE EXISTS (SELECT 1 FROM Order_Details od WHERE od.ProductNumber = p.ProductNumber);


-- 2. List customers who ordered bikes.

SELECT DISTINCT c.CustomerID, c.CustFirstName, c.CustLastName FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Order_Details od ON o.OrderNumber = od.OrderNumber
JOIN Products p ON od.ProductNumber = p.ProductNumber
WHERE p.ProductName LIKE '%Bike%';

SELECT c.CustomerID, c.CustFirstName, c.CustLastName FROM Customers c
WHERE c.CustomerID IN (
  SELECT o.CustomerID FROM Orders o
  JOIN Order_Details od ON o.OrderNumber = od.OrderNumber
  JOIN Products p ON od.ProductNumber = p.ProductNumber
  WHERE p.ProductName LIKE '%Bike%'
);

SELECT c.* FROM Customers c WHERE EXISTS (
  SELECT 1 FROM Orders o
  JOIN Order_Details od ON o.OrderNumber = od.OrderNumber
  JOIN Products p ON od.ProductNumber = p.ProductNumber
  WHERE p.ProductName RLIKE 'bike'
  AND o.CustomerID = c.CustomerID
);


-- 3. What products have never been ordered?

SELECT p.ProductNumber, p.ProductName FROM Products p
LEFT JOIN Order_Details od ON p.ProductNumber = od.ProductNumber
WHERE od.ProductNumber IS NULL;

SELECT p.ProductNumber, p.ProductName FROM Products p
WHERE p.ProductNumber NOT IN (SELECT od.ProductNumber FROM Order_Details od);