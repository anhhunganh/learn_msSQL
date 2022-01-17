--Tạo cơ sở dữ liệu để lưu thông tin kinh doanh của 1 cửa hàng
create database cua_hang
use cua_hang

--Yêu cầu có đủ:
--thông tin khách hàng
create table khach_hang(
id int identity,
name nvarchar(50) not null constraint CK_ten_khach_hang check (len(name) >= 2),
ngay_sinh date not null constraint DF_ngay_sinh default getdate(),
so_dien_thoai char(15) not null unique,
primary key(id)
)
drop table khach_hang

insert into khach_hang(name, ngay_sinh, so_dien_thoai)
values ('Anh', default, '0123456')
select * from khach_hang

--thông tin sản phẩm
create table san_pham(
id int identity,
name nvarchar(50) not null unique constraint CK_ten_san_pham check (len(name) >= 2),
so_luong int not null constraint CK_so_luong check(so_luong > 0),
gia int not null constraint CK_gia check(gia > 0)
primary key(id)
)
drop table san_pham
insert into san_pham(name, so_luong, gia)
values ('Tivi', 5, 2000000)
select * from san_pham

--thông tin hoá đơn
create table hoa_don(
id int identity,
id_khach_hang int not null,
ngay_xuat_hoa_don date not null constraint DF_ngay_xuat_hoa_don default getdate(),
tong_tien int not null constraint CK_tont_tien check(tong_tien > 0),
foreign key (id_khach_hang) references khach_hang(id),
primary key(id)
)
drop table hoa_don
insert into hoa_don(id_khach_hang, ngay_xuat_hoa_don, tong_tien)
values (1, default, 2000000)
select * from hoa_don

--thông tin hoá đơn
create table thong_tin_hoa_don(
id_hoa_don int not null,
id_san_pham int not null,
so_luong int check (so_luong > 0),
thanh_tien int check (thanh_tien > 0),
foreign key (id_hoa_don) references hoa_don(id),
foreign key (id_san_pham) references san_pham(id),
primary key(id_hoa_don, id_san_pham)
)
insert into thong_tin_hoa_don(id_hoa_don,id_san_pham,so_luong,thanh_tien)
values (1, 1, 1, 2000000)
select * from thong_tin_hoa_don
drop table thong_tin_hoa_don