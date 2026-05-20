USE classicmodels;


WITH RECURSIVE sea AS (
  SELECT e.* FROM employees e WHERE e.employeeNumber = 1166 UNION ALL
  SELECT i_e.* FROM employees i_e, sea AS s WHERE s.employeeNumber = i_e.reportsTo
) SELECT * FROM sea;

WITH RECURSIVE manager AS (
  SELECT * FROM employees WHERE reportsTo IS NULL UNION ALL
  SELECT e.* FROM employees e JOIN manager m ON m.employeeNumber = e.reportsTo
) SELECT * FROM manager;

WITH RECURSIVE manager AS (
  SELECT e.* FROM employees e WHERE e.employeeNumber = 1143 UNION ALL
  SELECT e.* FROM employees e, manager m WHERE e.reportsTo = m.employeeNumber
) SELECT * FROM manager;

WITH RECURSIVE manager AS (
  SELECT e.*, 1 AS LEVEL FROM employees e WHERE e.reportsTo IS NULL UNION ALL
  SELECT e.*, m.LEVEL +1 FROM employees e, manager m WHERE m.employeeNumber = e.reportsTo AND m.LEVEL < 3
) SELECT * FROM manager;



USE terra;


WITH RECURSIVE Donau AS (
  SELECT * FROM fluss WHERE ZielFNR = 'DOU' UNION ALL
  SELECT f.* FROM fluss f JOIN Donau d ON f.ZielFNR = d.FNR
) SELECT * FROM Donau;

WITH RECURSIVE Donau AS (
  SELECT * FROM fluss WHERE Name RLIKE 'drau' UNION ALL
  SELECT f.* FROM fluss f JOIN Donau d ON d.ZielFNR = f.FNR
) SELECT * FROM Donau;



USE classicmodels;


WITH RECURSIVE Superiors AS (
  SELECT *, 0 AS LEVEL FROM employees WHERE `jobTitle` = 'President' UNION ALL
  SELECT e.*, s.LEVEL +1 FROM employees e JOIN subordinates s ON e.`reportsTo` = s.`employeeNumber`
) SELECT * FROM subordinates WHERE LEVEL > 0 ORDER BY LEVEL, `employeeNumber`;

