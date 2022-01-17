use quan_ly_sinh_vien

--Tạo bảng lưu thông tin điểm của sinh viên (mã, họ tên, điểm lần 1, điểm lần 2)
create table diem_sinh_vien(
ma int primary key identity(1,1),
ho_ten nvarchar(50) not null,
diem_lan1 float,
diem_lan2 float
)

--điểm không được phép nhỏ hơn 0 và lớn hơn 10
alter table diem_sinh_vien
add constraint CK_diem
check  (diem_lan1 >=0 and diem_lan2 >= 0 and diem_lan1 <= 10 and diem_lan2 <= 10)

--điểm lần 1 nếu không nhập mặc định sẽ là 5
alter table diem_sinh_vien
add constraint DF_diem_lan1
default 5 for diem_lan1

--(*) điểm lần 2 không được nhập khi mà điểm lần 1 lớn hơn hoặc bằng 5
alter table diem_sinh_vien
add constraint CK_diem_lan2
check ((diem_lan1 >= 5 and diem_lan2 is null) or diem_lan1 <= 5)

ALTER TABLE diem_sinh_vien
DROP CONSTRAINT CK_diem_lan2

--(**) tên không được phép ngắn hơn 2 ký tự
alter table diem_sinh_vien
add constraint CK_ten
Check (len(ho_ten) > 2 )

--Điền 5 sinh viên kèm điểm
insert into diem_sinh_vien(ho_ten, diem_lan1, diem_lan2)
values('Quang', 6, null),
		('Nam', 4, 4),
		(N'Anh', 3, 6),
		(N'Mạnh', 7,null),
		('Mai', 4,4)

select * from diem_sinh_vien

--Lấy ra các bạn điểm lần 1 hoặc lần 2 lớn hơn 5
select * from diem_sinh_vien
where diem_lan1 >= 5 or diem_lan2 >= 5

--Lấy ra các bạn qua môn ngay từ lần 1
select * from diem_sinh_vien
where diem_lan1 >=5

--Lấy ra các bạn trượt môn
select * from diem_sinh_vien
where diem_lan1 <5 and diem_lan2 < 5

--(*) Đếm số bạn qua môn sau khi thi 2 lần 
select COUNT(*)
from diem_sinh_vien
where diem_lan1 >= 5 or diem_lan2 >= 5

--(*) Đếm số bạn trượt lần 1 nhưng qua môn lần 2
select COUNT(*) as 'so_ban_truot_lan1_nhung_qua_mon_lan2'
from diem_sinh_vien
where diem_lan2 >= 5

--(**) Đếm số bạn cần phải thi lần 2 (tức là thi lần 1 chưa qua nhưng chưa nhập điểm lần 2)
select COUNT(*) 
from diem_sinh_vien
where diem_lan1 < 5 and diem_lan2 is null

drop table diem_sinh_vien