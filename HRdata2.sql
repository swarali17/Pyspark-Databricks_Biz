use AdventureWorks2022;

select * from Person.Person;

select BusinessEntityID,NationalIDNumber,JobTitle,
(select firstname from Person.Person as p
where p.BusinessEntityID = e.BusinessEntityID) as FirstName
from HumanResources.Employee as e;


--- add personal details of employee middle name,last name
select BusinessEntityID,NationalIDNumber,JobTitle,
	(select firstname from Person.Person as p 
	where p.BusinessEntityID = e.BusinessEntityID) as Firstname,
	(select MiddleName from Person.Person as p 
	where p.BusinessEntityID = e.BusinessEntityID) as MiddleName,
	(select LastName from Person.Person as p 
	where p.BusinessEntityID = e.BusinessEntityID) as Lastname
from HumanResources.Employee as e;


---concat
select BusinessEntityID,NationalIDNumber,JobTitle,
(select concat(firstname,' ',MiddleName,' ',LastName) from Person.Person as p
where p.BusinessEntityID = e.BusinessEntityID) as FullName
from HumanResources.Employee as e;

---concat_ws (ws : word seperator)
select BusinessEntityID,NationalIDNumber,JobTitle,
(select concat_ws(' ',firstname,MiddleName,LastName) from Person.Person as p
where p.BusinessEntityID = e.BusinessEntityID) as FullName
from HumanResources.Employee as e;


---display national_id , first_name , last_name and department name,department group
select * from Person.Person;
select * from HumanResources.Department;
select * from HumanResources.Employee;
select * from HumanResources.EmployeeDepartmentHistory;

select 
(select concat(firstname,' ',lastname) from Person.Person as p
where p.BusinessEntityID = ed.BusinessEntityID) as personal_details,
(select  NationalIDNumber from HumanResources.Employee as e
where e.BusinessEntityID = ed.BusinessEntityID) Emp_details,
(select concat_ws(' ',name,groupname) from HumanResources.Department as d
where d.DepartmentID = ed.DepartmentID) dept_details
from HumanResources.EmployeeDepartmentHistory ed;


---display national_id and department name,department group
select
(select NationalIDNumber from HumanResources.Employee as e
where e.BusinessEntityID = ed.BusinessEntityID ) as Natid,
(select concat(name,' ',groupname) from HumanResources.Department as d
where d.DepartmentID = ed.DepartmentID) as dept
from HumanResources.EmployeeDepartmentHistory as ed

--- display firstname,lastname,department ,shift time

select 
(select concat(firstname,' ',lastname) from Person.Person as p
where p.BusinessEntityID=ed.BusinessEntityID) as fullname,
(select name from HumanResources.Department as d
where d.DepartmentID = ed.DepartmentID) as deptname,
(select CONCAT(startdate,' ',EndDate) from HumanResources.Shift as s
where s.ShiftID = ed.ShiftID) as shifttime
from HumanResources.EmployeeDepartmentHistory as ed


--- display product name and product review based on production schema

select
(select name from Production.Product as p
where p.ProductID = pr.ProductID) as prod_name,
ProductReviewID
from Production.ProductReview as pr;



select * from HumanResources.Employee;
select * from Person.Person;
select * from Sales.CreditCard;
select * from Sales.PersonCreditCard;

--- find the employee's name,jobtitle,card details whose credit card expired in month 11 and year 2008
select
(select FirstName from Person.Person as p
where p.BusinessEntityID = pcc.BusinessEntityID) as fname,
(select JobTitle from HumanResources.Employee as e
where e.BusinessEntityID = pcc.BusinessEntityID) jobtitle,
(select concat_ws(' ',CardType,CardNumber) from Sales.CreditCard as cc
where cc.CreditCardID = pcc.CreditCardID) cardnum
FROM Sales.PersonCreditCard as pcc



--- display records from currency rate from USD to AUD
select * from Sales.CurrencyRate
where fromcurrencycode= 'USD' and tocurrencycode = 'AUD';



---
select * from Sales.SalesTerritory;
select * from Sales.SalesPerson;
--- display EMP name,territory name,group,saleslastyear salesquota,bonus
select 
	(select firstname from Person.Person as p
	where p.BusinessEntityID = sp.BusinessEntityID) as fname,
	(select [Name] from Sales.SalesTerritory as st
	where st.TerritoryID = sp.TerritoryID) as territoy_name,
	(select [Group] from Sales.SalesTerritory as st
	where st.TerritoryID = sp.TerritoryID) as territoy_grp,
	(select SalesLastYear from Sales.SalesTerritory as st
	where st.TerritoryID = sp.TerritoryID) as sales_lastyr,
	salesquota as quota,Bonus as bonus
from Sales.SalesPerson as sp;

---display EMP name,territory name,group, Saleslastyear SalesQuota,bonus from germany and united kingdom
select 
	(select firstname from Person.Person as p
	where p.BusinessEntityID = sp.BusinessEntityID) as fname,
	(select [Name] from Sales.SalesTerritory as st
	where st.TerritoryID = sp.TerritoryID) as territoy_name,
	(select [Group] from Sales.SalesTerritory as st
	where st.TerritoryID = sp.TerritoryID) as territoy_grp,
	(select SalesLastYear from Sales.SalesTerritory as st
	where st.TerritoryID = sp.TerritoryID) as sales_lastyr,
	salesquota as quota,Bonus as bonus
from Sales.SalesPerson as sp
where TerritoryID in
(select TerritoryID from Sales.SalesTerritory as st where Name = 'Germany' or Name = 'United Kingdom')

---find all employees who worked in all North america territory
select 
(select firstname from Person.Person as p
where p.BusinessEntityID = sp.BusinessEntityID) as name,
(select [Group] from Sales.SalesTerritory as st
where st.TerritoryID = sp.TerritoryID) as name
from Sales.SalesPerson as sp
where TerritoryID in
(select TerritoryID from Sales.SalesTerritory as st where [Group]='North America');


---find the product details in cart
select * from Production.Product;
select * from Sales.ShoppingCartItem;

select 
(select [name] from Production.Product as p
where p.ProductID = sc.ProductID) as prod_name,
(select ProductNumber from Production.Product as p
where p.ProductID = sc.ProductID) as prod_num
from Sales.ShoppingCartItem as sc

---find the product with special offer
select * from Sales.SpecialOffer;
select * from Sales.SpecialOfferProduct;

select sp.*,
(select Description from Sales.SpecialOffer as so
where so.SpecialOfferID = sp.SpecialOfferID) as description
from Sales.SpecialOfferProduct as sp;


