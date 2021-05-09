--1
insert into Region values('5','Middle Earth')
insert into Territories values('41252','Gondor',5)
insert into Employees(LastName,FirstName,Notes) values('King','Aragorn','He is the King of Gondor.')
insert into EmployeeTerritories values(10,'41252')

--2
update Territories 
set TerritoryDescription='Arnor'
where TerritoryDescription='Gondor'

--3
delete from EmployeeTerritories where TerritoryID in (
select TerritoryID from Territories where RegionID in(
select RegionID from region where RegionDescription='Middle Earth'))
delete from Territories where RegionID in (
select RegionID from region where RegionDescription='Middle Earth')
delete from Region where RegionDescription='Middle Earth'

--4
create view [view_product_order_Xudong Ren] as
select p.ProductID,p.ProductName,sum(od.Quantity) as 'total order' from Products as  p left join [Order Details] as od on p.ProductID=od.ProductID
group by p.ProductID,p.ProductName

--5
create procedure [sp_product_order_quantity_Xudong Ren]  @pid int
as 
select [total order] from [view_product_order_Xudong Ren] where ProductID=@pid 
Go

--6
create procedure [sp_product_order_city__Xudong Ren]  @pname nvarchar(40)
as 
select City,[total order] from citycount where ProductName=@pname
order by [total order] desc
Go

--7
create procedure [sp_move_employees_Xudong Ren]
as
declare @c int=(select count(*) from EmployeeTerritories et join Territories t on et.TerritoryID=t.TerritoryID
where t.TerritoryDescription='Troy')
if @c>0
begin
	if not exists (select * from Territories where TerritoryDescription = 'Stevens Point')
		begin
		insert into Territories values('12345','Stevens Point',3)
		print 'inserted'
		end
		else
		begin
		print 'failed'
		end
	update EmployeeTerritories
	set TerritoryID='12345'
	where TerritoryID= (
	select TerritoryID from Territories where TerritoryDescription='Troy')
end
go

--8
create trigger move_steven
on EmployeeTerritories for insert
as
begin
Declare @tc int=(select count(*) from EmployeeTerritories et left join Territories t on et.TerritoryID=t.TerritoryID where t.TerritoryDescription='Stevens Point')
if @tc>100
begin
	update EmployeeTerritories
	set TerritoryID=(select TerritoryID from Territories where TerritoryDescription='Troy')
	where TerritoryID= (select TerritoryID from Territories where TerritoryDescription='Stevens Point')
end
end


--9
create table [people_Xudong Ren](
	ID int,
    Name varchar(20),
	City int
)
insert into [people_Xudong Ren] values (1,'Aaron Rodgers',2),(2, 'Russell Wilson', 1),(3, 'Jody Nelson', 2)
create table [city_Xudong Ren](
	ID int,
	City Varchar(20)

)
insert into [city_Xudong Ren] values (1,'Seattle'),(2, 'Green Bay')
insert into [city_Xudong Ren] values (3,'Madison')
Update [people_Xudong Ren]
set City=(select ID from [city_Xudong Ren] where City='Madison')
where City=(select ID from [city_Xudong Ren] where City='Seattle')

select* from [city_Xudong Ren]
select*from [people_Xudong Ren]
delete from [city_Xudong Ren] where City='Seattle'

create view [Packers_Xudong Ren] as 
select Name from [people_Xudong Ren] p left join [city_Xudong Ren] c on p.City=c.ID 
where c.City='Green Bay'

Drop Table [city_Xudong Ren]
Drop Table [people_Xudong Ren]
Drop view [Packers_Xudong Ren]

--10
Create Procedure [sp_birthday_employees_Ren]
as
select * 
into [birthday_employees_Ren] 
from Employees
where month(BirthDate)=2;

exec [sp_birthday_employees_Ren]

select * from [birthday_employees_Ren]

drop table [birthday_employees_Ren]

--11
Create Procedure [sp_Ren1]
as
select city, count(customerID)  from(
select c.customerID, c.city, count(od.ProductID) as count
from customers c left join orders o on c.CustomerID=o.CustomerID left join [Order Details] od on o.OrderID=od.OrderID
group by c.customerID,c.city
having count(od.ProductID) <2)a
group by city
having count(customerID)>1
go

Create Procedure [sp_Ren2]
as
with cte as
(
select c.customerID, c.city, count(od.ProductID) as count
from customers c left join orders o on c.CustomerID=o.CustomerID left join [Order Details] od on o.OrderID=od.OrderID
group by c.customerID,c.city
having count(od.ProductID) <2)
select city ,count(customerID)from cte
group by city
having count(customerID)>1
go

--14
select [First Name] +' ' + [Last name] +' '+COALESCE([Middle Name]+'.','') as fullname from Employees

--15
Select top 1 Marks from mark where Sex='F'
order by Marks desc

--16
select * from mark
order by Case when Sex='F' Then 1
			  when Sex='M' Then 2 end, Marks desc