-- Databricks notebook source
create database if not exists demo_db;

-- COMMAND ----------

create table if not exists demo_db.adv_table(
  month1 string,
  TV float,
  radio float,
  newspaper float,
  sales float
)

-- COMMAND ----------

select * from demo_db.adv_table;

-- COMMAND ----------

insert into demo_db.adv_table
select * from global_temp.adview;

-- COMMAND ----------

select * from demo_db.adv_table;

-- COMMAND ----------

-- MAGIC %python
-- MAGIC
-- MAGIC sup_str = spark.read.format('csv').option('header','true').option('inferSchema','true')\
-- MAGIC     .load('dbfs:/FileStore/SuperstoreCSV.csv')
-- MAGIC
-- MAGIC sup_str.show()

-- COMMAND ----------

-- MAGIC %python
-- MAGIC sup_str.createGlobalTempView('supstore')

-- COMMAND ----------

select * from global_temp.supstore;

-- COMMAND ----------

---find the index of the data 
select * from supstore;

-- COMMAND ----------

-- MAGIC %python
-- MAGIC sup_str.printSchema()

-- COMMAND ----------

create table if not exists demo_db.supstore(
no integer,
order_id string,
OrderDate date,
ShipDate date,
ShipMode string,
CustomerID string,
CustomerName string,
Segment string,
Country string,
City string,
State string,
PostalCode integer,
Region string,
ProductID string,
Category string,
SubCategory string,
ProductName string,
Sales string,
Quantity string,
Discount string,
Profit double
)

-- COMMAND ----------

select * from demo_db.supstore;

-- COMMAND ----------

insert into demo_db.supstore
select * from  global_temp.supstore;

-- COMMAND ----------

select * from demo_db.supstore

-- COMMAND ----------

-- MAGIC %python
-- MAGIC sup_str.dtypes

-- COMMAND ----------

-- MAGIC %python
-- MAGIC sup_str = sup_str.withColumn("Sales",sup_str['Sales'].cast('double'))
-- MAGIC sup_str = sup_str.withColumn("Quantity",sup_str['Quantity'].cast('integer'))
-- MAGIC sup_str = sup_str.withColumn("Discount",sup_str['Discount'].cast('double'))
-- MAGIC

-- COMMAND ----------

-- MAGIC %python
-- MAGIC sup_str.printSchema()

-- COMMAND ----------

drop view global_temp.supstore

-- COMMAND ----------

-- MAGIC %python
-- MAGIC sup_str.createGlobalTempView('supstore')

-- COMMAND ----------

select * from global_temp.supstore;

-- COMMAND ----------

create table if not exists demo_db.supstore(
no integer,
order_id string,
OrderDate date,
ShipDate date,
ShipMode string,
CustomerID string,
CustomerName string,
Segment string,
Country string,
City string,
State string,
PostalCode integer,
Region string,
ProductID string,
Category string,
SubCategory string,
ProductName string,
Sales string,
Quantity string,
Discount string,
Profit double
)

-- COMMAND ----------

select * from demo_db.supstore;

-- COMMAND ----------

insert into demo_db.supstore
select * from  global_temp.supstore;

-- COMMAND ----------

select * from demo_db.supstore

-- COMMAND ----------

select * from demo_db.supstore Limit 40;

-- COMMAND ----------

select * from demo_db.supstore 
order by no desc
Limit 15;


-- COMMAND ----------

--9)take a slice from the dataframe  based on the columns city, state, region, profit columns 
select City,State,Region,Profit from demo_db.supstore;

-- COMMAND ----------

--10)Take a  slice based on data available at 1000 to 1500  position and columns  from 4 to 8 

select ShipMode,CustomerID,CustomerName,Segment,Country from demo_db.supstore
where (no >= 1000) and (no<=1400)

-- COMMAND ----------

select no, Profit,State,Category,SubCategory from demo_db.supstore
where no in (1920,1940,1945,1980)

-- COMMAND ----------

--13)Check the data type of columns 
 describe demo_db.supstore

-- COMMAND ----------

--14)Find out the record for the month of jun-2014
select * from demo_db.supstore
where month(OrderDate)=6 and year(OrderDate)=2014;

-- COMMAND ----------

--15)
select distinct month(orderdate), 
avg(Profit) over (partition by month(OrderDate)) as avgprofit
from demo_db.supstore

-- COMMAND ----------

-- MAGIC %python
-- MAGIC ##16)Create the new data frame for California 
-- MAGIC a16 = '''select * from demo_db.supstore
-- MAGIC where State = "California" '''
-- MAGIC df16 = spark.sql(a16)
-- MAGIC df16.display()

-- COMMAND ----------

--17)Find sum of sales

select sum(Sales) from demo_db.supstore;

-- COMMAND ----------

--18)Find state wise sum of sales. 
select distinct State,
sum(Sales) over (partition by State) as totalsales
from demo_db.supstore

-- COMMAND ----------

--19)Find month wise sum of sales 
select distinct month(OrderDate),
sum(Sales) over (partition by month(OrderDate)) as monthlysales
from demo_db.supstore

-- COMMAND ----------

--20)Find country wise and city wise average profit 
select distinct Country,City,
avg(Profit) over (partition by Country,City) as avgprofit
--avg(Profit) over (partition by City)
from demo_db.supstore

-- COMMAND ----------

--21)Calculate region wise average profit. 
select distinct Region,
avg(Profit) over (partition by Region) as avgprofit
from demo_db.supstore;

-- COMMAND ----------

--22)Find the ship mode which is more profitable.
select shipmode,sum(profit) as profit
from demo_db.supstore
group by shipmode
order by profit desc
limit 1

-- COMMAND ----------

-- MAGIC %python
-- MAGIC ###23)Create a new data frame where loss is recorded 
-- MAGIC a1='''select * 
-- MAGIC from demo_db.supstore
-- MAGIC where Profit < 0'''
-- MAGIC df1 = spark.sql(a1)
-- MAGIC df1.display()

-- COMMAND ----------

--24)Find category wise sub category wise sales 
select distinct Category,SubCategory,
sum(Sales) over (partition by Category,SubCategory) as sales
from demo_db.supstore


-- COMMAND ----------

-- MAGIC %python
-- MAGIC ##25)Create a data frame for record where discount is 0 
-- MAGIC a='''select * 
-- MAGIC from demo_db.supstore
-- MAGIC where Discount like 0'''
-- MAGIC df25 = spark.sql(a)
-- MAGIC df25.display()

-- COMMAND ----------

-- MAGIC %python
-- MAGIC ###26)Create a data frame where order date and ship date both are in JAN-2014 
-- MAGIC b='''select * 
-- MAGIC from demo_db.supstore
-- MAGIC where (month(OrderDate)=1 and year(OrderDate) = 2014) and (month(ShipDate)=1 and year(ShipDate) = 2014)'''
-- MAGIC df1=spark.sql(b)
-- MAGIC df1.display()

-- COMMAND ----------

--27)Find records having profit for consumer segment. 
select Segment,Profit
from demo_db.supstore
where Segment like '%Consumer%'


-- COMMAND ----------

--29)Generate the region wise, state wise average profit and sales and then extract information for east region.
select distinct Region,State,
avg(Profit) over (partition  by Region,State) as avgprofit ,
avg(Sales) over (partition  by Region,State) as avgsales
from demo_db.supstore
where Region like '%East%'

-- COMMAND ----------

--30)Find all record for furniture delivered in Texas 
select * 
from demo_db.supstore
where Category = 'Furniture' and State = 'Texas'

-- COMMAND ----------

select * 
from demo_db.supstore

-- COMMAND ----------


