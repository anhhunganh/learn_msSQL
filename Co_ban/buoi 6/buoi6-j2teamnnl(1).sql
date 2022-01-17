create database buoi6_thong_tin_kinh_doanh
use buoi6_thong_tin_kinh_doanh


create table khach_hang(
ma int identity,
ten nvarchar(50) not null constraint CK_ten_khach_hang check(len(ten)>=2),
dia_chi nvarchar(50) not null,
so_dien_thoai nvarchar(20) not null 
primary key (ma))

create table thong_tin_san_pham(
ma int identity,
ten nvarchar(50) not null constraint CK_ten_san_pham check (len(ten)>=2),
so_luong int not null constraint CK_so_luong check (so_luong >= 0) default 0,
gia_ban int not null constraint CK_gia_ban check (gia_ban >= 0) ,
primary key (ma))

create table hoa_don(
ma int identity,
ma_khach_hang int,
ngay_lap_hoa_don date not null constraint CK_ngay_lap_hoa_don default getdate(),
tong_tien int check(tong_tien >0),
primary key(ma)
)