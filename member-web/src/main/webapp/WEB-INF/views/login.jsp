<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
	<meta name="renderer" content="webkit|ie-comp|ie-stand">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta http-equiv="Cache-Control" content="no-siteapp" />
    <title>首页</title>
	
	<link rel="stylesheet" href="/static/layui/css/layui.css">
	<link rel="stylesheet" href="/static/css/sccl.css">
  </head>
  
  <body class="login-bg">
    <div class="login-box">
        <header>
            <h1>会员管理系统</h1>
        </header>
        <div class="login-main">
			<form action="/user/login" id="loginForm" class="layui-form" method="post">
				<input name="__RequestVerificationToken" type="hidden" value="">                
				<div class="layui-form-item">
					<label class="login-icon">
						<i class="layui-icon"></i>
					</label>
					<input type="text" name="phone" lay-verify="phone" autocomplete="off" placeholder="这里输入登录名" class="layui-input">
				</div>
				<div class="layui-form-item">
					<label class="login-icon">
						<i class="layui-icon"></i>
					</label>
					<input type="password" name="password" lay-verify="password" autocomplete="off" placeholder="这里输入密码" class="layui-input">
				</div>
				<div class="layui-form-item">
					<div class="pull-left login-remember">
						<label>记住帐号？</label>

						<input type="checkbox" name="rememberMe" value="true" lay-skin="switch" title="记住帐号"><div class="layui-unselect layui-form-switch"><i></i></div>
					</div>
					<div class="pull-right">
						<button class="layui-btn layui-btn-primary" lay-submit="" lay-filter="login">
							<i class="layui-icon"></i> 登录
						</button>
					</div>
					
					<div class="clear"></div>
				</div>
			</form>        
		</div>
        <footer>
            <p>© 2018 All Rights Reserved 中企高呈</p>
        </footer>
    </div>
    <script src="/static/layui/layui.js"></script>
    <script src="/static/js/jquery.min.js"></script>
    <script language="javascript">
		if (top.location != self.location) {
			top.location = self.location;
		}
	</script>
    <script>
    
    	var msg = "${msg}";
    	
    	
        layui.use(['layer', 'form'], function () {
        		var layer = layui.layer,
				$ = layui.jquery,
				form = layui.form;

            form.verify({
            	phone: function (value) {
                    if (value === '')
                        return '请输入用户名';
                },
                password: function (value) {
                    if (value === '')
                        return '请输入密码';
                }
            });
            
            
            form.on('submit(login)', function (data) {
            	$("#loginForm").submit();
            });
            
            if(msg != null && $.trim(msg).length > 0){
    			layer.alert(msg, {icon: 2});
    		}
            
        });
		
    </script>
  </body>
</html>
