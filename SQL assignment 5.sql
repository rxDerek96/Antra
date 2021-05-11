--1.What is an object in SQL?
--A database object is any defined object in a database that is used to store or reference data，such as tables, views and indexes.

--2.What is Index? What are the advantages and disadvantages of using Indexes?
--Advantages:Speed up query,  keeps row unique or without duplicates, If index is set to fill-text index, then we can search against large string values.
--Disadvantages:Indexes take additional disk space.indexes slow down INSERT,UPDATE and DELETE because on each operation the indexes must also be updated. 

--3.What are the types of Indexes?
--Clustered Index.
--Non-Clustered Index.
--Unique Index.
--Filtered Index.
--Columnstore Index.
--Hash Index.

--4.Does SQL Server automatically create indexes when a table is created? If yes, under which constraints?
--Yes, primary key or unique constraint

--5.Can a table have multiple clustered index? Why?
--No because the data can be stored in only one order.

--6.Can an index be created on multiple columns? Is yes, is the order of columns matter?
--Yes, it is called composite index. 
--The order of the columns in a composite index does matter on how a query against a table will use it or not. A query will use a composite index only if the where clause of the query has at least the leading/left most columns of the index in it.

--7.Can indexes be created on views?
--No.

--8.What is normalization? What are the steps (normal forms) to achieve normalization?
--Database Normalization is a process of organizing data to minimize redundancy (data duplication), which in turn ensures data consistency. 
--First Normal Form:
--Data in each column should be atomic, no multiples values separated by comma.
--The table does not contain any repeating column group
--Identify each record using primary key.
--Second Normal Form:
--The table must meet all the conditions of 1NF
--Move redundant data to separate table
--Create relationships between these tables using foreign keys
--Third Normal Form:
--Table must meet all the conditions of 1NF and 2nd.
--Does not contain columns that are not fully dependent on primary key.

--9.What is denormalization and under which scenarios can it be preferable?
--Denormalization is a database optimization technique in which we add redundant data to tables. This can help us avoid costly joins in a relational database.

--10.How do you achieve Data Integrity in SQL Server?
--By using constraints, for example using primary key and unique constraint to ensure entity integrity and using foreign key to ensure referential integrity

--11.What are the different kinds of constraint do SQL Server have?
--Not Null Constraint.
--Check Constraint.
--Default Constraint.
--Unique Constraint.
--Primary Constraint.
--Foreign Constraint.

--12.What is the difference between Primary Key and Unique Key?
--There can be only one primary key in one table but can be many unique columns. 
--Unique columns can be null while primary key cannot.

--13.What is foreign key?
--Foreign key is a field in one table which refers to the primary key in another table.

--14.Can a table have multiple foreign keys?
--Yes.

--15.Does a foreign key have to be unique? Can it be null?
--No. It can be null.

--16.Can we create indexes on Table Variables or Temporary Tables?
--No.

--17.What is Transaction? What types of transaction levels are there in SQL Server?
--Transaction is a logical unit of work and executes either completely by commit or can be undone by rollback.
--Read Uncommitted (Lowest level)，Read Committed，Repeatable Read，Serializable (Highest Level)

--1.Write an sql statement that will display the name of each customer and the sum of order totals placed by that customer during the year 2002

Create table customer(cust_id int,  iname varchar (50)) 
create table [order](order_id int,cust_id int,amount money,order_date smalldatetime)
select c.cust_id,iname,count(case when YEAR(order_date)=2002 then 1 else null end) as 'sum of order 2002' from customer c left join [order] o on c.cust_id=o.cust_id
group by c.cust_id,iname

--2.write a query that returns all employees whose last names  start with “A”.
Create table person (id int, firstname varchar(100), lastname varchar(100))
select * from person where lastname like'A%'



--3.Please write a query that would return the names of all top managers
--(an employee who does not have  a manger, and the number of people that report directly to this manager.
Create table person(person_id int primary key, manager_id int null, name varchar(100)not null) 
select m.person_id,m.name,count(p.person_id) as'number of emp' from person m left join person p on m.person_id=p.manager_id
group by m.person_id,m.name
having m.person_id in(select person_id from person where manager_id is null)

--4.List all events that can cause a trigger to be executed.
--update,delete,insert,create,drop,alter

--5. Generate a destination schema in 3rd Normal Form.  
--Include all necessary fact, join, and dictionary tables, and all Primary and Foreign Key relationships.  The following assumptions can be made:
--a. Each Company can have one or more Divisions.
--b. Each record in the Company table represents a unique combination 
--c. Physical locations are associated with Divisions.
--d. Some Company Divisions are collocated at the same physical of Company Name and Division Name.
--e. Contacts can be associated with one or more divisions and the address,
--but are differentiated by suite/mail drop records.status of each association should be separately maintained and audited.


CREATE SCHEMA Demo;
GO
create table Demo.Company(CompanyID int not null primary key, CompanyName varchar(20) unique);
create table Demo.Division(DivisionID int not null primary key ,DivisionName varchar(20) unique,address varchar(50));
create table Demo.Contacts(ContactID int not null primary key,ContactName varchar(20));
create table Demo.CompanyDivision(CompanyID int foreign key references Demo.Company(CompanyID), DivisionID int foreign key references Demo.Division(DivisionID),constraint PK_CompanyDivision PRIMARY KEY (CompanyID,DivisionID));
create table Demo.ContactsDivision(ContactID int foreign key references Demo.Contacts(ContactID), DivisionID int foreign key references Demo.Division(DivisionID),constraint PK_ContactsDivision PRIMARY KEY (ContactID,DivisionID),suiteNo int);
