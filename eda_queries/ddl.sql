use [BankChurn]
go

--create demographic table
create table demographic (
	CustomerId int primary key identity(1,1),
	Gender nvarchar(10),
	Age int,
	Salary decimal(10,2),
	LocationId int,
	Churned bit
);

--create account table
create table account (
	CustomerId int,
	Tenure int,
	Balance decimal(10,2),
	NumProducts int,
	HasCreditCard bit,
	IsActive bit
);

--create location table
create table [location] (
	LocationId int primary key identity (1,1),
	[Geography] nvarchar(15)
);