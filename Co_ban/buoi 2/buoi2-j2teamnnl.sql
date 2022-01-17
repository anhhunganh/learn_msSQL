create database quan_ly_khach_hang
use quan_ly_khach_hang

create table thong_tin_khach_hang(
ma int identity primary key,
ten nvarchar(50) not null,
gioi_tinh bit,
ngay_sinh date,
so_dien_thoai char(15) unique not null,
dia_chi nvarchar(100)
)

drop table thong_tin_khach_hang

--Thêm 5 khách hàng
insert into thong_tin_khach_hang(ten,gioi_tinh,ngay_sinh,so_dien_thoai,dia_chi)
values  (N'Anh',1,'2001-01-01','01234567890','BacNinh'),
		(N'Hùng',1,'2001-02-01','01234567890','HaNoi'),
		(N'Anh',0,'2001-01-01','01234567890','ThaiNguyen'),
		(N'Thuý',0,'1999-03-01','01234567890','ThaiBinh'),
		(N'Minh',1,'2001-01-01','01234567890','HaNoi')

--Hiển thị chỉ họ tên và số điện thoại của tất cả khách hàng
select ten,so_dien_thoai from thong_tin_khach_hang

--Cập nhật khách có mã là 2 sang tên Tuấn
update thong_tin_khach_hang
set ten = N'Tuấn'
where ma in(1,2)

--Xoá khách hàng có mã lớn hơn 3 và giới tính là Nam
delete from thong_tin_khach_hang
where ma > 3 and gioi_tinh = 1

--(*) Lấy ra khách hàng sinh tháng 1
SELECT * FROM thong_tin_khach_hang WHERE MONTH(ngay_sinh) = 1

--(*) Lấy ra khách hàng có họ tên trong danh sách (Anh,Minh,Đức) và giới tính Nam hoặc chỉ cần năm sinh trước 2000
Select * from thong_tin_khach_hang 
where (ten in (N'Anh',N'Minh',N'Đức') and gioi_tinh = 1) or YEAR(ngay_sinh) < 2000

--(**) Lấy ra khách hàng có tuổi lớn hơn 18
SELECT * FROM thong_tin_khach_hang 
WHERE YEAR(GETDATE()) - YEAR(ngay_sinh) > 18

--(**) Lấy ra 3 khách hàng mới nhất
select top 3 *
from thong_tin_khach_hang
order by ma desc

--(**) Lấy ra khách hàng có tên chứa chữ T
select * from thong_tin_khach_hang
where ten like 'T%'

--(***) Thay đổi bảng sao cho chỉ nhập được ngày sinh bé hơn ngày hiện tại
alter table thong_tin_khach_hang
add constraint CK_ngay_sinh check (ngay_sinh < getdate())

insert into thong_tin_khach_hang(ten,gioi_tinh,ngay_sinh,so_dien_thoai,dia_chi)
values  (N'Anh',1,'2021-12-01','01234567890','BacNinh')

--xoá check
alter table thong_tin_khach_hang
drop constraint CK__thong_tin__ngay___5AEE82B9;


--Default
alter table thong_tin_khach_hang
add constraint DF_gioi_tinh
default null for gioi_tinh

insert into thong_tin_khach_hang(ten,ngay_sinh,so_dien_thoai,dia_chi)
values  (N'Hạnh','2001-10-10','01234567890','BacNinh')

select * from thong_tin_khach_hang