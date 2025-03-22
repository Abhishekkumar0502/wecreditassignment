-- 1. Create a Database
CREATE DATABASE CompanyDatabase;
USE CompanyDatabase;

-- 2. Create Tables
CREATE TABLE Department (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL
);

CREATE TABLE Employee (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    dept_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- 3. Insert Data
INSERT INTO Department (dept_name) VALUES ('IT'), ('HR'), ('Finance'), ('Marketing');
INSERT INTO Employee (emp_name, dept_id, salary, hire_date) VALUES
('Alice', 1, 75000, '2022-01-10'),
('Bob', 2, 60000, '2021-07-15'),
('Charlie', 1, 90000, '2020-06-25'),
('David', 3, 50000, '2023-02-10'),
('Eve', 4, 65000, '2021-05-20');

-- 4. Basic Queries
SELECT * FROM Employee;
SELECT emp_name, salary FROM Employee;
SELECT * FROM Employee WHERE salary > 60000;
SELECT * FROM Employee ORDER BY salary DESC;
SELECT * FROM Employee ORDER BY salary DESC LIMIT 3;
SELECT DISTINCT dept_id FROM Employee;

-- 5. Filtering and Conditions
SELECT * FROM Employee WHERE salary BETWEEN 50000 AND 90000;
SELECT * FROM Employee WHERE dept_id IN (1, 2);
SELECT * FROM Employee WHERE emp_name LIKE 'A%';
SELECT * FROM Employee WHERE salary > 60000 AND dept_id = 1;

-- 6. Aggregation & Grouping
SELECT COUNT(*) AS total_employees FROM Employee;
SELECT dept_id, SUM(salary) AS total_salary FROM Employee GROUP BY dept_id;
SELECT dept_id, AVG(salary) AS avg_salary FROM Employee GROUP BY dept_id;
SELECT MAX(salary) AS highest_salary, MIN(salary) AS lowest_salary FROM Employee;
SELECT dept_id, COUNT(*) AS emp_count FROM Employee GROUP BY dept_id HAVING emp_count > 1;

-- 7. Joins
SELECT Employee.emp_name, Department.dept_name FROM Employee INNER JOIN Department ON Employee.dept_id = Department.dept_id;
SELECT Employee.emp_name, Department.dept_name FROM Employee LEFT JOIN Department ON Employee.dept_id = Department.dept_id;
SELECT Employee.emp_name, Department.dept_name FROM Employee RIGHT JOIN Department ON Employee.dept_id = Department.dept_id;
SELECT Employee.emp_name, Department.dept_name FROM Employee LEFT JOIN Department ON Employee.dept_id = Department.dept_id UNION SELECT Employee.emp_name, Department.dept_name FROM Employee RIGHT JOIN Department ON Employee.dept_id = Department.dept_id;

-- 8. Subqueries
SELECT emp_name, salary FROM Employee WHERE salary > (SELECT AVG(salary) FROM Employee);
SELECT dept_id, avg_salary FROM (SELECT dept_id, AVG(salary) AS avg_salary FROM Employee GROUP BY dept_id) AS subquery;
SELECT emp_name, (SELECT dept_name FROM Department WHERE Department.dept_id = Employee.dept_id) AS department FROM Employee;

-- 9. Advanced Queries
SELECT emp_name, salary, CASE WHEN salary > 80000 THEN 'High Salary' WHEN salary BETWEEN 50000 AND 80000 THEN 'Medium Salary' ELSE 'Low Salary' END AS SalaryCategory FROM Employee;
SELECT emp_name FROM Employee WHERE dept_id = 1 UNION SELECT emp_name FROM Employee WHERE salary > 60000;
DELETE FROM Employee WHERE salary < 30000;
UPDATE Employee SET salary = salary + 5000 WHERE dept_id = 1;
CREATE VIEW HighSalaryEmployees AS SELECT emp_name, salary FROM Employee WHERE salary > 70000;

-- 10. Stored Procedures
DELIMITER //
CREATE PROCEDURE GetHighSalaryEmployees(IN min_salary DECIMAL(10,2))
BEGIN
    SELECT * FROM Employee WHERE salary > min_salary;
END //
DELIMITER ;
CALL GetHighSalaryEmployees(50000);

-- 11. Transactions
START TRANSACTION;
UPDATE Employee SET salary = salary + 5000 WHERE dept_id = 1;
SAVEPOINT before_rollback;
UPDATE Employee SET salary = salary + 10000 WHERE dept_id = 2;
ROLLBACK TO before_rollback;
COMMIT;

-- 12. Indexing
CREATE INDEX idx_department ON Employee(dept_id);
