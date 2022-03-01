create database trigger_after
use trigger_after

drop table lop

create table lop(
ma int identity,
ten nvarchar(50),
so_luong_sinh_vien int default 0,
primary key (ma)
)
insert into lop (ten)
values ('SQL'), ('WEB')

drop table sinh_vien

create table sinh_vien(
ma int identity,
ten nvarchar(50),
ma_lop int,
foreign key (ma_lop) references lop(ma),
primary key (ma)
)

drop trigger trigger_them_sinh_vien
create or alter trigger trigger_them_sinh_vien
on sinh_vien
after insert
as
begin
	declare @ma_lop int = (select ma_lop from inserted)
	update lop
	set 
		so_luong_sinh_vien = so_luong_sinh_vien + 1
	where
		ma = @ma_lop

	select * from lop
	select * from sinh_vien
end

insert into sinh_vien(ten, ma_lop)	 --Do co trigger nen chi them tung sinh vien mot
values ('Hi',1)

--Trigger xoa 1 sinh vien
drop trigger trigger_xoa_sinh_vien
create or alter trigger trigger_xoa_sinh_vien
on sinh_vien
after delete
as
begin
	declare @ma_lop int = (select ma_lop from deleted)
	update lop
	set 
		so_luong_sinh_vien = so_luong_sinh_vien - 1
	where
		ma = @ma_lop

	select * from lop
	select * from sinh_vien
end

delete from sinh_vien
where ma =2


--Trigger sua so luong sinh vien 2 lop khi co 1 sv chuyen lop
create or alter trigger trigger_sua_sinh_vien
on sinh_vien
after update
as
begin
	declare @ma_lop_cu int = (select ma_lop from deleted)
	update lop
	set so_luong_sinh_vien = so_luong_sinh_vien - 1
	where ma = @ma_lop_cu

	declare @ma_lop_moi int = (select ma_lop from inserted)
	update lop
	set so_luong_sinh_vien = so_luong_sinh_vien + 1
	where ma = @ma_lop_moi

	select * from lop
	where ma = @ma_lop_cu
	select * from lop
	where ma = @ma_lop_moi
	select * from deleted
	select * from inserted
end

update sinh_vien
set ma_lop = 2
where ma = 4

--Trigger them nhieu sinh vien
drop trigger trigger_them_nhieu_sinh_vien
create or alter trigger trigger_them_nhieu_sinh_vien		--đếm số sv theo mã lớp cout(sv) group by(ma_lop)
on sinh_vien
after insert
as
begin
	update lop
	set 
		so_luong_sinh_vien = so_luong_sinh_vien + i.so_luong_sinh_vien_moi
	from lop  
	join (select ma_lop, count (*) as so_luong_sinh_vien_moi from inserted 
	group by ma_lop ) as i		
	on lop.ma = i.ma_lop
	
	select * from lop
	select * from sinh_vien
end

insert into sinh_vien(ten, ma_lop)
values (N'Cường',2),(N'Mạnh',2)

--Trigger xoá nhiều sinh viên
Create or alter trigger trigger_xoa_nhieu_sinh_vien
on sinh_vien
after delete
as
begin
	update lop
	set 
		so_luong_sinh_vien = so_luong_sinh_vien - d.so_luong_sinh_vien_moi
	from lop  
	join (select ma_lop, count (*) as so_luong_sinh_vien_moi from deleted 
	group by ma_lop ) as d		
	on lop.ma = d.ma_lop
	
	select * from lop
	select * from sinh_vien
end

delete from sinh_vien
where ma_lop =2


--Trigger update nhiều sinh viên
create or alter trigger trigger_update_nhieu_sinh_vien
on sinh_vien
after update
as
begin
	update lop
		set 
		so_luong_sinh_vien = so_luong_sinh_vien - d.so_luong_sinh_vien_moi
	from lop  
	join (select ma_lop, count (*) as so_luong_sinh_vien_moi from deleted 
	group by ma_lop ) as d		
	on lop.ma = d.ma_lop

	update lop
	set 
		so_luong_sinh_vien = so_luong_sinh_vien + i.so_luong_sinh_vien_moi
	from lop  
	join (select ma_lop, count (*) as so_luong_sinh_vien_moi from inserted 
	group by ma_lop ) as i		
	on lop.ma = i.ma_lop
end