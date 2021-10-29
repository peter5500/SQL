Assignment Day3 –SQL:  Comprehensive practice
Answer following questions
1.	In SQL Server, assuming you can find the result by using both joins and subqueries, which one would you prefer to use and why?

	JOIN,since join normally have better performance than subqueries

2.	What is CTE and when to use it?

	Since sometimes there will be a lot of content in the subquery, CTE is used to simplify the query and make it more readable.  

3.	What are Table Variables? What is their scope and where are they created in SQL Server?

	Table variable is a type of local variable that help store data temporarily. It’s scope is in the batch it declared and is created in tempdb

4.	What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?

	Delete is DML and Truncate is DDL. Truncate will remove all the records and can’t roll back. Delete only delete one row a time and can be used with where to filter the delete data and can be roll back.
	Truncate have better performance, since it dont have log and Delete has log for every delete record

5.	What is Identity column? How does DELETE and TRUNCATE affect it?

	Identity column is the column that have unique value for each row and will be generated when each row inserted.
	Delete wont affect the identity but truncate will reset all the records

6.	What is difference between “delete from table_name” and “truncate table table_name”?

	Truncate is faster since it didn’t go through all the records before removing it also it can release storage, and since cant be roll back

Write queries for following scenarios
All scenarios are based on Database NORTHWND.
1.	List all cities that have both Employees and Customers.

	SELECT distinct c.city 
	FROM employees e 
	join customers c on e.city = c.city

2.	List all cities that have Customers but no Employee.

a.	Use sub-query

	select distinct city 
	from customers
	where city not in
	(
	Select city 
	from employees
	)

b.	Do not use sub-query

	SELECT distinct c.city 
	FROM employees e 
	right join customers c on e.city = c.city
	where e.city is NULL 

3.	List all products and their total order quantities throughout all orders.

	select ProductName, sum(quantity)
	from orders o
	join [order Details] od on o.orderID = od.orderID
	join products op on od.productID = op.productID
	group by ProductName

4.	List all Customer Cities and total products ordered by that city.

	select city, sum(Quantity) as Total 
	from orders o join [order details] od on o.orderid = od.orderid 
	join customers c on c.customerid = o.CustomerID
	group by city

5.	List all Customer Cities that have at least two customers.
a.	Use union

b.	Use sub-query and no union

	select city 
	from customers 
	group by city having COUNT(*)>=2

6.	List all Customer Cities that have ordered at least two different kinds of products.

	select distinct city from orders o join [order details] od on o.orderid = od.orderid 
	join customers c on c.customerid = o.customerID
	group by city, ProductID
	having COUNT(*) > 1

7.	List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.

	select distinct c.customerID 
	from orders o 
	join [order details] od on o.orderid = od.orderid 
	join customers c on c.customerid = o.customerID
	where City != ShipCity

8.	List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

	select TOP 5 ProductID, AVG(UnitPrice) AveragePrice, 
	(
	select TOP 1 City 
	from customers c 
	join orders o on o.customerID = c.customerID 
	join [Order Details] od2 on od2.OrderID = o.OrderID 
	where od2.ProductID = od1.ProductID 
	group by city order by SUM(Quantity) desc
	) city 
	from [Order Details] od1
	group by ProductID
	order by sum(Quantity) desc
	
9.	List all cities that have never ordered something but we have employees there.
a.	Use sub-query

	select distinct city 
	from employees 
	where city not in 
	(
	select ShipCity 
	from orders 
	where ShipCity is not NULL
	)

b.	Do not use sub-query

	select distinct e.city 
	from orders o
	right join employees e on o.ShipCity = e.city
	where o.ShipCity is NULL

10.	List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
11. How do you remove the duplicates record of a table?

	Group by and count the rows, if the rows count more than 1 means theres duplicate records

12. Sample table to be used for solutions below- Employee (empid integer, mgrid integer, deptid integer, salary money) Dept (deptid integer, deptname varchar(20))
 Find employees who do not manage anybody.

	select emid
	from Employee
	except
	select deptid
	from Detp

13. Find departments that have maximum number of employees. (solution should consider scenario having more than 1 departments that have maximum number of employees). Result should only have - deptname, count of employees sorted by deptname.

	select deptip
	from employee
	group by deptip
	having count(*) = 
	(
	select TOP 1 count(*) 
	from employee 
	group by deptid 
	order by count(*) desc
	)

14. Find top 3 employees (salary based) in every department. Result should have deptname, empid, salary sorted by deptname and then employee with high to low salary.

	select d.deptname, empid, salary COUNT(o.OrderID) AS NumOfOrders, RANK() OVER(PARTITION BY d.deptname ORDER BY COUNT(e.salary) DESC ) AS RNK
	from employee e join dept d ON e.deptid = d.deptid
	where RNK = 3
	group by deptname, empid
