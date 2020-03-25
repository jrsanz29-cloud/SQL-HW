CREATE TABLE employees(
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR(14) NOT NULL,
	last_name VARCHAR(16) NOT NULL,
	gender VARCHAR(1) NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE departments(
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)

);


CREATE TABLE dept_manager(
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	PRIMARY KEY (emp_no, dept_no)

);

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles(
	emp_no INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	PRIMARY KEY (emp_no,from_date)
);


copy departments FROM '/tmp/departments.csv' DELIMITER ',' CSV HEADER;
copy dept_emp FROM '/tmp/dept_emp.csv' DELIMITER ',' CSV HEADER;
copy dept_manager FROM '/tmp/dept_manager.csv' DELIMITER ',' CSV HEADER;
copy employees FROM '/tmp/employees.csv' DELIMITER ',' CSV HEADER;
copy salaries FROM '/tmp/salaries.csv' DELIMITER ',' CSV HEADER;
copy titles FROM '/tmp/titles.csv' DELIMITER ',' CSV HEADER;*/


--1.List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT emp.emp_no as "employee number", emp.last_name as "last name", emp.first_name as "first name", emp.gender,
sal.salary
FROM employees as emp
JOIN salaries as sal
ON (emp.emp_no = sal.emp_no)
ORDER BY emp.emp_no;

--2.List employees who were hired in 1986.
SELECT first_name, last_name
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31';

--3.List the manager of each department with the following information:
--department number, department name, the manager's employee number, 
--last name, first name, and start and end employment dates.
SELECT dm.dept_no, dm.emp_no, d.dept_name,
e.last_name, e.first_name, dm.from_date, dm.to_date
FROM dept_manager as dm
INNER JOIN departments AS d
ON (dm.dept_no = d.dept_no)
INNER JOIN employees AS e
ON (dm.emp_no = e.emp_no);

--4.List the department of each employee with the following information: 
--employee number, last name, first name, and department name.
SELECT e.emp_no AS "Employee Number",e.last_name AS "Last Name", 
e.first_name AS "First Name", d.dept_name AS "Department Name"
FROM employees AS e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
ORDER BY e.emp_no;

--5.List all employees whose first name is "Hercules" and last names begin with "B."
SELECT *
FROM employees
WHERE first_name ='Hercules'
AND last_name LIKE 'B%'

--6.List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name ='Sales'
ORDER BY e.emp_no;


--7.List all employees in the Sales and Development departments, including their
--employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN departments AS d
ON(de.dept_no=d.dept_no)
WHERE d.dept_name IN ('Sales','Development')
ORDER BY e.emp_no;



--8.In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, COUNT(last_name)
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name)DESC;



