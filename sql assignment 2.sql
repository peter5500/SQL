Answer following questions
1.	What is a result set?

	Result set is the result that we get after running a query

2.	What is the difference between Union and Union All?

	Union wil remove duplicate but union all will not

3.	What are the other Set Operators SQL Server has?

	Union, Intesect and Except

4.	What is the difference between Union and Join?

	Union is used to combined row and join is used to combine table(columns)

5.	What is the difference between INNER JOIN and FULL JOIN?

	Inner join only match the data that has matching data in each table, and full join will combine all the columns and set null value to no matching columns

6.	What is difference between left join and outer join

	Left is a kind of outer join, outer join includes left join, right join and full outer join

7.	What is cross join?

	Cross join will have the result that have all kinds of combination with two table, so it will return the rows equal to the amount of table 1 multiple table 2

8.	What is the difference between WHERE clause and HAVING clause?

	Where is used to filterd the result before aggreated, and having is used after the agggreated result

9.	Can there be multiple group by columns?

	Yes


Write queries for following scenarios
1.	How many products can you find in the Production.Product table?

	Select count(distinct Name)
	from Production.Product

2.	Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.

	--Select *
	--from Production.Product
	--order by ProductSubcategoryID

	Select ProductSubcategoryID, count(Name)
	from Production.Product
	group by ProductSubcategoryID
	having ProductSubcategoryID is not null


3.	How many Products reside in each SubCategory? Write a query to display the results with the following titles.
ProductSubcategoryID CountedProducts
-------------------- ---------------

	Select ProductSubcategoryID, count(Name) AS CountedProducts
	from Production.Product
	group by ProductSubcategoryID
	having ProductSubcategoryID is not null

4.	How many products that do not have a product subcategory. 

	Select count(Name)
	from Production.Product
	group by ProductSubcategoryID
	having ProductSubcategoryID is null

	->209

5.	Write a query to list the sum of products quantity in the Production.ProductInventory table.

	Select ProductID, sum(Quantity)
	from Production.ProductInventory
	group by ProductID

6.	 Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
              ProductID    TheSum
-----------        ----------


	Select ProductID, sum(Quantity) AS cnt
	from Production.ProductInventory
	where locationID = 40
	group by ProductID
	having cnt < 100

7.	Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
Shelf      ProductID    TheSum
---------- -----------        -----------

	Select ProductID, shelf, sum(Quantity) AS cnt
	from Production.ProductInventory
	where locationID = 40
	group by ProductID, shelf
	having sum(Quantity)  < 100

8.	Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.

	select ProductID, avg(Quantity)
	from Production.ProductInventory
	where locationID = 10
	group by ProductID

9.	Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
ProductID   Shelf      TheAvg
----------- ---------- -----------

	select productID, shelf, avg(Quantity) TheAvg
	from Production.ProductInventory
	group by productID, shelf

10.	Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
ProductID   Shelf      TheAvg
----------- ---------- -----------

	select productID, shelf, avg(Quantity) TheAvg
	from Production.ProductInventory
	group by productID, shelf
	having shelf != 'N/A'

11.	List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
Color           	Class 	TheCount   	 AvgPrice
--------------	- ----- 	----------- 	---------------------

	Select Color, Class, count(ListPrice) TheCount, avg(ListPrice) AvgPrice
	from Production.Product
	group by Color, Class
	having class is not NULL AND Color is not null

Joins:
12.	  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following. 

Country                        Province
---------                          ----------------------

	select C.Name Country, S.Name Province
	from person.CountryRegion C
	join person.StateProvince S on C.CountryRegionCode = S.CountryRegionCode

13.	Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.

Country                        Province
---------                          ----------------------

	select C.Name Country, S.Name Province
	from person.CountryRegion C
	join person.StateProvince S on C.CountryRegionCode = S.CountryRegionCode
	where C.Name not in ('Germany','Canada')


Using Northwnd Database: (Use aliases for all the Joins)
14.	List all Products that has been sold at least once in last 25 years.

	select distinct ProductName
	from dbo.orders o
	join dbo.[order Details] od on o.orderID = od.orderID
	join dbo.products op on od.productID = op.productID
	where YEAR(GETDATE()) - Year(OrderDate) < 25

15.	List top 5 locations (Zip Code) where the products sold most.

	select TOP 5 shipPostalCode, sum(Quantity) QTY
	from dbo.orders o
	join dbo.[order Details] od on o.OrderID = od.OrderID
	WHERE o.ShipPostalCode IS NOT NULL
	group by shipPostalCode
	order by QTY DESC


16.	List top 5 locations (Zip Code) where the products sold most in last 25 years.

	select TOP 5 shipPostalCode, sum(Quantity) QTY
	from dbo.orders o
	join dbo.[order Details] od on o.OrderID = od.OrderID
	WHERE o.ShipPostalCode IS NOT NULL AND　YEAR(GETDATE()) - Year(OrderDate) < 25
	group by shipPostalCode
	order by QTY DESC
	

17.	 List all city names and number of customers in that city.     

	select City, count(customerID)
	from customers
	group by City

18.	List city names which have more than 2 customers, and number of customers in that city 

	select City, count(customerID)
	from customers
	group by City
	having count(customerID) > 2

19.	List the names of customers who placed orders after 1/1/98 with order date.

	select ContactName
	from customers c
	JOIN ORDERS o on c.CustomerID = o.CustomerID
	where OrderDate > '1998-01-01'


20.	List the names of all customers with most recent order dates 

	select ContactName, MAX(OrderDate)
	from customers c
	JOIN ORDERS o on c.CustomerID = o.CustomerID
	group by ContactName

21.	Display the names of all customers  along with the  count of products they bought 

	select ContactName, Sum(Quantity) QTY
	from customers c
	join orders o on c.CustomerID = o.CustomerID
	join [order details] od on o.OrderID = od.OrderID
	group by ContactName

22.	Display the customer ids who bought more than 100 Products with count of products.

	select ContactName, Sum(Quantity) QTY
	from customers c
	join orders o on c.CustomerID = o.CustomerID
	join [order details] od on o.OrderID = od.OrderID
	group by ContactName
	having Sum(Quantity) > 100

23.	List all of the possible ways that suppliers can ship their products. Display the results as below
Supplier Company Name   	Shipping Company Name
---------------------------------            ----------------------------------

	select su.CompanyName [Supplier Company Name], sh.CompanyName [Shipper Company Name]
	from suppliers su
	cross join shippers sh


24.	Display the products order each day. Show Order date and Product Name.

	Select OrderDate, ProductName
	from orders o
	join [order Details] od on o.orderID = od.orderID
	join products op on od.productID = op.productID
	group by OrderDate, ProductName
	
25.	Displays pairs of employees who have the same job title.

	select Title, count(Title) 
	from employees
	group by title

26.	Display all the Managers who have more than 2 employees reporting to them.

	select e2.FirstName +' '+ e2.LastName as Manager, count(e1.reportsTo) 
	from employees e1
	join employees e2 on e1.reportsTo = e2.EmployeeID
	where e1.ReportsTo is not NULL
	group by e2.EmployeeID, e2.FirstName, e2.LastName


27.	Display the customers and suppliers by city. The results should have the following columns
City 
Name 
Contact Name,
Type (Customer or Supplier)

	Select City [City Name], contactName [Contact Name], 'Customer' Type
	from customers
	Union
	Select City [City Name], contactName [Contact Name], 'Supplier' Type
	from suppliers 

	

GOOD  LUCK.
