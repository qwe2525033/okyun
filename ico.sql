/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50547
Source Host           : localhost:3306
Source Database       : bitreas

Target Server Type    : MYSQL
Target Server Version : 50547
File Encoding         : 65001

Date: 2017-05-26 15:29:43
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `os_admin_user`
-- ----------------------------
DROP TABLE IF EXISTS `os_admin_user`;
CREATE TABLE `os_admin_user` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL DEFAULT '' COMMENT '管理员用户名',
  `password` varchar(50) NOT NULL DEFAULT '' COMMENT '管理员密码',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1 启用 0 禁用',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(20) DEFAULT NULL COMMENT '最后登录IP',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='管理员表';

-- ----------------------------
-- Records of os_admin_user
-- ----------------------------
INSERT INTO os_admin_user VALUES ('1', 'admin', '0dfc7612f607db6c17fd99388e9e5f9c', '1', '2016-10-18 15:28:37', '2017-05-26 15:20:53', '127.0.0.1');

-- ----------------------------
-- Table structure for `os_article`
-- ----------------------------
DROP TABLE IF EXISTS `os_article`;
CREATE TABLE `os_article` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `cid` smallint(5) unsigned NOT NULL COMMENT '分类ID',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '标题',
  `introduction` varchar(255) DEFAULT '' COMMENT '简介',
  `content` longtext COMMENT '内容',
  `author` varchar(20) DEFAULT '' COMMENT '作者',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态 0 待审核  1 审核',
  `reading` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '阅读量',
  `thumb` varchar(255) DEFAULT '' COMMENT '缩略图',
  `photo` text COMMENT '图集',
  `is_top` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否置顶  0 不置顶  1 置顶',
  `is_recommend` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否推荐  0 不推荐  1 推荐',
  `sort` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `publish_time` datetime NOT NULL COMMENT '发布时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='文章表';

-- ----------------------------
-- Records of os_article
-- ----------------------------
INSERT INTO os_article VALUES ('1', '1', '测试文章一', '', '<p>测试内容</p>', 'admin', '1', '0', '', null, '0', '0', '0', '2017-04-11 14:10:10', '2017-04-11 14:09:45');

-- ----------------------------
-- Table structure for `os_auth_group`
-- ----------------------------
DROP TABLE IF EXISTS `os_auth_group`;
CREATE TABLE `os_auth_group` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `title` char(100) NOT NULL DEFAULT '',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `rules` varchar(255) NOT NULL COMMENT '权限规则ID',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='权限组表';

-- ----------------------------
-- Records of os_auth_group
-- ----------------------------
INSERT INTO os_auth_group VALUES ('1', '超级管理组', '1', '1,2,3,73,74,5,6,7,8,9,10,11,12,39,40,41,42,43,14,13,20,21,22,23,24,15,25,26,27,28,29,30,16,17,44,45,46,47,48,18,49,50,51,52,53,19,31,32,33,34,35,36,37,54,55,58,59,60,61,62,56,63,64,65,66,67,57,68,69,70,71,72,75,76,77,78,79,80,81,82');

