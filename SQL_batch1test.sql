use AdventureWorks2022;

---A)find all 20 employee who joined very early in the company
select top 20 p.BusinessEntityID,p.FirstName,p.LastName,HireDate 
from HumanResources.Employee as e,
Person.Person as p
where p.BusinessEntityID = e.BusinessEntityID
order by HireDate ;

---B)Find all employee name,job title,
--card details whose credit card expired in the month 9 and year as 20094
select * from HumanResources.Employee;
select * from Sales.CreditCard;

select p.FirstName,e.JobTitle,cc.CardNumber,cc.CardType
from Person.Person as p,
HumanResources.Employee as e,
Sales.CreditCard as cc,
Sales.PersonCreditCard as pcc
where p.BusinessEntityID = e.BusinessEntityID
and pcc.CreditCardID = cc.CreditCardID
and (cc.ExpMonth = 9 and cc.ExpYear=2009);
-- no records available for employee name,job title,card details whose credit card expired in the month 9 and year as 2009

---C) find the store address and contact number based on tables store 
--and business entity id check if any other table is required
select * from Sales.Store;
select * from Person.PersonPhone;
select * from Person.Address;
select * from Person.BusinessEntityAddress;

select pa.AddressLine1,pp.PhoneNumber
from Sales.Store as ss,
Person.Address as pa,
Person.BusinessEntityAddress as bed,
Person.PersonPhone as pp
where ss.BusinessEntityID = pp.BusinessEntityID
and pa.AddressID = bed.AddressID;


---D)check if any employee from job candidate table is having any payment revisions
select * from HumanResources.JobCandidate;
select * from HumanResources.EmployeePayHistory;

select * 
from HumanResources.EmployeePayHistory
where BusinessEntityID in (select ep.BusinessEntityID
from HumanResources.JobCandidate as jc,
HumanResources.EmployeePayHistory ep
where jc.BusinessEntityID = ep.BusinessEntityID);


---E)check color wise standard cost
select * from Production.Product;

select distinct color,
sum(standardcost) over (partition by color) as standardcost
from Production.Product 

---F)Which product is purchased more?(purchase order details)
select * from Purchasing.PurchaseOrderDetail;
select * from Production.Product;

select distinct top 1 pod.ProductID,pp.Name,
sum(pod.OrderQty) over (partition by pod.ProductID) as total_orderqty
from Purchasing.PurchaseOrderDetail as pod,
Production.Product as pp
where pp.ProductID = pod.ProductID
order by total_orderqty desc;


---G)Find the total values for the line total product having maximum order
select * from Purchasing.PurchaseOrderDetail;
select * from Production.Product

select distinct pp.ProductID,pp.Name,
sum(pod.Linetotal) over (partition by pod.Productid) as total_linetotal,
sum(pod.OrderQty) over (partition by pod.Productid) as total_orderQty
from Purchasing.PurchaseOrderDetail as pod,
Production.Product as pp
where pp.ProductID = pod.ProductID
order by total_orderQty desc;

---H) which product is the oldest product as on the date (product sell start date)
select ProductID,Name,SellStartDate 
from Production.Product
order by SellStartDate;

---I) find all the employees whose salary is more than the average salary
select * from HumanResources.EmployeePayHistory

select distinct e.BusinessEntityID, p.FirstName, p.LastName, 
(select avg(rate) from HumanResources.EmployeePayHistory) avg_salary 
from HumanResources.Employee e,
Person.Person p
where e.BusinessEntityID = p.BusinessEntityID
and e.BusinessEntityID in 
	(select BusinessEntityID 
	from HumanResources.EmployeePayHistory 
	where rate >(select avg(rate) 
				from HumanResources.EmployeePayHistory))

---J)Display country region code,group average sales quota based on territory id
select * from Sales.SalesTerritory;
select * from Sales.SalesPerson;


select distinct st.TerritoryID,st.CountryRegionCode,st.[Group],
avg(sp.salesquota) over (partition by sp.territoryid) as avg_salequota
from Sales.SalesTerritory as st,
Sales.SalesPerson as sp
where st.TerritoryID = sp.TerritoryID;


---K)Find the average age of male and female
select * from HumanResources.Employee

select gender,
avg(DATEDIFF(year,BirthDate,HireDate)) as avg_age
from HumanResources.Employee
group by Gender;

---L)which product is purchased more?(purchase order details)
select * from Purchasing.PurchaseOrderDetail

select ProductID,sum(orderqty) as total_ordqty
from Purchasing.PurchaseOrderDetail
group by ProductID
order by total_ordqty desc;

---M) check for sales person details which are working in stores(find the sales person id)
select * from sales.SalesPerson
select distinct Name from Sales.Store

select distinct s.[Name],p.FirstName
from sales.Store as s,
Sales.SalesPerson as sp,
Person.Person as p
where s.SalesPersonID=sp.BusinessEntityID
and p.BusinessEntityID = sp.BusinessEntityID



---N)display the product name and product price and count of product cost revised (productcosthistory)
select * from Production.ProductCostHistory
select * from Production.Product;
select * from Production.ProductListPriceHistory;
select * from Production.TransactionHistory;

select pp.Name,th.ActualCost,count(pch.ProductID) as prod_cnt
from Production.Product as pp,
Production.ProductCostHistory as pch,
Production.TransactionHistory as th
where pp.ProductID = pch.ProductID
and th.ProductID = pp.ProductID
group by pp.name,th.ActualCost
having count(pch.ProductID) > 1

---O)check the department having more salary revision
select * from HumanResources.EmployeePayHistory;
select * from HumanResources.EmployeeDepartmentHistory;
select * from HumanResources.Department;

select  edh.DepartmentID,d.Name,
count(eph.payfrequency) as payfreq
from HumanResources.EmployeePayHistory as eph,
HumanResources.EmployeeDepartmentHistory as edh,
HumanResources.Department as d
where eph.BusinessEntityID = edh.BusinessEntityID
and edh.DepartmentID = d.DepartmentID
group by edh.DepartmentID,d.Name
having count(eph.payfrequency)>1

