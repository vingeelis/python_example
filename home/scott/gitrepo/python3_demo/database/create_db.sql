-- database
drop database if exists chekawa;
create database if not exists chekawa default charset utf8 collate utf8_general_ci;


-- user: admin
drop user if exists 'chekawa_admin'@'%';
create user if not exists 'chekawa_admin'@'%' identified with mysql_native_password by 'chekawa_admin';
grant all on chekawa.* to 'chekawa_admin'@'%';
-- mysql如果想要有into oufile 或者 load data infile 操作，必须授予file权限，而这个权限不能针对某个表，或库授予，是针对*.*的用户授予的, 使用show grants for 命令查看权限
grant file on *.* to 'chekawa_admin'@'%';


-- user: user
drop user if exists 'chekawa_user'@'%';
create user if not exists 'chekawa_admin'@'%' identified with mysql_native_password by 'chekawa_admin';
grant select on chekawa.* to 'chekawa_admin'@'%';
