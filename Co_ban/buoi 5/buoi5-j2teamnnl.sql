create database zoo
use zoo


create table animal(
id int identity,
name nvarchar(50) not null constraint CK_name_animal check(len(name) > 1),
age int not null constraint CK_animal_age check (age >= 1),
number_of_pins int not null constraint CK_animal_of_pins check (number_of_pins >= 0),
habitat nvarchar(25) not null constraint DF_abimal_habitat default N'trên cạn' ,
primary key(id)
)

--Sở thú hiện có 7 con
insert into animal(name, age, number_of_pins, habitat)
values  (N'Sư tử', 5, 4, N'trên cạn'),
		(N'con công', 2, 2,N'trên cạn'),
		(N'Cá sấu', 3, 4, N'dưới nước'),
		(N'Rắn', 1, 0, N'dưới nước'),
		(N'Đà điểu', 3, 2, N'trên cạn'),
		(N'Hươu cao cổ', 6, 4, N'trên cạn'),
		(N'Hà mã', 7, 4, N'trên cạn')

select * from animal 
drop table animal

--Thống kê có bao nhiêu con 4 chân
select COUNT(*) from animal
where number_of_pins = 4

--Thống kê số con tương ứng với số chân
select number_of_pins, COUNT(number_of_pins) as thong_ke_theo_so_chan from animal
group by number_of_pins

--Thống kê số con theo môi trường sống
select habitat, COUNT(habitat) as thong_ke_theo_habitat from animal
group by habitat

--Thống kê tuổi thọ trung bình theo môi trường sống
select habitat,avg(age) as tuoi_trung_binh
from animal
group by habitat

--Lấy ra 3 con có tuổi thọ thọ cao nhất
select top 3 * from animal
order by age desc

--(*) Tách những thông tin trên thành 2 bảng cho dễ quản lý (1 môi trường sống gồm nhiều con)
create table animal(
id int identity,
name nvarchar(50) not null constraint CK_name_animal check(len(name) > 1),
age int not null constraint CK_animal_age check (age >= 1),
number_of_pins int not null constraint CK_animal_of_pins check (number_of_pins >= 0),
habitat nvarchar(25) not null constraint DF_abimal_habitat default N'trên cạn' ,
primary key(id)
)

create table habitats(
id_habitat int identity,
habitat_name nvarchar(50) not null constraint CK_habitat_name check (len(habitat_name) > 1),
number_of_animal int not null constraint CK_number_of_animal check (number_of_animal >=0)
)