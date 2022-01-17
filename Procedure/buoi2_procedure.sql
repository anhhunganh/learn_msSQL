--Tạo procedure thao tác với bảng lớp (mã, tên) và sinh viên (mã, tên, giới tính, mã lớp):

create database buoi2_procedure
use buoi2_procedure

create table lop(
ma int identity,
ten nvarchar(50) not null unique,
primary key (ma))
drop table lop

create table sinh_vien(
ma int identity,
ten nvarchar(50) not null,
gioi_tinh bit,
ma_lop int,
primary key (ma),
foreign key (ma_lop) references lop(ma))
drop table sinh_vien

create proc them_va_xem_ds_lop
@ten nvarchar(50)
as
begin
	insert into lop(ten)
	values (@ten)
	select * from lop
end
exec them_va_xem_ds_lop @ten = 'TA'

create proc them_va_xem_ds_sinh_vien
@ten nvarchar(50),
@gioi_tinh bit,
@ma_lop int
as
begin
	insert into sinh_vien(ten, gioi_tinh, ma_lop)
	values (@ten, @gioi_tinh, @ma_lop)
	select * from sinh_vien
end
exec them_va_xem_ds_sinh_vien @ten=N'côngo', @gioi_tinh = 0, @ma_lop=2

create procedure xem_ds_sinh_vien
@ma int = -1
as
begin
	select * from sinh_vien
	where ma=@ma or @ma=-1
end
drop proc xem_ds_sinh_vien
exec xem_ds_sinh_vien

--xem_sinh_vien: hiển thị thông tin sinh viên kèm lớp. Có thể truyền vào mã lớp hoặc mã sinh viên để lọc.
create proc xem_sinh_vien
@ma int = -1,
@ma_lop int = -1
as
begin
	select * from sinh_vien 
	join lop on sinh_vien.ma_lop = lop.ma
	where sinh_vien.ma = @ma or lop.ma = @ma_lop 
end
exec xem_sinh_vien default, 1
drop proc xem_sinh_vien

--them_sinh_vien: thêm sinh viên rồi hiển thị lại thông tin sinh viên đó. Có thể không cần truyền giới tính
--(*: không cần truyền cả mã lớp, mã sẽ lấy mặc định lớp mới nhất).

drop proc them_va_hien_thi_sinh_vien
create proc them_va_hien_thi_sinh_vien
@ten nvarchar (50),
@gioi_tinh bit = 1,
@ma_lop int = -1
as
begin 
	set @ma_lop = 
	(case 
		when @ma_lop = -1 
			then (select top 1 ma from lop order by ma desc) 
			else @ma_lop 
	end)
	
	insert into sinh_vien (ten, gioi_tinh,ma_lop)
	values (@ten,@gioi_tinh, @ma_lop) 

	select top 1 * from sinh_vien
	
	order by ma desc
end

them_va_hien_thi_sinh_vien @ten = 'Vu'

create proc them_sinh_vien
@ten nvarchar(50),
@gioi_tinh bit = 1,
@ma_lop int = -1 
as
begin
		set @ma_lop=(case 
			when @ma_lop = -1 
			then (select top 1 ma from lop order by ma desc)
			else  @ma_lop
			end)

		insert into sinh_vien (ten,gioi_tinh_ma_lop)
		values (@ten,@gioi_tinh,@ma_lop)

		select top 1 * from sinh_vien order by ma desc			
end
drop proc them_sinh_vien
exec them_sinh_vien @ten='s'

--sua_sinh_vien: sửa thông tin sinh viên.
create proc sua_sinh_vien
@ma int,
@ten nvarchar(50),
@gioi_tinh bit = null,
@ma_lop int = -1
as
begin
	exec xem_ds_sinh_vien @ma = @ma --tt trước khi sửa
	update sinh_vien
	set ten = @ten,
		gioi_tinh = case when @gioi_tinh is null then gioi_tinh else @gioi_tinh end,
		ma_lop = case when @ma_lop = -1 then ma_lop else @ma_lop end
	where ma = @ma 
	exec xem_ds_sinh_vien @ma=@ma --hiển thị tt sau khi sửa tt
end
drop proc sua_sinh_vien
exec sua_sinh_vien @ten = 'Anh', @ma =1,  @gioi_tinh = 0

--xoa_sinh_vien (*: hiển thị số lượng sinh viên trước và sau khi xoá. 
--				**: hiển thị số lượng sinh viên trước và sau khi xoá của lớp mà lớp đó chứa sinh viên bị xoá. 
--				***: hiển thị số lượng sinh viên trước và sau khi xoá của các lớp mà các lớp đó chứa các sinh viên bị xoá).


--*: hiển thị số lượng sinh viên trước và sau khi xoá. 
create proc so_sv
as
begin
	select count(*)as so_luong_sv from sinh_vien 
end
exec so_sv

create proc xoa_sinh_vien1
@ma int 
as
begin
	exec so_sv
	

	delete from sinh_vien where ma = @ma

	exec so_sv
end
drop proc xoa_sinh_vien1
exec xoa_sinh_vien1 @ma = 1
--**: hiển thị số lượng sinh viên trước và sau khi xoá của lớp mà lớp đó chứa sinh viên bị xoá. 




create proc xoa_sinh_vien2
@ma int
as
begin
	declare @ma_lop int = (select ma_lop from sinh_vien where ma= @ma)
	select count(*) as so_sv_khi_chua_xoa from sinh_vien where ma_lop = @ma_lop
	
	delete from sinh_vien 
	where ma = @ma

	select count(*) as so_sv_sau_khi_chua_xoa from sinh_vien where ma_lop = @ma_lop
	
end
drop proc xoa_sinh_vien2
exec xoa_sinh_vien2 5

--***: hiển thị số lượng sinh viên trước và sau khi xoá của các lớp mà các lớp đó chứa các sinh viên bị xoá).
