<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>首页</title>


<link rel="stylesheet" href="/static/layui/css/layui.css" media="screen">
<link rel="stylesheet"
	href="static/bootstrap/3.3.5/css/bootstrap.min.css" type="text/css"
	media="screen" />
<link rel="stylesheet" href="/static/css/main.css" media="screen">

</head>
<body>
	<div class="container col-md-12" style="padding: 15px 0">
		<div class="col-md-12">
			<h3>修改密码</h3>
			<hr>
			<form class="layui-form" id="userForm" enctype="multipart/form-data">
				
				<input name="id" value="${CURRENT_USER.id}" style="display: none" readonly="readonly"/>
			
				<div class="layui-form-item">
					<div class="layui-inline">
						<label class="layui-form-label"><span class="must">*</span>原密码：</label>
						<div class="layui-input-inline">
							<input type="password" name="origin" lay-verify="origin" class="form-control" placeholder="请输入原密码">
						</div>
					</div>
				</div>
				
				<div class="layui-form-item">
					<div class="layui-inline">
						<label class="layui-form-label"><span class="must">*</span>新密码：</label>
						<div class="layui-input-inline">
							<input type="password" name="password" lay-verify="password" class="form-control" placeholder="请输入新密码">
						</div>
						<label class="layui-form-label must">6-32数字英文及下划线的组合</label>
					</div>
				</div>
				
				<div class="layui-form-item">
					<div class="layui-inline">
						<label class="layui-form-label"><span class="must">*</span>确认密码：</label>
						<div class="layui-input-inline">
							<input type="password" name="configPwd" lay-verify="configPwd" class="form-control" placeholder="请输入确认密码">
						</div>
					</div>
				</div>
				<div class="layui-form-item">
					<div class="layui-input-block">
						<button class="btn btn-success" lay-submit=""  lay-filter="save">保存</button>
						<button type="reset" class="btn btn-default">重置</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>

<script src="static/layui/layui.js"></script>
<script src="static/js/jquery.js"></script>
<script src="static/js/main.js"></script>
<script>


var password = "${CURRENT_USER.password}";

layui.use(['layer', 'form','upload'], function () {
    var layer = layui.layer,
		$ = layui.jquery,
		form = layui.form;
    
    

    form.verify({
    	origin: function (origin) {
            if (origin === ''){
            	return '请输入原密码';
            }
            if(origin != password){
            	return '原密码不正确';
            }
        },
        password: function (password) {
        	if(password === ''){
        		return '请输入新密码';
        	}
        	if(!verifypwd(password)) {
        		return '密码格式不正确';
        	}
        },
        configPwd: function (configpwd) {
        	if(configpwd === ''){
        		return '请输入确认密码';
        	}
        	
        	var newPwd = $("input[name='password']").val();
        	if(configpwd != newPwd){
        		return '两次输入的密码不一致';
        	}
        }
    });
    
    
    form.on('submit(save)', function (data) {
    	
    	var formData = new FormData($( "#userForm")[0]); 
		
		$.ajax({
			type : "post",
			url : "user/password",
			data:$( "#userForm").serialize(),
			dataType : "json",
			success : function(data) {
				if(data.code == 200){
					layer.alert('保存成功', {icon: 1});
				} else {
					layer.alert(data.message, {icon: 2});
				}
			},// end success
			 statusCode: {  
				 4020: function (data) {  
					 var result = JSON.parse(data.responseText);
		             window.location.href = result.data;  
		         }  
		     }
		}); 
		
		
		return false;
    });
    
    
});
</script>

</html>