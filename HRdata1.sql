USE AdventureWorks2022;

SELECT * FROM HumanResources.Employee; 

SELECT *
FROM HumanResources.Employee WHERE MaritalStatus='M';

--- find all employees under the job title marketing
 SELECT * FROM HumanResources.Employee
 WHERE JobTitle LIKE '%Marketing%';

 SELECT COUNT(*) FROM HumanResources.Employee
 WHERE Gender = 'F';

 SELECT * FROM HumanResources.Employee
 WHERE Gender LIKE 'F';

 SELECT COUNT('MaritalStatus') FROM HumanResources.Employee;

 --- find the employees having salariedflag as 1
 SELECT * FROM HumanResources.Employee
 WHERE SalariedFlag = 1;

 --- find all employees having vacation hr more than 70
 SELECT * FROM HumanResources.Employee
 WHERE VacationHours > 70;

 --- vacation hr more than 70  but less than 90
 SELECT * FROM HumanResources.Employee
 WHERE VacationHours >70 and VacationHours < 90;

--- find all jobs having title as designer
SELECT * FROM HumanResources.Employee
WHERE JobTitle LIKE '%Designer%';

--- find the total employees worked as Technician
SELECT COUNT(*) FROM HumanResources.Employee
WHERE JobTitle LIKE '%Technician%';

---display data having NationalIDNumber ,job title, marital status,gender for all under marketing job
SELECT NationalIDNumber,JobTitle,MaritalStatus,Gender FROM HumanResources.Employee
WHERE JobTitle LIKE '%Marketing%';

SELECT DISTINCT JobTitle FROM HumanResources.Employee;

--find unique marital status
SELECT DISTINCT MaritalStatus
FROM HumanResources.Employee;

---find max vacation hrs
SELECT MAX(VacationHours)
FROM HumanResources.Employee;

--- find the less sick leaves
SELECT MIN(SickLeaveHours) AS less_sick_leaves
FROM HumanResources.Employee;


--- find all employee from  production department
SELECT * FROM HumanResources.Department;
SELECT * FROM HumanResources.Department 
where Name = 'Production';



