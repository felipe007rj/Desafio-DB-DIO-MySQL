use company_constraints;

-- Dnumber: Departament
-- Aplicando Alias dentro do SQL

desc departament;
desc dept_locations;

select * from departament;
select * from dept_locations;

-- Retira a ambiguidade através do alias ou AS Statemant
select Dname, l.Dlocation as Departament_name 
		from departament as d, dept_locations as l
		where d.Dnumber = l.Dnumber;
        
select concat(Fname, ' ', Lname) as Employee from employee;

-- Verifica todas as istâncias que iniciam com to
regexp '^to';

-- Recolhendo valor do INSS
SELECT Fname, Lname, Salary, Salary*0.011 FROM employee;

SELECT Fname, Lname, Salary, Salary*0.011 as INSS FROM employee;

SELECT Fname, Lname, Salary, ROUND(Salary*0.011,2) as INSS FROM employee;

-- Definir aumento de salario para os gerentes que trabalham no projeto associado ao Produtox
DESC project;
DESC works_on;
SELECT * 
	FROM employee e, works_on AS w, project AS p
	WHERE (e.Ssn = w.Essn AND w.Pno = p.Pnumber);
    
SELECT CONCAT(FName, ' ' , Lname) AS Complete_name, Salary, Salary*1.1 AS increased_salary 
	FROM employee e, works_on AS w, project AS p
	WHERE (e.Ssn = w.Essn AND w.Pno = p.Pnumber AND p.Pname = 'Productx');
    
SELECT CONCAT(FName, ' ' , Lname) AS Complete_name, Salary, ROUND(1.1*Salary,2) AS increased_salary 
	FROM employee e, works_on AS w, project AS p
	WHERE (e.Ssn = w.Essn AND w.Pno = p.Pnumber AND p.Pname = 'Productx');

-- Recuperando informacoes dos departamentos presentes em stafford
SELECT Dname AS Departament_Name, Mgr_ssn AS Manager FROM departament d, dept_locations l, employee e
	WHERE d.Dnumber = l.Dnumber AND Dlocation = 'Stafford';

-- Recuperando todos os gerentes que trabalham em Stafford
SELECT Dname AS Departament_Name, CONCAT(Fname, ' ', Lname) AS Manager FROM departament d, dept_locations l, employee e
	WHERE d.Dnumber = l.Dnumber AND Dlocation = 'Stafford' AND Mgr_ssn = e.Ssn; 

-- Comparando todos os gerentes, departamentos e seus nomes
SELECT Dname AS Departament_Name, Mgr_ssn AS Manager, Dlocation FROM departament d, dept_locations l, employee e
	WHERE d.Dnumber = l.Dnumber AND Mgr_ssn = e.Ssn;
    
SELECT Pnumber, Dnum, Lname, Address, Bdate, p.Plocation FROM departament d, project p , employee e
	WHERE d.Dnumber = p.Dnum AND p.Plocation = 'Stafford' AND Mgr_ssn = e.Ssn;

DESC dept_locations;

SELECT * FROM dept_locations;

-- Like e Between (Comparação % e _) (Tipo de dado numerico)
SELECT * FROM employee;

SELECT CONCAT(Fname, ' ', Lname) AS Complete_Name, Dname, Address AS Departament_Name FROM employee, departament
	WHERE (Dno = Dnumber AND Address LIKE '%Houston%');

SELECT CONCAT(Fname, ' ', Lname) AS Complete_Namem, Address FROM employee
	WHERE (Address LIKE '%Houston%');
    
SELECT CONCAT(Fname, ' ', Lname) AS Complete_Name, Dname, Address AS Departament_Name FROM employee, departament
	WHERE (Dno = Dnumber AND Address LIKE '_Houston_');
    
SELECT Fname, Lname FROM employee WHERE (Salary > 30000 AND Salary < 40000);

SELECT Fname, Lname, Salary FROM employee WHERE (Salary BETWEEN 20000 and 40000);

-- Operadores Lógicos

SELECT Bdate, Address FROM employee WHERE Fname = 'John' AND Minit = 'B' AND Lname= 'SMITH';

SELECT * FROM departament;

SELECT * FROM departament WHERE Dname = 'Research' OR Dname = 'Administration';

SELECT Fname, Lname FROM employee, departament WHERE Dname = 'Research' AND Dnumber = Dno;

SELECT CONCAT(Fname, ' ', Lname) AS Complete_Name FROM employee, departament WHERE Dname = 'Research' AND Dnumber = Dno;

-- UNION, EXCEPT E INTERSECT

CREATE DATABASE teste;
USE teste;

CREATE TABLE R(
	A CHAR(2)
);

CREATE TABLE S(
	A CHAR (2)
);

INSERT INTO R(A) VALUES ('a1'), ('a2'), ('a2'), ('a3');
INSERT INTO S(A) VALUES ('a1'), ('a1'), ('a2'), ('a3'),('a4'), ('a5');

SELECT * FROM R;
SELECT * FROM S;

-- EXCEPT -> NOT IN
SELECT * FROM S WHERE A NOT IN (SELECT A FROM R);

-- UNION
(SELECT DISTINCT R.A FROM R)
	UNION
    (SELECT DISTINCT S.A FROM S);
    
(SELECT R.A FROM R)
	UNION
    (SELECT S.A FROM S);
    
-- INTERSECT
SELECT DISTINCT R.A FROM R WHERE R.A IN (SELECT S.A FROM S);

-- SUBQUERIES
SELECT DISTINCT Pnumber FROM project
	WHERE Pnumber IN
		(
        SELECT Pnumber
        FROM project, departament, employee
        WHERE Mgr_ssn = Ssn AND Lname = 'Smith' AND Dnum = Dnumber)
		OR
        (
        SELECT DISTINCT Pno
			FROM works_on, employee
            WHERE (Essn = Ssn AND Lname = 'Smith'
		)
		);
        
SELECT DISTINCT * FROM works_on
	WHERE (Pno, Hours) IN 	(SELECT Pno, Hours
							FROM works_on
                            WHERE Essn = 123456789);
                            
-- Clausulas com Exists e Unique
-- Quais employees possuem dependentes
SELECT e.Fname, e.Lname FROM employee as e
	WHERE EXISTS 	(SELECT * FROM dependent AS d
					WHERE e.Ssn = d.Essn AND e.Fname = d.Essn AND Relationship = 'Son');
                    
SELECT e.Fname, e.Lname FROM employee as e
	WHERE NOT EXISTS (SELECT * FROM dependent AS d
					WHERE e.Ssn = d.Essn AND e.Fname = d.Essn AND Relationship = 'Son');

SELECT e.Fname, e.Lname FROM employee as e
	WHERE EXISTS 	(SELECT * FROM dependent AS d
					WHERE e.Ssn = d.Essn AND e.Fname = d.Essn)
                    AND
                    (SELECT * FROM departament
                    WHERE Ssn = Mgr_ssn);

-- Resolve a query acima
SELECT e.Fname, e.Lname FROM employee AS e, departament d
	WHERE (e.Ssn = d.Mgr_ssn) AND EXISTS (SELECT * FROM dependent AS d WHERE e.Ssn = d.Essn);
    
SELECT Fname, Lname FROM employee
	WHERE (SELECT COUNT(*) FROM dependent WHERE Ssn = Essn) >= 2;

-- Utilizando conjuntos explicitos para comparação    
SELECT DISTINCT Essn FROM works_on WHERE Pno IN (1, 2, 3);
