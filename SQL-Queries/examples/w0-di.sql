USE classicmodels;

-- # ===== AUFGABE 1.1 ===== # --
-- Welcher Kunde hat die höchste Zahlung (summe der Zahlung von einem Kunden) geleistet.
-- Gib den Namen des Kunden, die summe seiner Zahlungen und das Datum aus.

SELECT c.customerName, SUM(p.amount) AS total_summ, MAX(p.paymentDate) AS latest_payment
FROM customers c JOIN payments p ON c.customerNumber = p.customerNumber GROUP BY c.customerNumber
HAVING total_summ = (SELECT MAX(s.summ) FROM (SELECT SUM(amount) AS summ FROM payments GROUP BY customerNumber) AS s);


-- # ===== AUFGABE 1.2 ===== # --
-- Liste für die Bestellung mit der höchsten Bestellnummer alle Einzelposten (Produktname) mit dem Verkaufpreis (Menge*Einzelpreis) auf.

SELECT o.orderNumber, p.productName, (od.priceEach * od.quantityOrdered) AS line_total FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber JOIN products p ON od.productCode = p.productCode
WHERE o.orderNumber = (SELECT MAX(orderNumber) FROM orders);


-- # ===== AUFGABE 1.3 ===== # --
-- Welches war das letzte Verschiffungsdatum?

SELECT MAX(shippedDate) AS latest_shipped_date FROM orders;


-- # ===== AUFGABE 1.4 ===== # --
-- Welches TERRITORY hat die meisten Büros? Gib das Territory und die Anzahl der Büros aus.

SELECT territory, COUNT(*) AS office_count FROM offices GROUP BY territory
HAVING office_count = (SELECT MAX(s.c) FROM (SELECT COUNT(*) AS c FROM offices GROUP BY territory) AS s);



-- # ===== AUFGABE 1.5 ===== # --
-- Gib den Kunden mit dem längsten Kundennamen aus.

SELECT customerName FROM customers WHERE LENGTH(`customerName`) = (
  SELECT MAX(LENGTH(`customerName`)) FROM customers
);



USE terra; -- Just changing the DB

-- # ===== AUFGABE 2.1 ===== # --
-- Welche Sprachen werden in dem Land gesprochen, in dem am meisten Sprachen weltweit gesprochen werden?

SELECT s.Name FROM sprache s JOIN gesprochen g ON s.SNR = g.SNR
WHERE g.LNR IN (SELECT LNR FROM gesprochen GROUP BY LNR HAVING COUNT(*) = (
  SELECT MAX(s.c) FROM (SELECT COUNT(*) AS c FROM gesprochen GROUP BY LNR)
  AS s
));