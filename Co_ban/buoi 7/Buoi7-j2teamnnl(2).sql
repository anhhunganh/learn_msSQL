--Tạo cơ sở dữ liệu để quản lý sinh viên
create database buoi7_quan_ly_sinh_vien
use buoi7_quan_ly_sinh_vien

--Yêu cầu:

--có thông tin sinh viên, lớp (*: môn, điểm)
--có kiểm tra ràng buộc
create table lop(
ma int identity,
ten nvarchar(50),
primary key(ma)
)
drop table lop

create table mon(
ma int identity,
ten nvarchar(50) not null unique,
primary key (ma))
drop table mon

create table sinh_vien(
ma int identity,
ten nvarchar(50) not null check(len(ten)>=2),
ma_lop int,
gioi_tinh bit default 0,
ngay_sinh date not null check (ngay_sinh < getdate()),
dia_chi nvarchar(50),
primary key(ma))
drop table sinh_vien

create table diem(
ma_sinh_vien int not null,
ma_mon int not null,
diem float not null,
foreign key (ma_sinh_vien) references sinh_vien(ma),
foreign key (ma_mon) references mon(ma),
primary key(ma_sinh_vien, ma_mon))


--Thêm mỗi bảng số bản ghi nhất định
insert into lop(ten)
values ('LT'),('QTKD')
select * from lop

insert into mon(ten)
values ('SQL'), ('TA'),('CSS')
select * from mon

insert into sinh_vien(ten, ma_lop, gioi_tinh, ngay_sinh, dia_chi)
values ('Anh', 1, 1, '2001-01-01', N'Bắc Ninh'),
('Nam', 2, 1, '2001-02-02', N'Hà Nội'),
('Cao', 1, 0, '2001-03-03', N'Bắc Giang'),
(N'Hạnh', 1, 0, '2001-05-02', N'Hưng Yên')
insert into sinh_vien(ten, ma_lop, gioi_tinh, ngay_sinh, dia_chi)
values ('Anh', 1, 1, '2021-05-10', N'Bắc Ninh')
select * from sinh_vien

insert into diem(ma_sinh_vien, ma_mon, diem)
values (1,1,8),(2,2,8),(3,1,4),(4,1,10)
select * from diem

--Lấy ra tất cả sinh viên kèm thông tin lớp
select * from sinh_vien
join lop on lop.ma = sinh_vien.ma_lop

--Đếm số sinh viên theo từng lớp
select ma_lop, count(*) as N'số sinh viên' from sinh_vien
group by ma_lop

--Lấy sinh viên kèm thông tin điểm và tên môn
select * from sinh_vien
join diem on diem.ma_sinh_vien = sinh_vien.ma
join mon on mon.ma = diem.ma_mon

--(*) Lấy điểm trung bình của sinh viên của lớp LT
select AVG(diem) as diem_trung_binh from diem
join sinh_vien on diem.ma_sinh_vien = sinh_vien.ma
join lop on lop.ma = sinh_vien.ma_lop
where lop.ten = 'LT'

--(*) Lấy điểm trung bình của sinh viên của môn SQL
select AVG(diem) as diem_trung_binh from diem
join sinh_vien on diem.ma_sinh_vien = sinh_vien.ma
join mon on mon.ma = diem.ma_mon
where mon.ten = 'SQL'

--(*) Lấy điểm trung bình của sinh viên theo từng lớp
select lop.ma, lop.ten as ten_lop, AVG(diem) as diem_tb_theo_lop from diem
join sinh_vien on diem.ma_sinh_vien = sinh_vien.ma
join lop on lop.ma = sinh_vien.ma_lop
group by lop.ma, lop.ten






