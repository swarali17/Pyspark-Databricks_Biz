use AdventureWorks2022;

--- find the average currency rate conversion from USD to Algerian Dinar and Australian Doller  
select * from Sales.Currency;
select * from Sales.CurrencyRate;

select cr.FromCurrencyCode,cr.ToCurrencyCode,cr.AverageRate 
from Sales.CurrencyRate as cr,
Sales.Currency as sc
where cr.ToCurrencyCode = sc.CurrencyCode
and cr.FromCurrencyCode='USD'
and cr.ToCurrencyCode in ('DZD','AUD')
---group by cr.FromCurrencyCode,cr.ToCurrencyCode,cr.AverageRate

---Find the products having offer on it and display product name , 
---safety Stock Level, Listprice,  and product model id, type of discount, 
---percentage of discount,  offer start date and offer end date 
select * from Sales.SpecialOffer;
select * from Sales.SpecialOfferProduct;
select * from Production.Product;

select pp.Name,pp.SafetyStockLevel,pp.ListPrice,pp.ProductModelID,
so.Type,so.DiscountPct,so.StartDate,so.EndDate
from Sales.SpecialOffer as so,
Sales.SpecialOfferProduct as sop,
Production.Product as pp
where sop.ProductID = pp.ProductID
and sop.SpecialOfferID = so.SpecialOfferID

---create  view to display Product name and Product review 

---4)find out the vendor for product paint, Adjustable Race and blade
select* from Purchasing.ProductVendor;
select * from Purchasing.Vendor;
select * from production.product;

select pp.Name,pv.Name as vendorname  
---count(*) as quantity ---,pp.ProductID
from Purchasing.Vendor as pv,
production.product as pp,
Purchasing.ProductVendor as ppv
where (pv.BusinessEntityID = ppv.BusinessEntityID
and ppv.ProductID = pp.ProductID)
and (pp.Name like '%paint%' 
or pp.Name like '%Adjustable Race%'
or pp.name like '%Blade%')
group by pp.Name,pv.Name ;

--- 5) find product details shipped through ZY - EXPRESS 
select * from Purchasing.ShipMethod;
select * from Purchasing.PurchaseOrderHeader;
select * from Production.Product;
select * from Purchasing.PurchaseOrderDetail;

select distinct pr.ProductID ,pr.Name,sm.Name
from purchasing.ShipMethod as sm,
Purchasing.PurchaseOrderHeader  as poh,
Production.Product as pr,
Purchasing.PurchaseOrderDetail as pod
where sm.ShipMethodID=poh.ShipMethodID
and pr.ProductID = pod.ProductID
and poh.PurchaseOrderID = pod.PurchaseOrderID
and sm.Name like '%ZY%';

--- 6) find the tax amt for products where order date and ship date are on the same day 
select * from Sales.SalesOrderHeader;
select * from Purchasing.PurchaseOrderHeader;
select * from Production.Product;

select sod.TaxAmt,poh.TaxAmt,sod.OrderDate,poh.ShipDate
from Sales.SalesOrderHeader as sod,
Purchasing.PurchaseOrderHeader as poh
where sod.ShipMethodID = poh.ShipMethodID
and sod.OrderDate = poh.ShipDate;

---7)find the average days required to ship the product based on shipment type. 
select * from Sales.SalesOrderHeader;
select * from Purchasing.PurchaseOrderHeader;

select sm.Name as shipname,
AVG(datediff(day,po.OrderDate,po.ShipDate))
from Purchasing.PurchaseOrderHeader as po,
Purchasing.ShipMethod as sm
where po.ShipMethodID = sm.ShipMethodID
and po.ShipDate is not null
group by sm.name;

---8)find the name of employees working in day shift 
select * from Person.Person;
select * from HumanResources.EmployeeDepartmentHistory;
SELECT * from HumanResources.Shift;

select p.FirstName,p.LastName,s.ShiftID,s.Name 
from Person.Person as p,
HumanResources.EmployeeDepartmentHistory as ed,
HumanResources.Shift as s
where p.BusinessEntityID = ed.BusinessEntityID
and s.ShiftID = ed.ShiftID
and s.ShiftID = 1

---9)based on product and product cost history find the name , service provider time and average Standardcost   
select * from Production.Product;
select * from Production.ProductCostHistory;

select p.ProductID,p.Name,
avg(DATEDIFF(day,pc.StartDate,pc.EndDate)),
avg(pc.standardcost) as stdcost
from Production.Product as p,
Production.ProductCostHistory as pc
where p.ProductID = pc.ProductID
group by p.ProductID,p.Name;

---10) find products with average cost more than 500
select * from Production.Product;
select * from Production.ProductCostHistory;

select p.ProductID,p.Name,
avg(p.standardcost) as stdcost
from Production.Product as p
group by p.ProductID,p.Name
having avg(p.standardcost) > 500;

---11)find the employee who worked in multiple territory
select * from Person.Person;
select * from Sales.SalesTerritory;
select * from Sales.SalesTerritoryHistory;

select p.FirstName,count(*) as cnt
from Person.Person as p,
Sales.SalesTerritory as st,
Sales.SalesTerritoryHistory as sth
where p.BusinessEntityID = sth.BusinessEntityID
and st.TerritoryID = sth.TerritoryID
group by p.FirstName
having count(*) > 1

---12)find out the Product model name,  product description for culture as Arabic 
select * from Production.ProductModel;
select * from Production.ProductModelProductDescriptionCulture;
select * from Production.ProductDescription;

select pm.Name ,pmd.ProductDescriptionID,pmd.CultureID,pd.Description
from Production.ProductModel as pm,
Production.ProductModelProductDescriptionCulture as pmd,
Production.ProductDescription as pd
where pm.ProductModelID = pmd.ProductModelID
and pd.ProductDescriptionID = pmd.ProductDescriptionID
and pmd.CultureID like '%ar%'

--- 13)display EMP name, territory name, saleslastyear salesquota and bonus 
select * from person.Person;
select * from Sales.SalesTerritory
select * from Sales.SalesTerritoryHistory
select * from Sales.SalesPerson


--- 20)Find the employee whose payment might be revised  (Hint : Employee payment history) 
select * from HumanResources.Employee
select * from HumanResources.EmployeePayHistory;
select * from Sales.SalesReason