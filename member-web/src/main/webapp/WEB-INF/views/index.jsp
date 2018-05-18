<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>会员中心</title>

<link rel="stylesheet" href="static/css/index.css" type="text/css" media="screen" />

<script type="text/javascript" src="static/js/jquery.min.js"></script>
<script type="text/javascript" src="static/js/tendina.min.js"></script>
<script type="text/javascript" src="static/js/common.js"></script>

</head>
<body>
    <!--顶部-->
    <div class="layout_top_header">
            <div style="float: left"><span style="font-size: 16px;line-height: 45px;padding-left: 20px;color: #8d8d8d">会员管理系统</h1></span></div>
            <div id="ad_setting" class="ad_setting">
                <a class="ad_setting_a" href="javascript:; ">
                    <i class="icon-user glyph-icon" style="font-size: 20px"></i>
                    <span>${CURRENT_USER.realName}</span>
                    <i class="icon-chevron-down glyph-icon"></i>
                </a>
                <ul class="dropdown-menu-uu" style="display: none" id="ad_setting_ul">
                    <li class="ad_setting_ul_li"> <a href="javascript:;"><i class="icon-user glyph-icon"></i> 个人中心 </a> </li>
                    <li class="ad_setting_ul_li"> <a href="javascript:;"><i class="icon-cog glyph-icon"></i> 设置 </a> </li>
                    <li class="ad_setting_ul_li"> <a href="/user/logout"><i class="icon-signout glyph-icon"></i> <span class="font-bold">退出</span> </a> </li>
                </ul>
            </div>
    </div>
    <!--顶部结束-->
    <!--菜单-->
    <div class="layout_left_menu">
        <ul id="menu">
            <li class="childUlLi">
               <a href="/user/${CURRENT_USER.id}"  target="menuFrame"><i class="glyph-icon icon-home"></i>个人中心</a>
                <ul>
                    <li><a href="/user/${CURRENT_USER.id}" target="menuFrame"><i class="glyph-icon icon-chevron-right"></i>个人详情</a></li>
                    <li><a href="/user_setpwd" target="menuFrame"><i class="glyph-icon icon-chevron-right"></i>修改密码</a></li>
                </ul>
            </li>
            <li class="childUlLi">
                <a href="#"> <i class="icon-user glyph-icon"></i>用户管理</a>
                <ul>
                    <li><a href="/user_list" target="menuFrame"><i class="glyph-icon icon-chevron-right"></i>用户列表</a></li>
                    <li><a href="/user_add" target="menuFrame"><i class="glyph-icon icon-chevron-right"></i>添加用户</a></li>
                </ul>
            </li>
            <li class="childUlLi">
                <a href="role.html" target="menuFrame"> <i class="glyph-icon icon-reorder"></i>角色管理</a>
                <ul>
                    <li><a href="/role_list" target="menuFrame"><i class="glyph-icon icon-chevron-right"></i>角色列表</a></li>
                    <li><a href="/role_distribution" target="menuFrame"><i class="glyph-icon icon-chevron-right"></i>角色分配</a></li>
                </ul>
            </li>
            <li class="childUlLi">
                <a href="#"> <i class="glyph-icon  icon-location-arrow"></i>权限管理</a>
                <ul>
                    <li><a href="permission_list" target="menuFrame"><i class="glyph-icon icon-chevron-right"></i>资源列表</a></li>
                </ul>
            </li>
            <li class="childUlLi">
                <a href="#"> <i class="icon-keyboard glyph-icon"></i>任务管理</a>
                <ul>
                    <li><a href="task_list" target="menuFrame"><i class="glyph-icon icon-chevron-right"></i>任务列表</a></li>
                </ul>
            </li>
        </ul>
    </div>
    <!--菜单-->
    <div id="layout_right_content" class="layout_right_content">

        <div class="route_bg">
            <a href="#">主页</a><i class="glyph-icon icon-chevron-right"></i>
            <a href="#">菜单管理</a>
        </div>
        <div class="mian_content">
            <div id="page_content">
                <iframe id="menuFrame" name="menuFrame" src="/user/${CURRENT_USER.id}" style="overflow:visible;"
                        scrolling="yes" frameborder="no" width="100%" height="100%"></iframe>
            </div>
        </div>
    </div>
    <div class="layout_footer">
        <p>Copyright © 2018 - 小明童鞋</p>
    </div>
</body>
</html>