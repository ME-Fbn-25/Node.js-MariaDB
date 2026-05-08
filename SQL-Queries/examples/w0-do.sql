USE ExampleDB;


-- # ===== AUFGABE 1.1 ===== # --
-- Get details of the latest account created.

SELECT * FROM account WHERE open_date = (SELECT MAX(open_date) FROM account);



-- # ===== AUFGABE 1.2 ===== # --
-- Return all accounts not opened by Woburn Branch's Head Teller.

SELECT a.* FROM account a WHERE a.open_emp_id NOT IN (
  SELECT e.emp_id FROM employee e JOIN branch b ON e.assigned_branch_id = b.branch_id
  WHERE b.name = 'Woburn Branch' AND e.title = 'Head Teller'
);