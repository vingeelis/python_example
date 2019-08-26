
use chekawa;

-- dict_temple
drop table if exists meta_temple;
create table if not exists meta_temple (
	uid int unsigned auto_increment not null comment '登录ID',
	zj enum('佛教') default '佛教' comment '宗教',
	pb enum('汉语系', '藏语系', '巴利语系') comment '派别',
	temple_name_cn char(92) comment '寺院名中文名',
	principal char(47) comment '负责人姓名',
	rec_create_date datetime default CURRENT_TIMESTAMP comment '记录创建时间',
	rec_update_date datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP comment '记录更新时间',
	location varchar(302) comment '地址',
	PRIMARY KEY (uid),
	UNIQUE KEY uni_key(temple_name_cn, location)
);

-- tab_temple
drop table if exists tab_temple;
create table if not exists tab_temple (
	uid int unsigned auto_increment not null comment '登录ID',
	login_password varchar(120) comment '登录密码',
	mobile_num varchar(15) comment '手机号',
	phone_num varchar(20) comment '座机号',
	temple_name_tibetan VARCHAR(150) comment '寺院名藏文名',
	location_reg_cert varchar(200) comment '宗教场所登记证',
	bank_account_license varchar(200) comment '寺院银行开户许可证',
	manager_idcard varchar(200) comment '寺院管理委员会主任身份证',
	other_cert varchar(200) comment '其他附加证明资料',
	check_status enum ('passed', 'failed', 'checking') comment '审核状态',
	PRIMARY KEY (uid)
);
