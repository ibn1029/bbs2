--
-- BBS
--

-- Create Database
create database bbs character set utf8;

-- Create User
use mysql;

create user bbs@localhost identified by 'bbs00';
grant select, insert, update, delete, references  on bbs.* to bbs@localhost;
flush privileges;
create user bbs@"%" identified by 'bbs00';
grant select, insert, update, delete, references  on bbs.* to bbs@"%";
flush privileges;


-- Create Table
use bbs;
create table entry (
  entry_id     int(8) not null primary key auto_increment
  , `user`     varchar(40) not null       
  , body       varchar(255) not null 
  , created_at datetime not null
) engine=innoDB default charset=utf8 comment='エントリー';