-- ----------------------------
-- Table structure for `os_auth_group_access`
-- ----------------------------
DROP TABLE IF EXISTS `os_auth_group_access`;
CREATE TABLE `os_auth_group_access` (
  `uid` mediumint(8) unsigned NOT NULL,
  `group_id` mediumint(8) unsigned NOT NULL,
  UNIQUE KEY `uid_group_id` (`uid`,`group_id`),
  KEY `uid` (`uid`),
  KEY `group_id` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='权限组规则表';

-- ----------------------------
-- Records of os_auth_group_access
-- ----------------------------
INSERT INTO os_auth_group_access VALUES ('1', '1');

-- ----------------------------
-- Table structure for `os_auth_rule`
-- ----------------------------
DROP TABLE IF EXISTS `os_auth_rule`;
CREATE TABLE `os_auth_rule` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL DEFAULT '' COMMENT '规则名称',
  `title` varchar(20) NOT NULL,
  `type` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `pid` smallint(5) unsigned NOT NULL COMMENT '父级ID',
  `icon` varchar(50) DEFAULT '' COMMENT '图标',
  `sort` tinyint(4) unsigned NOT NULL COMMENT '排序',
  `condition` char(100) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=87 DEFAULT CHARSET=utf8 COMMENT='规则表';

-- ----------------------------
-- Records of os_auth_rule
-- ----------------------------
INSERT INTO os_auth_rule VALUES ('1', 'admin/System/default', '系统配置', '1', '1', '0', 'fa fa-gears', '0', '');
INSERT INTO os_auth_rule VALUES ('2', 'admin/System/siteConfig', '站点配置', '1', '1', '1', '', '0', '');
INSERT INTO os_auth_rule VALUES ('3', 'admin/System/updateSiteConfig', '更新配置', '1', '0', '1', '', '0', '');
INSERT INTO os_auth_rule VALUES ('5', 'admin/Menu/default', '菜单管理', '1', '1', '0', 'fa fa-bars', '0', '');
INSERT INTO os_auth_rule VALUES ('6', 'admin/Menu/index', '后台菜单', '1', '1', '5', '', '0', '');
INSERT INTO os_auth_rule VALUES ('7', 'admin/Menu/add', '添加菜单', '1', '0', '6', '', '0', '');
INSERT INTO os_auth_rule VALUES ('8', 'admin/Menu/save', '保存菜单', '1', '0', '6', '', '0', '');
INSERT INTO os_auth_rule VALUES ('9', 'admin/Menu/edit', '编辑菜单', '1', '0', '6', '', '0', '');
INSERT INTO os_auth_rule VALUES ('10', 'admin/Menu/update', '更新菜单', '1', '0', '6', '', '0', '');
INSERT INTO os_auth_rule VALUES ('11', 'admin/Menu/delete', '删除菜单', '1', '0', '6', '', '0', '');
INSERT INTO os_auth_rule VALUES ('12', 'admin/Nav/index', '导航管理', '1', '1', '5', '', '0', '');
INSERT INTO os_auth_rule VALUES ('13', 'admin/Category/index', '栏目管理', '1', '1', '14', 'fa fa-sitemap', '0', '');
INSERT INTO os_auth_rule VALUES ('14', 'admin/Content/default', '内容管理', '1', '1', '0', 'fa fa-file-text', '0', '');
INSERT INTO os_auth_rule VALUES ('15', 'admin/Article/index', '文章管理', '1', '1', '14', '', '0', '');
INSERT INTO os_auth_rule VALUES ('16', 'admin/User/default', '用户管理', '1', '1', '0', 'fa fa-users', '0', '');
INSERT INTO os_auth_rule VALUES ('17', 'admin/User/index', '普通用户', '1', '1', '16', '', '0', '');
INSERT INTO os_auth_rule VALUES ('18', 'admin/AdminUser/index', '管理员', '1', '1', '16', '', '0', '');
INSERT INTO os_auth_rule VALUES ('19', 'admin/AuthGroup/index', '权限组', '1', '1', '16', '', '0', '');
INSERT INTO os_auth_rule VALUES ('20', 'admin/Category/add', '添加栏目', '1', '0', '13', '', '0', '');
INSERT INTO os_auth_rule VALUES ('21', 'admin/Category/save', '保存栏目', '1', '0', '13', '', '0', '');
INSERT INTO os_auth_rule VALUES ('22', 'admin/Category/edit', '编辑栏目', '1', '0', '13', '', '0', '');
INSERT INTO os_auth_rule VALUES ('23', 'admin/Category/update', '更新栏目', '1', '0', '13', '', '0', '');
INSERT INTO os_auth_rule VALUES ('24', 'admin/Category/delete', '删除栏目', '1', '0', '13', '', '0', '');
INSERT INTO os_auth_rule VALUES ('25', 'admin/Article/add', '添加文章', '1', '0', '15', '', '0', '');
INSERT INTO os_auth_rule VALUES ('26', 'admin/Article/save', '保存文章', '1', '0', '15', '', '0', '');
INSERT INTO os_auth_rule VALUES ('27', 'admin/Article/edit', '编辑文章', '1', '0', '15', '', '0', '');
INSERT INTO os_auth_rule VALUES ('28', 'admin/Article/update', '更新文章', '1', '0', '15', '', '0', '');
INSERT INTO os_auth_rule VALUES ('29', 'admin/Article/delete', '删除文章', '1', '0', '15', '', '0', '');
INSERT INTO os_auth_rule VALUES ('30', 'admin/Article/toggle', '文章审核', '1', '0', '15', '', '0', '');
INSERT INTO os_auth_rule VALUES ('31', 'admin/AuthGroup/add', '添加权限组', '1', '0', '19', '', '0', '');
INSERT INTO os_auth_rule VALUES ('32', 'admin/AuthGroup/save', '保存权限组', '1', '0', '19', '', '0', '');
INSERT INTO os_auth_rule VALUES ('33', 'admin/AuthGroup/edit', '编辑权限组', '1', '0', '19', '', '0', '');
INSERT INTO os_auth_rule VALUES ('34', 'admin/AuthGroup/update', '更新权限组', '1', '0', '19', '', '0', '');
INSERT INTO os_auth_rule VALUES ('35', 'admin/AuthGroup/delete', '删除权限组', '1', '0', '19', '', '0', '');
INSERT INTO os_auth_rule VALUES ('36', 'admin/AuthGroup/auth', '授权', '1', '0', '19', '', '0', '');
INSERT INTO os_auth_rule VALUES ('37', 'admin/AuthGroup/updateAuthGroupRule', '更新权限组规则', '1', '0', '19', '', '0', '');
INSERT INTO os_auth_rule VALUES ('39', 'admin/Nav/add', '添加导航', '1', '0', '12', '', '0', '');
INSERT INTO os_auth_rule VALUES ('40', 'admin/Nav/save', '保存导航', '1', '0', '12', '', '0', '');
INSERT INTO os_auth_rule VALUES ('41', 'admin/Nav/edit', '编辑导航', '1', '0', '12', '', '0', '');
INSERT INTO os_auth_rule VALUES ('42', 'admin/Nav/update', '更新导航', '1', '0', '12', '', '0', '');
INSERT INTO os_auth_rule VALUES ('43', 'admin/Nav/delete', '删除导航', '1', '0', '12', '', '0', '');
INSERT INTO os_auth_rule VALUES ('44', 'admin/User/add', '添加用户', '1', '0', '17', '', '0', '');
INSERT INTO os_auth_rule VALUES ('45', 'admin/User/save', '保存用户', '1', '0', '17', '', '0', '');
INSERT INTO os_auth_rule VALUES ('46', 'admin/User/edit', '编辑用户', '1', '0', '17', '', '0', '');
INSERT INTO os_auth_rule VALUES ('47', 'admin/User/update', '更新用户', '1', '0', '17', '', '0', '');
INSERT INTO os_auth_rule VALUES ('48', 'admin/User/delete', '删除用户', '1', '0', '17', '', '0', '');
INSERT INTO os_auth_rule VALUES ('49', 'admin/AdminUser/add', '添加管理员', '1', '0', '18', '', '0', '');
INSERT INTO os_auth_rule VALUES ('50', 'admin/AdminUser/save', '保存管理员', '1', '0', '18', '', '0', '');
INSERT INTO os_auth_rule VALUES ('51', 'admin/AdminUser/edit', '编辑管理员', '1', '0', '18', '', '0', '');
INSERT INTO os_auth_rule VALUES ('52', 'admin/AdminUser/update', '更新管理员', '1', '0', '18', '', '0', '');
INSERT INTO os_auth_rule VALUES ('53', 'admin/AdminUser/delete', '删除管理员', '1', '0', '18', '', '0', '');
INSERT INTO os_auth_rule VALUES ('54', 'admin/Slide/default', '扩展管理', '1', '1', '0', 'fa fa-wrench', '0', '');
INSERT INTO os_auth_rule VALUES ('55', 'admin/SlideCategory/index', '轮播分类', '1', '1', '54', '', '0', '');
INSERT INTO os_auth_rule VALUES ('56', 'admin/Slide/index', '轮播图管理', '1', '1', '54', '', '0', '');
INSERT INTO os_auth_rule VALUES ('57', 'admin/Link/index', '友情链接', '1', '1', '54', 'fa fa-link', '0', '');
INSERT INTO os_auth_rule VALUES ('58', 'admin/SlideCategory/add', '添加分类', '1', '0', '55', '', '0', '');
INSERT INTO os_auth_rule VALUES ('59', 'admin/SlideCategory/save', '保存分类', '1', '0', '55', '', '0', '');
INSERT INTO os_auth_rule VALUES ('60', 'admin/SlideCategory/edit', '编辑分类', '1', '0', '55', '', '0', '');
INSERT INTO os_auth_rule VALUES ('61', 'admin/SlideCategory/update', '更新分类', '1', '0', '55', '', '0', '');
INSERT INTO os_auth_rule VALUES ('62', 'admin/SlideCategory/delete', '删除分类', '1', '0', '55', '', '0', '');
INSERT INTO os_auth_rule VALUES ('63', 'admin/Slide/add', '添加轮播', '1', '0', '56', '', '0', '');
INSERT INTO os_auth_rule VALUES ('64', 'admin/Slide/save', '保存轮播', '1', '0', '56', '', '0', '');
INSERT INTO os_auth_rule VALUES ('65', 'admin/Slide/edit', '编辑轮播', '1', '0', '56', '', '0', '');
INSERT INTO os_auth_rule VALUES ('66', 'admin/Slide/update', '更新轮播', '1', '0', '56', '', '0', '');
INSERT INTO os_auth_rule VALUES ('67', 'admin/Slide/delete', '删除轮播', '1', '0', '56', '', '0', '');
INSERT INTO os_auth_rule VALUES ('68', 'admin/Link/add', '添加链接', '1', '0', '57', '', '0', '');
INSERT INTO os_auth_rule VALUES ('69', 'admin/Link/save', '保存链接', '1', '0', '57', '', '0', '');
INSERT INTO os_auth_rule VALUES ('70', 'admin/Link/edit', '编辑链接', '1', '0', '57', '', '0', '');
INSERT INTO os_auth_rule VALUES ('71', 'admin/Link/update', '更新链接', '1', '0', '57', '', '0', '');
INSERT INTO os_auth_rule VALUES ('72', 'admin/Link/delete', '删除链接', '1', '0', '57', '', '0', '');
INSERT INTO os_auth_rule VALUES ('73', 'admin/ChangePassword/index', '修改密码', '1', '1', '1', '', '0', '');
INSERT INTO os_auth_rule VALUES ('74', 'admin/ChangePassword/updatePassword', '更新密码', '1', '0', '1', '', '0', '');
INSERT INTO os_auth_rule VALUES ('75', 'admin/coin/default', '钱包管理', '1', '1', '0', 'fa fa-bitcoin', '0', '');
INSERT INTO os_auth_rule VALUES ('76', 'admin/coin/index', '钱包配置', '1', '1', '75', '', '1', '');
INSERT INTO os_auth_rule VALUES ('77', 'admin/coin/add', '添加钱包', '1', '0', '76', '', '0', '');
INSERT INTO os_auth_rule VALUES ('78', 'admin/coin/save', '保存钱包', '1', '0', '76', '', '0', '');
INSERT INTO os_auth_rule VALUES ('79', 'admin/coin/edit', '编辑钱包', '1', '0', '76', '', '0', '');
INSERT INTO os_auth_rule VALUES ('80', 'admin/coin/update', '更新钱包', '1', '0', '76', '', '0', '');
INSERT INTO os_auth_rule VALUES ('81', 'admin/coin/disable', '禁用钱包', '1', '0', '76', '', '0', '');
INSERT INTO os_auth_rule VALUES ('82', 'admin/coin/enable', '启用钱包', '1', '0', '76', '', '0', '');
INSERT INTO os_auth_rule VALUES ('83', 'admin/coin/recharge', '虚拟币转入', '1', '1', '75', '', '0', '');
INSERT INTO os_auth_rule VALUES ('84', 'admin/coin/withdraw', '虚拟币转出', '1', '1', '75', '', '0', '');
INSERT INTO os_auth_rule VALUES ('85', 'admin/coin/recharge_update', '手动确认', '1', '0', '83', '', '0', '');
INSERT INTO os_auth_rule VALUES ('86', 'admin/coin/withdrae_update', '审核转出', '1', '0', '84', '', '0', '');

-- ----------------------------
-- Table structure for `os_category`
-- ----------------------------
DROP TABLE IF EXISTS `os_category`;
CREATE TABLE `os_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `alias` varchar(50) DEFAULT '' COMMENT '导航别名',
  `content` longtext COMMENT '分类内容',
  `thumb` varchar(255) DEFAULT '' COMMENT '缩略图',
  `icon` varchar(20) DEFAULT '' COMMENT '分类图标',
  `list_template` varchar(50) DEFAULT '' COMMENT '分类列表模板',
  `detail_template` varchar(50) DEFAULT '' COMMENT '分类详情模板',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '分类类型  1  列表  2 单页',
  `sort` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `pid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '上级分类ID',
  `path` varchar(255) DEFAULT '' COMMENT '路径',
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='分类表';

-- ----------------------------
-- Records of os_category
-- ----------------------------
INSERT INTO os_category VALUES ('1', '分类一', '', '', '', '', '', '', '1', '0', '0', '0,', '2016-12-22 18:22:24');

-- ----------------------------
-- Table structure for `os_coin`
-- ----------------------------
DROP TABLE IF EXISTS `os_coin`;
CREATE TABLE `os_coin` (
  `id` int(14) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '钱包缩写名',
  `type` varchar(10) NOT NULL DEFAULT 'btc' COMMENT '钱包类型',
  `title_cn` varchar(100) NOT NULL COMMENT '钱包中文名',
  `title_en` varchar(100) NOT NULL COMMENT '钱包英文名',
  `symbol` char(5) NOT NULL COMMENT '钱包符号',
  `thumb` varchar(100) NOT NULL COMMENT '钱包图标地址',
  `rpc_host` varchar(100) NOT NULL COMMENT 'RPC服务器地址',
  `rpc_port` varchar(5) NOT NULL COMMENT 'RPC服务器端口',
  `rpc_username` varchar(100) DEFAULT NULL COMMENT 'RPC用户名',
  `rpc_password` varchar(100) DEFAULT NULL COMMENT 'RPC密码',
  `wallet_password` varchar(100) DEFAULT NULL COMMENT '钱包密码',
  `cold_wallet_address` varchar(100) DEFAULT NULL COMMENT '冷钱包地址',
  `cold_wallet_num` decimal(20,8) DEFAULT '0.00000000' COMMENT '冷钱包转出数量',
  `min_withdraw` decimal(20,8) DEFAULT NULL COMMENT '最小转出金额',
  `auto_withdraw` decimal(20,8) DEFAULT '0.00000000' COMMENT '自动提现金额，0为不开启自动转出',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '状态',
  `withdraw_fee` decimal(20,8) NOT NULL DEFAULT '0.00100000' COMMENT '转出手续费',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of os_coin
-- ----------------------------
INSERT INTO os_coin VALUES ('1', 'btc', 'btc', '比特币', 'bitcoin', 'B', '/uploads/20170501/804e6b63bb608452bb18a5547af3c991.png', '127.0.0.1', '19933', 'user', 'password', '', '0', '0.00000000', null, '0.00000000', '1', '0.00100000');
INSERT INTO os_coin VALUES ('2', 'doge', 'btc', '狗狗币', 'dogecoin', 'D', '/uploads/20170502/3e78f79802f960b46c98b0bac8ffd1fb.png', '127.0.0.1', '8123', '', '', '', '0', '0.00000000', null, '0.00000000', '1', '0.00100000');
INSERT INTO os_coin VALUES ('3', 'eth', 'eth', '以太坊', 'ethereum', 'E', '/uploads/20170504/e5a425acbb0505033b33e21e268ffa02.png', '127.0.0.1', '8545', '', '', '', '0', '0.00000000', '0.00000000', '0.00000000', '1', '0.00100000');

-- ----------------------------
-- Table structure for `os_link`
-- ----------------------------
DROP TABLE IF EXISTS `os_link`;
CREATE TABLE `os_link` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL DEFAULT '' COMMENT '链接名称',
  `link` varchar(255) DEFAULT '' COMMENT '链接地址',
  `image` varchar(255) DEFAULT '' COMMENT '链接图片',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态 1 显示  2 隐藏',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='友情链接表';

-- ----------------------------
-- Records of os_link
-- ----------------------------

-- ----------------------------
-- Table structure for `os_nav`
-- ----------------------------
DROP TABLE IF EXISTS `os_nav`;
CREATE TABLE `os_nav` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(10) unsigned NOT NULL COMMENT '父ID',
  `name` varchar(20) NOT NULL COMMENT '导航名称',
  `alias` varchar(20) DEFAULT '' COMMENT '导航别称',
  `link` varchar(255) DEFAULT '' COMMENT '导航链接',
  `icon` varchar(255) DEFAULT '' COMMENT '导航图标',
  `target` varchar(10) DEFAULT '' COMMENT '打开方式',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态  0 隐藏  1 显示',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='导航表';

-- ----------------------------
-- Records of os_nav
-- ----------------------------

-- ----------------------------
-- Table structure for `os_slide`
-- ----------------------------
DROP TABLE IF EXISTS `os_slide`;
CREATE TABLE `os_slide` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cid` int(10) unsigned NOT NULL COMMENT '分类ID',
  `name` varchar(50) NOT NULL COMMENT '轮播图名称',
  `description` varchar(255) DEFAULT '' COMMENT '说明',
  `link` varchar(255) DEFAULT '' COMMENT '链接',
  `target` varchar(10) DEFAULT '' COMMENT '打开方式',
  `image` varchar(255) DEFAULT '' COMMENT '轮播图片',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '状态  1 显示  0  隐藏',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='轮播图表';

-- ----------------------------
-- Records of os_slide
-- ----------------------------

-- ----------------------------
-- Table structure for `os_slide_category`
-- ----------------------------
DROP TABLE IF EXISTS `os_slide_category`;
CREATE TABLE `os_slide_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '轮播图分类',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='轮播图分类表';

-- ----------------------------
-- Records of os_slide_category
-- ----------------------------
INSERT INTO os_slide_category VALUES ('1', '首页轮播');

-- ----------------------------
-- Table structure for `os_system`
-- ----------------------------
DROP TABLE IF EXISTS `os_system`;
CREATE TABLE `os_system` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '配置项名称',
  `value` text NOT NULL COMMENT '配置项值',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='系统配置表';

-- ----------------------------
-- Records of os_system
-- ----------------------------
INSERT INTO os_system VALUES ('1', 'site_config', 'a:7:{s:10:\"site_title\";s:30:\"Think Admin 后台管理系统\";s:9:\"seo_title\";s:30:\"Think Admin 后台管理系统\";s:11:\"seo_keyword\";s:30:\"Think Admin 后台管理系统\";s:15:\"seo_description\";s:30:\"Think Admin 后台管理系统\";s:14:\"site_copyright\";s:30:\"Think Admin 后台管理系统\";s:8:\"site_icp\";s:30:\"Think Admin 后台管理系统\";s:11:\"site_tongji\";s:30:\"Think Admin 后台管理系统\";}');

-- ----------------------------
-- Table structure for `os_user`
-- ----------------------------
DROP TABLE IF EXISTS `os_user`;
CREATE TABLE `os_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(50) NOT NULL COMMENT '密码',
  `mobile` varchar(11) DEFAULT '' COMMENT '手机',
  `email` varchar(50) DEFAULT '' COMMENT '邮箱',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '用户状态  1 正常  2 禁止',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登陆时间',
  `last_login_ip` varchar(50) DEFAULT '' COMMENT '最后登录IP',
  `sign_ip` varchar(50) DEFAULT '' COMMENT '注册IP',
  `google_authenticator` varchar(100) DEFAULT '' COMMENT '谷歌验证',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of os_user
-- ----------------------------
INSERT INTO os_user VALUES ('3', 'qwe2525033', '7b79e788e94c1c41b6d4e1b1280c4bdb', '', '123456@qq.com', '1', '2017-05-01 22:11:52', '2017-05-26 15:22:21', '127.0.0.1', '127.0.0.1', '{\"secret\":\"XFL4OVZGDDQCFZTA\",\"loginStatus\":\"1\",\"withdrawStatus\":\"1\"}');

-- ----------------------------
-- Table structure for `os_user_coin`
-- ----------------------------
DROP TABLE IF EXISTS `os_user_coin`;
CREATE TABLE `os_user_coin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL COMMENT '用户id',
  `coinname` varchar(100) NOT NULL COMMENT '币种名称 - coin表中的name',
  `available` decimal(20,8) NOT NULL DEFAULT '0.00000000' COMMENT '可用余额',
  `frozen` decimal(20,8) NOT NULL DEFAULT '0.00000000' COMMENT '冻结余额',
  `address` varchar(100) NOT NULL DEFAULT '' COMMENT '钱包地址',
  `password` varchar(255) DEFAULT NULL COMMENT '钱包密码',
  `private_key` varchar(255) DEFAULT NULL COMMENT '钱包私钥',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of os_user_coin
-- ----------------------------
INSERT INTO os_user_coin VALUES ('1', '3', 'btc', '202542858.78146790', '0.00000000', 'DNpLKuo1GZFSmxvuDCjN5H6TQQSMrHiJ3a', null, null);

-- ----------------------------
-- Table structure for `os_user_login_log`
-- ----------------------------
DROP TABLE IF EXISTS `os_user_login_log`;
CREATE TABLE `os_user_login_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL COMMENT '用户id',
  `login_time` datetime NOT NULL COMMENT '登陆时间',
  `login_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '登陆状态',
  `login_ip` varchar(50) NOT NULL COMMENT '登陆IP',
  `login_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '登陆类型 0 为登陆 1为注销',
  `login_device` varchar(100) DEFAULT NULL COMMENT '登陆设备',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of os_user_login_log
-- ----------------------------
INSERT INTO os_user_login_log VALUES ('1', '3', '2017-05-02 09:32:11', '1', '127.0.0.1', '0', null);
INSERT INTO os_user_login_log VALUES ('2', '3', '2017-05-02 09:34:45', '1', '127.0.0.1', '1', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Saf');
INSERT INTO os_user_login_log VALUES ('3', '3', '2017-05-02 09:35:15', '1', '127.0.0.1', '0', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Saf');
INSERT INTO os_user_login_log VALUES ('4', '3', '2017-05-02 09:35:27', '1', '127.0.0.1', '1', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Saf');
INSERT INTO os_user_login_log VALUES ('5', '3', '2017-05-02 09:36:32', '0', '127.0.0.1', '0', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Saf');
INSERT INTO os_user_login_log VALUES ('6', '3', '2017-05-02 09:36:41', '1', '127.0.0.1', '0', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Saf');
INSERT INTO os_user_login_log VALUES ('7', '3', '2017-05-02 10:12:34', '1', '127.0.0.1', '0', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Saf');
INSERT INTO os_user_login_log VALUES ('8', '3', '2017-05-02 10:24:52', '1', '127.0.0.1', '0', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Saf');
INSERT INTO os_user_login_log VALUES ('9', '3', '2017-05-02 15:28:56', '1', '192.168.2.146', '0', 'Mozilla/5.0 (Linux; U; Android 7.0; zh-CN; MI 5 Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko)');
INSERT INTO os_user_login_log VALUES ('10', '3', '2017-05-02 15:58:20', '1', '192.168.1.113', '0', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Saf');
INSERT INTO os_user_login_log VALUES ('11', '3', '2017-05-03 08:55:15', '1', '127.0.0.1', '0', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Saf');
INSERT INTO os_user_login_log VALUES ('12', '3', '2017-05-04 11:44:39', '1', '127.0.0.1', '0', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Saf');
INSERT INTO os_user_login_log VALUES ('13', '3', '2017-05-26 15:22:21', '1', '127.0.0.1', '0', 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Saf');

-- ----------------------------
-- Table structure for `os_user_recharge`
-- ----------------------------
DROP TABLE IF EXISTS `os_user_recharge`;
CREATE TABLE `os_user_recharge` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL COMMENT '用户ID',
  `coinname` varchar(50) NOT NULL COMMENT '转入币种名',
  `address` varchar(100) NOT NULL COMMENT '转入地址',
  `amount` decimal(20,8) NOT NULL COMMENT '转入金额',
  `txid` varchar(255) DEFAULT NULL COMMENT '转入交易hash',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '转入状态',
  `create_time` datetime NOT NULL COMMENT '转入时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of os_user_recharge
-- ----------------------------
INSERT INTO os_user_recharge VALUES ('3', '3', 'btc', '123123', '1.00000000', null, '0', '2017-05-03 10:16:11');
INSERT INTO os_user_recharge VALUES ('4', '3', 'btc', '1111111111', '1.00000000', null, '0', '2017-05-03 10:16:49');
INSERT INTO os_user_recharge VALUES ('5', '3', 'btc', '1111111111', '1.00000000', null, '0', '2017-05-03 10:16:49');
INSERT INTO os_user_recharge VALUES ('6', '3', 'btc', '555', '1.20000000', null, '0', '2017-05-03 10:27:29');
INSERT INTO os_user_recharge VALUES ('7', '3', 'btc', 'DNpLKuo1GZFSmxvuDCjN5H6TQQSMrHiJ3a', '202542858.78146790', '4b5a1a8b80e1ffaeb9fee4bca54b92b30f9e60da0833ba43a8ccf6735bda241c', '0', '2017-05-04 18:00:46');

-- ----------------------------
-- Table structure for `os_user_withdraw`
-- ----------------------------
DROP TABLE IF EXISTS `os_user_withdraw`;
CREATE TABLE `os_user_withdraw` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL COMMENT '用户ID',
  `coinname` varchar(50) NOT NULL COMMENT '转出币种名',
  `address` varchar(100) NOT NULL COMMENT '转出地址',
  `amount` decimal(20,8) NOT NULL COMMENT '转出金额',
  `fee` decimal(20,8) NOT NULL DEFAULT '0.00000000' COMMENT '转出手续费',
  `txid` varchar(255) DEFAULT NULL COMMENT '转出交易hash',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '转出状态',
  `create_time` datetime NOT NULL,
  `end_time` datetime DEFAULT NULL COMMENT '完成时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of os_user_withdraw
-- ----------------------------
INSERT INTO os_user_withdraw VALUES ('3', '3', 'btc', '123123', '1.00000000', '0.00000000', null, '0', '2017-05-03 10:16:11', null);
INSERT INTO os_user_withdraw VALUES ('4', '3', 'btc', '1111111111', '1.00000000', '0.00000000', null, '0', '2017-05-03 10:16:49', null);
INSERT INTO os_user_withdraw VALUES ('5', '3', 'btc', '1111111111', '1.00000000', '0.00000000', null, '0', '2017-05-03 10:16:49', null);
INSERT INTO os_user_withdraw VALUES ('6', '3', 'btc', '555', '1.20000000', '0.00000000', null, '0', '2017-05-03 10:27:29', null);
