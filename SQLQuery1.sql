Create table Customer (
ID int PRIMARY KEY IDENTITY(1,1),
FirstName Nvarchar (MAX) ,
LastName Nvarchar (MAX),
Email  Nvarchar (MAX),
Pssword Nvarchar (MAX),
LoginTheSystem Date,
ContactPhone Nvarchar (MAX),
ContactAdress Nvarchar (MAX),
State Nvarchar (MAX),
County Nvarchar (MAX),
)

Create table Product(
ID int PRIMARY KEY IDENTITY(1,1), 
prdname nvarchar(MAX),
Delivery Date, -- Teslim alınan
UserStatement Nvarchar(MAX), --kullanıcı beyan
ServiceInformation Nvarchar(MAX), --teknik servis bilgileri
-- FaultCategory Nvarchar (MAX), --Arıza kategorisi
TechnicalServiceFee int , --Teknik servis ücret
DueDate Date, --Teslim edileceği tarih
--TechnicalEmployee Nvarchar(MAX), -- Arıza ile ilgilenecek teknik servis personeli bilgisi
serviceStage Nvarchar (MAX) --teknik servisteki aşaması

)
Create table Category (
ID int PRIMARY KEY IDENTITY(1,1),
CtgryName Nvarchar (MAX),

)
Create table Report (
ID int PRIMARY KEY IDENTITY(1,1),
report Nvarchar (MAX),
)


Create table Employee (
ID int PRIMARY KEY IDENTITY(1,1),
FirstName Nvarchar (MAX),
LastName Nvarchar (MAX),
)

create Table employeetchnical(
ID int PRIMARY KEY IDENTITY(1,1),
EmployeeID int,
e_TechnicalID int
)

-- Bir kategoride birden fazla ürün olabilir
create Table CategoryProducts(
ID int PRIMARY KEY IDENTITY(1,1),
CatgoryID int,
ProductsID int
)

-- Bir kullanıcı birden fazla ürünü servise yollamış olabilir.
create Table TechnicalProducts(
ID int PRIMARY KEY IDENTITY(1,1),
Technical int,
ProductsID int
)

select *from Employee e
inner join employeetchnical et on et.EmployeeID=e.ID
inner join TechnicalProducts tp on tp.Technical=et.e_TechnicalID

-- Ürün ismi, Category ilişkilendirme
select p.prdname,c.CtgryName from Product p 
inner join CategoryProducts cp on cp.ProductsID=p.ID
inner join Category c on c.ID=cp.CatgoryID

-- kullaıcı ismi ve sahip olduğu ürün
select m.FirstName,p.prdname from Customer m
inner join TechnicalProducts tp on tp.ProductsID=m.ID
inner join Product p on p.ID=tp.ProductsID

create proc sp_Productadd(@Name nvarchar(30))
as
begin 
insert into Product(prdname) values (@Name)
end

sp_Productadd 'Telephone'

create proc sp_ProductUpd(@Name nvarchar(30))
as
begin 
Update Product set prdname= 'Telephone' where prdname=@Name
end

CREATE PROCEDURE pd_delete
@kid int
AS
DELETE FROM Category WHERE ID=@kid
GO

-- burada bir tane daha proc getirelecek

--ID’si girilen ürün, hangi aşamada?
CREATE proc UrunAsama (@id int)
AS 
begin
SELECT p.serviceStage FROM Product p Where p.ID=@id 
end

--ID’si girilen ürün hangi üye tarafından bırakılmış?
CREATE proc prodtCustomer (@idCstmr int)
AS 
begin
select m.FirstName from Customer m
inner join TechnicalProducts tp on tp.ProductsID=m.ID
inner join Product p on p.ID=tp.ProductsID 
where p.ID=@idCstmr
end

--ID’si girilen üye hangi ürün/ürünleri, hangi tarihte bırakmış ve ürünün sorgu anında teknik servisin hangi aşamasında

CREATE proc DateCustomer (@id int)
AS 
begin
select m.FirstName,p.Delivery,p.serviceStage from Customer m
inner join TechnicalProducts tp on tp.ProductsID=m.ID
inner join Product p on p.ID=tp.ProductsID 
where p.ID=@id
end

--Hangi arıza kategorisinde ürünlerden kaçar adet servise geldiği günlük, aylık, yıllık olarak sorgulanabilmeli,
CREATE proc arizacatgry (@id int)
AS 
begin
select c.CtgryName,Count(p.prdname), p.Delivery from Category c 
inner join TechnicalProducts tp on tp.ProductsID=c.ID
inner join Product p on p.ID=tp.ProductsID
end

--Günlük tahsilat ve ciro raporu oluşturan sorgu,
CREATE proc ciro 
AS 
begin
select COUNT(p.TechnicalServiceFee) from Product p  
end

--Teknik servis personeli, kişi bazlı, aylık performans raporu hazırlayan sorgu
CREATE proc employeereport (@id int)
AS 
begin
select e.FirstName,p.report from Employee e 
inner join Report p on p.ID=e.ID
end