Answer following questions
1.	What is View? What are the benefits of using views?

	View is a virtual table, it can provide security to the code, less complexity and also use small storage.

2.	Can data be modified through views?

	Yes,  the base data will be modified when we make changes on the Views, so it’s the disadvantage of using views

3.	What is stored procedure and what are the benefits of using it?

	Its a type of code that can be stored for later use and can be used many times.

4.	What is the difference between view and stored procedure?

	View doesn’t accept parameter and SP can, so view has the possibilities to get sql injection.
	View can only contain one select query whereas as SP can contain several statements.

5.	What is the difference between stored procedure and functions?

	SP is used for DML and functions is used for calculation.
	SP is called by EXEC and functions must be used inside select from statement
	SP can either have input or output, and functions must have input and output.
	SP can called functions but functions cant called SP

6.	Can stored procedure return multiple result sets?

	Yes

7.	Can stored procedure be executed as part of SELECT Statement? Why?

	No since SP might not have a return value

8.	What is Trigger? What types of Triggers are there?

	Trigger is a sp that will be initiated when a spectific behavior happened in the database.
	DDL, DML and LOGON trigger

9.	What is the difference between Trigger and Stored Procedure?

	Trigger is excecuted automatically and SP is excecuted by EXEC syntax manually

Write queries for following scenarios
Use Northwind database. All questions are based on assumptions described by the Database Diagram sent to you yesterday. When inserting, make up info if necessary. Write query for each step. Do not use IDE. BE CAREFUL WHEN DELETING DATA OR DROPPING TABLE.
1.	Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.

	CREATE VIEW view_product_order_Cheng AS 
	select ProductName, sum(Quantity) AS [total ordered quantity]
	from [order details] od
	join products p on od.productID = p.productID
	group by productName

2.	Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.

	CREATE PROC sp_product_order_quantity_Cheng 
	@productID int
	@totalQ int out
	AS
	Select @totalQ = sum(Quantity) AS total
	from [order details] od
	join products p on od.productID = p.productID
	where productID = @productID
	group by productID

3.	Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.

	CREATE PROC sp_product_order_city_Cheng
	@productName nvarchar(20)
	AS 
	BEGIN
	select TOP 5 ShipCity, Sum(Quantity) [total quantity]
	from [Order Details] od join Products p ON p.ProductID = od.ProductID JOIN Orders o ON o.OrderID = od.OrderID
	where productName = @productName
	group by productName, ShipCity
	order by Sum(Quantity) DESC
	END

4.	Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. 
	People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. 
	Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. 
	If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.

	Create table city_Cheng(
	id int,
	City nvarchar(100)
	)

	Create table people_Cheng(
	id int,
	Name nvarchar(100),
	City nvarchar(100)
	)

5.	Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. 
	(Make a screen shot) drop the table. Employee table should not be affected.

	alter PROC sp_birthday_employees_cheng
	AS
	BEGIN
	select * INTO birthday_employees_cheng
	from Employees
	Where datepart(mm,BirthDate) = 2
	END
	EXEC sp_birthday_employees_cheng
	select * from birthday_employees_cheng

	Drop table birthday_employees_cheng
	

6.	How do you make sure two tables have the same data?
	
	Use except, and if theres no result then the two table have same data

7.
First Name	Last Name	Middle Name
John	Green	
Mike	White	M

Output should be
Full Name
John Green
Mike White M.
Note: There is a dot after M when you output.

select [First Name] + ' ' + [Last Name] AS [FullName]
from table
where [Middle Name] is NULL
Union
select [First Name] + ' ' + [Last Name] + [Middle Name] + '.' AS [FullName]
from table
where [Middle Name] is not NULL

8.
Student	Marks	Sex
Ci	70	F
Bob	80	M
Li	90	F
Mi	95	M
Find the top marks of Female students.
If there are to students have the max score, only output one.

select TOP 1 Marks 
from table
where Sex = 'F'
order by Marks Desc

9.
Student	Marks	Sex
Li	90	F
Ci	70	F
Mi	95	M
Bob	80	M
How do you out put this?

Select Student, Marks, Sex
From table
Order by Sex, Marks DESC
