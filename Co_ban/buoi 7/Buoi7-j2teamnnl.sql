create database quan_ly_sinh_vien
use quan_ly_sinh_vien

--có thông tin sinh viên, lớp (*: môn, điểm)
create table sinh_vien(
id int identity,
id_lop int not null,
ho nvarchar(10) not null constraint CK_ho_sinh_vien check (len(ho)>=2),
ten nvarchar(10) not null constraint CK_ten_sinh_vien check (len(ten)>=2),
ngay_sinh date not null constraint DF_ngay_sinh default getdate(),
so_dien_thoai char(15) not null unique,
foreign key (id_lop) references lop(id),
primary key (id)
)
drop table sinh_vien

create table lop(
id int identity,
ten nvarchar(20) not null unique,
primary key (id)
)
drop table lop

create table mon(
id int identity,
ten nvarchar(20) not null unique,
primary key(id)
)
drop table mon

create table diem_so(
id_sinh_vien int not null,
id_mon int not null,
diem float not null constraint CK_diem check (diem >= 0 and diem <= 10),
foreign key (id_sinh_vien) references sinh_vien(id),
foreign key (id_mon) references mon(id),
primary key(id_sinh_vien, id_mon)
)
drop table diem_so
--có kiểm tra ràng buộc
--Thêm mỗi bảng số bản ghi nhất định
insert into sinh_vien(id_lop, ho, ten, ngay_sinh, so_dien_thoai)
values  (1, N'Lê', N'Hằng', '2000-01-01', '012345'),
		(1, N'Nguyễn', N'Long', '1997-01-01', '015555'),
		(2, N'Hoàng', N'Cao', '2001-01-01', '0122225'),
		(1, N'Trần', N'Lâm', '2001-01-01', '08885')
select * from sinh_vien

insert into lop(ten)
values ('LT'), ('Kế toán')
select * from lop

insert into mon(ten)
values ('OOP'),('SQL'),('HTML CSS')
select * from mon

insert into diem_so(id_sinh_vien, id_mon, diem)
values  (1, 2, 8),(2, 3, 5),(3, 1, 9),(4, 2, 6)
select * from diem_so

--Lấy ra tất cả sinh viên kèm thông tin lớp
select * from sinh_vien
join lop on lop.id = sinh_vien.id_lop

--Đếm số sinh viên theo từng lớp
select id_lop,COUNT(*) as so_sinh_vien from sinh_vien
group by id_lop

--Lấy sinh viên kèm thông tin điểm và tên môn
select * from sinh_vien
join diem_so on sinh_vien.id = diem_so.id_sinh_vien
join mon on diem_so.id_mon = mon.id

--(*) Lấy điểm trung bình của sinh viên của lớp LT
select avg(diem) as diem_trung_binh_lop_LT
from diem_so join sinh_vien on diem_so.id_sinh_vien = sinh_vien.id
			 join lop on sinh_vien.id_lop = lop.id 
where lop.ten = 'LT'

--(*) Lấy điểm trung bình của sinh viên của môn SQL
select avg(diem) as diem_trung_binh_mon_SQL
from diem_so join sinh_vien on diem_so.id_sinh_vien = sinh_vien.id
			 join mon on sinh_vien.id_lop = mon.id 
where mon.ten = 'SQL'

--(*) Lấy điểm trung bình của sinh viên theo từng lớp
Select lop.ten, avg(diem) as diem_trung_binh_theo_lop
from diem_so join sinh_vien on diem_so.id_sinh_vien = sinh_vien.id
			 join lop on lop.id = sinh_vien.id_lop
group by lop.ten