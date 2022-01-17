--Tạo procedure thao tác với bảng lớp (mã, tên) và sinh viên (mã, tên, giới tính, mã lớp):
use buoi2_procedure

create table #lop(
ma int identity,
ten nvarchar(50) not null unique,
primary key (ma))
drop table #lop


create table #sinh_vien(
ma int identity,
ten nvarchar(50) not null,
gioi_tinh bit,
ma_lop int,
foreign key (ma_lop) references lop(ma),
primary key (ma))
drop table #sinh_vien

insert into #lop(ten)
values('LT'),('TA'),('ANTT')

insert into #sinh_vien(ten,gioi_tinh,ma_lop)
values('An',0,1),('Hai',1,1),('Cao',1,1),('Cuong',1,1),('Dong',1,1),('Phuong',0,1),('Yen',0,1),('Hue',0,2),('Chi',0,2),('Kien',1,2),('Duic',1,3)

select * from #lop
select * from #sinh_vien


create proc hien_thi_danh_sach_sinh_vien
@ma int = -1
as
begin
	select * from #sinh_vien
	where ma = @ma or @ma = -1
end
drop proc hien_thi_danh_sach_sinh_vien

--1. xem_sinh_vien: hiển thị thông tin sinh viên kèm lớp. Có thể truyền vào mã lớp hoặc mã sinh viên để lọc
create proc #xem_sinh_vien
@ma int = -1,
@ma_lop int = -1
as
begin
	select * from #sinh_vien 
	join #lop on #sinh_vien.ma_lop = #lop.ma
	where #sinh_vien.ma = @ma or ma_lop = @ma_lop
end
exec #xem_sinh_vien default,1

--2. them_sinh_vien: thêm sinh viên rồi hiển thị lại thông tin sinh viên đó. Có thể không cần truyền giới tính 
--(*: không cần truyền cả mã lớp, mã sẽ lấy mặc định lớp mới nhất)
create proc #them_sinh_vien
@ten nvarchar(50),
@gioi_tinh bit = -1,
@ma_lop int =-1
as
begin
	set @ma_lop = (case when @ma_lop = -1 
					then (select top 1 ma from #lop order by ma desc)
					else @ma_lop end)
	insert into #sinh_vien(ten, gioi_tinh, ma_lop)
	values (@ten, @gioi_tinh, @ma_lop)

	select top 1 * from #sinh_vien 
	order by ma desc
end
exec #them_sinh_vien 'Vu'
drop proc #them_sinh_vien

hien_thi_danh_sach_sinh_vien
--3. sua_sinh_vien: sửa thông tin sinh viên
create proc #sua_sinh_vien
@ma int,
@ten nvarchar(50),
@gioi_tinh bit =-1,
@ma_lop int =-1
as
begin
	exec hien_thi_danh_sach_sinh_vien @ma = @ma --hiển thị tt sinh viên ban đầu
	update #sinh_vien
	set ten = @ten, 
	gioi_tinh = (case when @gioi_tinh = -1 then gioi_tinh else @gioi_tinh end), 
	ma_lop =(case when @ma_lop = -1 then ma_lop else @ma_lop end)
	where ma=@ma

	exec hien_thi_danh_sach_sinh_vien @ma = @ma --hiển thị tt sinh viên sau khi sửa tt
end

exec #sua_sinh_vien 14, 'Hung', default, 2

drop proc #sua_sinh_vien
--4. xoa_sinh_vien (*: hiển thị số lượng sinh viên trước và sau khi xoá. 
create proc #xoa_sinh_vien1
@ma int
as
begin
	select count(*) as so_sinh_vien_truoc_khi_xoa from #sinh_vien
	delete from #sinh_vien where ma = @ma
	select count(*) as so_sinh_vien_sau_khi_xoa from #sinh_vien
end
drop proc #xoa_sinh_vien1
exec #xoa_sinh_vien1 45

--**: hiển thị số lượng sinh viên trước và sau khi xoá của lớp mà lớp đó chứa sinh viên bị xoá. 
create proc #xoa_sinh_vien2
@ma int
as
begin
	 declare @ma_lop int = (select ma_lop from #sinh_vien where ma = @ma)
	 select count(*) as so_sinh_vien_truoc_khi_xoa from #sinh_vien 
	 where ma_lop = @ma_lop

	 delete from #sinh_vien where ma = @ma

	 select count(*) as so_sinh_vien_truoc_khi_xoa from #sinh_vien 
	 where ma_lop = @ma_lop
end
drop proc #xoa_sinh_vien2

exec #xoa_sinh_vien2 44
--***: hiển thị số lượng sinh viên trước và sau khi xoá của các lớp mà các lớp đó chứa các sinh viên bị xoá)

