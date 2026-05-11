```SQL
-- A1: Get details of the latest account created.

SELECT * FROM account WHERE open_date = (SELECT MAX(open_data) FROM account);
```

<br>

```SQL
-- A2: Return all accounts not opened by "Woburn Branch's Head Teller".

SELECT a.* FROM account a WHERE a.open_emp_id NOT IN (
  SELECT e.emp_id FROM employee e JOIN branch b ON e.assigned_branch_id = b.branch_id
  WHERE b.name = 'Woburn Branch' AND e.title = 'Head Teller'
);
```

<br>

```SQL
-- A3: Analysiere die folgende Abfrage! Liefert die Abfrage ein Ergebnis?
-- Begründen Sie ihre Antwort. Wie kann man die Abfrage umbauen?

SELECT account_id, product_cd, cust_id, avail_balance FROM account
WHERE open_emp_id <> (SELECT e.emp_id FROM employee e INNER JOIN branch b ON e.assigned_branch_id = b.branch_id
  WHERE e.title = "Teller" AND b.city = "Woburn");


-- Nein, weil SQ mehr als eine row zurück gibt.
-- Denn Operator 'NOT IN' verwenden damit es geht.

SELECT account_id, product_cd, cust_id, avail_balance FROM account
WHERE open_emp_id NOT IN (SELECT e.emp_id FROM employee e INNER JOIN branch b ON e.assigned_branch_id = b.branch_id
  WHERE e.title = "Teller" AND b.city = "Woburn");
```

<br>

```SQL
-- [OPTIONAL] A4: Retrieve the cities belonging to Headquarters and Quincy Branch.

SELECT b.name, b.city FROM branch b
WHERE b.name IN ('Headquarters', 'Quincy Branch');
```

<br>

```SQL
-- A5: Select all managers (NOTE: Angestellte die Untergebene haben
-- bzw. bei anderen Angestellten als Vorgesetzte eingetragen sind).

SELECT * FROM employee WHERE emp_id IN (SELECT superior_emp_id FROM employee WHERE superior_emp_id IS NOT NULL);
```

<br>

```SQL
-- A6: Select all employees that do not manage other employees.

SELECT * FROM employee WHERE emp_id NOT IN (SELECT superior_emp_id FROM employee WHERE superior_emp_id IS NOT NULL);
```

<br>

```SQL
-- [OPTIONAL] A7: Liefert die folgende Query ein Ergebnis? Warum nicht?
-- Welcher Datensatz verursucht den Fehler? Wie kann man die Abfrage umbauen?

SELECT emp_id, fname, lname, title FROM employee
WHERE emp_id <> ALL (SELECT superior_emp_id FROM employee);


-- Datensatz Michael Smith verursacht den Fehler
-- weil ein vergleich mit NULL, UNKNOWN ergibt.

SELECT emp_id, fname, lname, title FROM employee
WHERE emp_id NOT IN (SELECT superior_emp_id FROM employee IS NOT NULL);
```

<br>

```SQL
-- [OPTIONAL] A8: Find all accounts with balances smaller than all of Frank Trucker's.
-- (NOTE: Retrieve all accounts that have a balance lower than every single account held by Frank Tucker).

SELECT * FROM account
WHERE avail_balance < ALL (
  SELECT a.avail_balance FROM account a
  INNER JOIN individual i ON a.cust_id = i.cust_id
  WHERE i.fname = 'Frank' AND i.lname = 'Tucker'
);
```

<br>

```SQL
-- A9: Find all accounts having a balance greater than any of Frank's accounts.

SELECT * FROM account
WHERE avail_balance > ANY (
  SELECT a.avail_balance FROM account a
  INNER JOIN individual i ON a.cust_id = i.cust_id
  WHERE i.fname = 'Frank' AND i.lname = 'Tucker'
);
```