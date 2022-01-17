--Tạo cơ sở dữ liệu để quản lý sinh viên
create database quan_ly_sinh_vien
use quan_ly_sinh_vien
--Yêu cầu:

--có thông tin sinh viên, lớp (*: môn, điểm)
--có kiểm tra ràng buộc
create table sinh_vien
(ma int,
ho nvarchar(10) not null,
ten nvarchar(40) not null,
ma_lop int not null,
gioi_tinh bit default null,
ngay_sinh date,
dia_chi nvarchar(200) default null,
primary key (ma),
foreign key (ma_lop) references lop(ma),
constraint CK_ho_sinh_vien Check (len(ho)>=2),
constraint CK_ten_sinh_vien Check (len(ten)>=2),
constraint CK_ngay_sinh Check (year(getdate()) - year(ngay_sinh) >= 18),
)
drop table sinh_vien

create table lop(
ma int,
ten nvarchar(50) not null unique,
primary key (ma),
constraint Ck_ten_lop Check (len(ten)>=2))

create table mon_hoc(
ma int identity,
ten nvarchar(50) not null unique,
primary key (ma))

create table diem(
ma_sv int,
ma_mon int,
diem_mon float not null,
constraint Ck_diem check (diem_mon >= 0 and diem_mon <= 10),
foreign key (ma_sv) references sinh_vien(ma),
foreign key (ma_mon) references mon_hoc(ma),
primary key (ma_sv, ma_mon)
)
--Thêm mỗi bảng số bản ghi nhất định
insert into lop(ma,ten) values
(123,'LT'),(124,'TA')

insert into sinh_vien(ma,ho,ten,ma_lop,gioi_tinh,ngay_sinh,dia_chi) values
('191364923',N'Nguyễn', N'Anh','123',1,'01-01-2001','Bắc Ninh'),
('191364925',N'Lưu', N'Hoàng','123',1,'01-01-2001',null),
('191364926',N'Đặng', N'Cao','124',1,'01-01-2001','Hà Nội'),
('191364928',N'Lê', N'Nhật','123',1,'01-01-2001','Cao Bằng'),
('191364920',N'Bùi', N'Hùng','124',1,'01-01-2001',null),
('191364910',N'Phạm', N'Quý','123',1,'01-01-2001','Hải Dương')

insert into mon_hoc(ten) values
(N'Nói'),('SQL'),('Nghe')

insert into diem (ma_sv, ma_mon, diem_mon) values
(191364923,2,8.5),
(191364925,2,8.5),
(191364926,1,7),
(191364928,2,8),
(191364920,3,5),
(191364910,2,5.5),

--Lấy ra tất cả sinh viên kèm thông tin lớp
select * from sinh_vien
join lop on sinh_vien.ma_lop = lop.ma

--Đếm số sinh viên theo từng lớp
select lop.ten ,count(*) as so_luong_sv from lop
join sinh_vien on sinh_vien.ma_lop = lop.ma
group by lop.ten

--Lấy sinh viên kèm thông tin điểm và tên môn
select * from sinh_vien 
join diem on diem.ma_sv = sinh_vien.ma
join mon_hoc on diem.ma_mon = mon_hoc.ma

--(*) Lấy điểm trung bình của sinh viên của lớp LT
select  AVG(diem_mon) as diem_tb_lop_LT from diem
join sinh_vien on sinh_vien.ma = diem.ma_sv
join lop on sinh_vien.ma_lop = lop.ma
where lop.ten = 'LT'

--(*) Lấy điểm trung bình của sinh viên của môn SQL
select AVG(diem_mon) as diem_tb_mon_SQL from diem
join mon_hoc on mon_hoc.ma = diem.ma_mon
where mon_hoc.ten = 'SQL'

--(*) Lấy điểm trung bình của sinh viên theo từng lớp
select lop.ten,AVG(diem_mon) from diem
join sinh_vien on  diem.ma_sv = sinh_vien.ma 
join lop on  sinh_vien.ma_lop = lop.ma
group by lop.ma,lop.ten
