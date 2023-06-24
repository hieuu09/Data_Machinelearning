create database moi
go
use moi
go
create table moi
(
	stt int primary key,
	hoten nvarchar(50) not null,
	masv varchar(20) not null,
	lop varchar(20) not null,
	diemtb float not null
)
go
-- truong hop 2
alter table dbo.moi add primary key(stt)

create table moi22
(
	stt int not null,
	hoten nvarchar(30) not null,
	lop nvarchar(20) not null,
	diemtb float not null
)
go
alter table dbo.moi22 add constraint pk_3 primary key(stt) --de sau yeu cau de not null 

-- xao khoa chinh 
-- tao khoa ngoai
-- xac dinh giao vien nay thuoc bo mon nao
-- bo mon cos max bo mon , giao vien co ma bomon khoa ngoai, phai cung kieu du lieu
--dieu kien tao khoa ngoai, tham chieu toi khoa chinh, cung so luong truong co sap xep
--dam boa toan ven du lieu , khoong co truong hop tham chieu den du lieuj khong ton tai
create table giaovien
(
	magv varchar(10) not null,
	name nvarchar(20) not null,
	diachi nvarchar(30) not null,
	Ngaysinh date not null,
	sex bit not null,
	mabm varchar(10) not null
)
go
alter table giaovien add constraint pk_giaovien primary key(magv)
go

create table bomon
(
	magv char(10) not null,
	tenbm nvarchar(40) not null,
	mabm varchar(10) not null
)
go
alter table bomon add constraint ok_bomon primary key(mabm)
go 

alter table dbo.giaovien add constraint fr_key foreign key(mabm) references dbo.bomon(mabm)
go

-- huye khoa 
alter table dbo.giaovien drop constraint fr_key
go


drop table dbo.giaovien
drop table dbo.bomon




insert dbo.moi(stt, hoten,masv,lop,diemtb) values (56,N'Nguyễn văn anh','122','CQ6778',5.7)
go
insert dbo.moi(stt, hoten,masv,lop,diemtb) values (543,N'Nguyễn văn anh','8543hie','C32',10)
go
insert dbo.moi(stt, hoten,masv,lop,diemtb) values (34,N'Nguyễn văn anh','34545','CQhj',9.5)
go
insert dbo.moi(stt, hoten,masv,lop,diemtb) values (2334,N'Nguyễn văn anh','87543','CQ76',8.8)
go


select *from dbo.moi
go

-- delecte xoa toan bo du lie , co thedung where
-- cap nhta du lieu update moi set tienluong=10 where hoten=N'nam'

-- khoa ngoia

-- xao du lieu khong co dieu kien, xoa toan bo du lieu trong bang 
delete dbo.bomon
go


-- tao bang moi casc record tuong ung , tao ra mot bang moi
-- khong co dau # trc into thi can phai co cas truong tuong uwngx 
select *into bangmoi from dbo.bomon 
go
-- insert into select copy bang da ton tai : ten bang moi sau insert into xong 
--select from ten bang co san de copy vao 
insert into bangmoi select *from  dbo.bomon 
go

select *from bangmoi
go

--group by  su dung agreeafunction
