create database quan_ly_nhan_vien
use quan_ly_nhan_vien

create table quan_ly_luong_nhan_vien(
--mã nhân viên không được phép trùng
ma int identity,
primary key(ma),
--lương là số nguyên dương
luong int  not null
	constraint CK_luong check (luong > 0),
--tên không được phép ngắn hơn 2 ký tự
ten nvarchar(25)  not null
	constraint CK_ten check (len(ten) > 2),
--tuổi phải lớn hơn 18
ngay_sinh date  not null
	constraint CK_tuoi check (year(getdate()) - year(ngay_sinh) > 18),
--giới tính mặc định là nữ
gioi_tinh bit  not null
	constraint DF_gioi_tinh default 0,
--ngày vào làm mặc định là hôm nay
ngay_vao_lam date  not null
	constraint DF_ngay_vao_lam default getdate(),
--nghề nghiệp phải nằm trong danh sách ('IT','kế toán','doanh nhân thành đạt')
nghe_nghiep nvarchar(50)  not null
	constraint CK_nghe_nghiep check (nghe_nghiep in (N'IT', N'kế toán', N'doanh nhân thành đạt'))
)

drop table quan_ly_luong_nhan_vien
--tất cả các cột không được để trống
--Công ty có 5 nhân viên
insert into quan_ly_luong_nhan_vien(luong, ten, ngay_sinh, gioi_tinh, nghe_nghiep)
values  (100, N'Ánh', '2001-10-01', 1, N'IT' ),
		(150, N'Hoa', '1998-01-01', 0, N'kế toán' ),
		(200, N'Mai', '2002-01-01', 0, N'IT' ),
		(500, N'Hải', '1990-01-01', 1, N'doanh nhân thành đạt' ),
		(110, N'Lâm', '2000-10-01', 1, N'IT' )
insert into quan_ly_luong_nhan_vien(luong, ten, ngay_sinh, ngay_vao_lam, gioi_tinh, nghe_nghiep)
values  (100, N'Phương', '1997-02-01', '2021-01-01', 0, N'kế toán' ),
		(300, N'Cường', '1992-10-01', '2018-01-01', 1, N'doanh nhân thành đạt' ),
		(50, N'Hạnh', '2001-10-01', '2021-09-01', 1, N'IT' )

select * from quan_ly_luong_nhan_vien

--Tháng này sinh nhật sếp, sếp tăng lương cho nhân viên sinh tháng này thành 100. (*: tăng lương cho mỗi bạn thêm 100)
update quan_ly_luong_nhan_vien
set luong += 100
where MONTH(getdate()) = month(ngay_sinh)

--Dịch dã khó khăn, cắt giảm nhân sự, cho nghỉ việc bạn nào lương dưới 50. (*: xoá cả bạn vừa thêm 100 nếu lương cũ dưới 50). (**: đuổi cả nhân viên mới vào làm dưới 2 tháng)
delete quan_ly_luong_nhan_vien
where luong < 50 or (luong < 150 and MONTH(GETDATE()) = MONTH(ngay_sinh))
delete quan_Ly_luong_nhan_vien
where DATEDIFF(MONTH, ngay_vao_lam, GETDATE() < 2)

--Lấy ra tổng tiền mỗi tháng sếp phải trả cho nhân viên. (*: theo từng nghề)
select nghe_nghiep, sum(luong) as tien_sep_tra_mo_thang_IT
from quan_ly_luong_nhan_vien
group by nghe_nghiep

--Lấy ra trung bình lương nhân viên. (*: theo từng nghề)
select nghe_nghiep, avg(luong) as tien_sep_tra_mo_thang_IT
from quan_ly_luong_nhan_vien
group by nghe_nghiep

--(*) Lấy ra các bạn mới vào làm hôm nay
select * from quan_ly_luong_nhan_vien
where DATEDIFF(day,ngay_vao_lam, GETDATE()) = 0 and ngay_vao_lam < getdate()

(*) Lấy ra 3 bạn nhân viên cũ nhất
select top 3 * from quan_ly_luong_nhan_vien
order by ngay_vao_lam asc

--(**) Tách những thông tin trên thành nhiều bảng cho dễ quản lý, lương 1 nhân viên có thể nhập nhiều lần