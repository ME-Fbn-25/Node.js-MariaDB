USE SalesOrders;


-- 1.1 Display products and the latest date each product was ordered.

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


-- 1.2 List customers who ordered bikes.

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


-- 1.3 What products have never been ordered?

SELECT p.ProductNumber, p.ProductName FROM Products p
LEFT JOIN Order_Details od ON p.ProductNumber = od.ProductNumber
WHERE od.ProductNumber IS NULL;

SELECT p.ProductNumber, p.ProductName FROM Products p
WHERE p.ProductNumber NOT IN (SELECT od.ProductNumber FROM Order_Details od);


-- [OPTIONAL]: Find all customers who purchased both a glove and a helmet in the same order! (Use EXISTS)

SELECT c.* FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE EXISTS (
  SELECT 1 FROM Order_Details od JOIN Products p ON od.ProductNumber = p.ProductNumber
  WHERE od.OrderNumber = o.OrderNumber AND p.ProductName RLIKE 'glove'
) AND EXISTS (
  SELECT 1 FROM Order_Details od JOIN Products p ON od.ProductNumber = p.ProductNumber
  WHERE od.OrderNumber = o.OrderNumber AND p.ProductName RLIKE 'helmet'
);





USE Entertainment;


-- 1.4 Show all entertainers and the count of each entertainer's engagements.

SELECT e.EntStageName, COUNT(g.EngagementNumber) AS ECount FROM Entertainers e
LEFT JOIN Engagements g ON e.EntertainerID = g.EntertainerID GROUP BY e.EntertainerID, e.EntStageName;

SELECT e.EntStageName, (
  SELECT COUNT(*) FROM Engagements g
  WHERE g.EntertainerID = e.EntertainerID
) AS ECount FROM Entertainers e;


-- 1.5 List customers who have booked entertainers who play country or country rock.

SELECT DISTINCT c.CustFirstName, c.CustLastName FROM Customers c
JOIN Engagements g ON c.CustomerID = g.CustomerID
JOIN Entertainers e ON g.EntertainerID = e.EntertainerID
JOIN Entertainer_Styles es ON e.EntertainerID = es.EntertainerID
JOIN Musical_Styles ms ON es.StyleID = es.StyleID
WHERE ms.StyleName IN ('Country', 'Country Rock');

SELECT DISTINCT c.CustFirstName, c.CustLastName FROM Customers c
WHERE c.CustomerID IN (SELECT g.CustomerID FROM Engagements g WHERE g.EntertainerID IN (
  SELECT es.EntertainerID FROM Entertainer_Styles es WHERE es.StyleID IN (
    SELECT ms.StyleID FROM Musical_Styles ms WHERE ms.StyleName IN ('Country', 'Country Rock')
  )
));


-- 1.6 Find the entertainers who played engagements for customers Smith or Hallmark.

SELECT DISTINCT e.EntStageName FROM Entertainers e
JOIN Engagements g ON e.EntertainerID = g.EntertainerID
JOIN Customers c ON g.CustomerID = c.CustomerID
WHERE c.CustLastName IN ('Smith', 'Hallmark');

SELECT DISTINCT e.EntStageName FROM Entertainers e
WHERE e.EntertainerID IN (SELECT g.EntertainerID FROM Engagements g
  WHERE g.CustomerID IN (SELECT c.CustomerID FROM Customers c
    WHERE c.CustLastName IN ('Smith', 'Hallmark')
  )
);


-- 1.7 Display agents who haven't booked an entertainer.

SELECT a.AgtFirstName, a.AgtLastName FROM Agents a
LEFT JOIN Engagements g ON a.AgentID = g.AgentID
WHERE g.EngagementNumber IS NULL;

SELECT a.AgtFirstName, a.AgtLastName FROM Agents a
WHERE a.AgentID NOT IN (SELECT g.AgentID FROM Engagements g WHERE g.AgentID IS NOT NULL);