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
			<h3>添加用户</h3>
			<hr>
			<form class="layui-form" id="userForm" enctype="multipart/form-data">
				<div class="layui-form-item">
					<div class="layui-inline">
						<label class="layui-form-label"><span class="must">*</span>手机号：</label>
						<div class="layui-input-inline">
							<input type="text" name="phone" lay-verify="phone" class="form-control" placeholder="请输入手机号">
						</div>
					</div>
				</div>
				
				<div class="layui-form-item">
					<div class="layui-inline">
						<label class="layui-form-label">昵称：</label>
						<div class="layui-input-inline">
							<input type="text" name="nickName" class="form-control" placeholder="请输入昵称">
						</div>
					</div>
				</div>
				
				<div class="layui-form-item">
					<div class="layui-inline">
						<label class="layui-form-label">真实姓名：</label>
						<div class="layui-input-inline">
							<input type="text" name="realName" lay-verify="realName" class="form-control" placeholder="请输入真实姓名">
						</div>
					</div>
				</div>
				
				<div class="layui-form-item">
					<div class="layui-inline">
						<label class="layui-form-label"><span class="must">*</span>密码：</label>
						<div class="layui-input-inline">
							<input type="password" name="password" lay-verify="password" class="form-control" placeholder="请输入真实姓名">
						</div>
						<label class="layui-form-label must">6-32数字英文及下划线的组合</label>
					</div>
				</div>
				
				<div class="layui-form-item">
					<div class="layui-inline">
						<label class="layui-form-label"><span class="must">*</span>确认密码：</label>
						<div class="layui-input-inline">
							<input type="password" name="configpwd" lay-verify="configpwd" class="form-control" placeholder="请输入真实姓名">
						</div>
					</div>
				</div>

				<div class="layui-form-item">
				 	<div class="layui-inline">
				 		<label class="layui-form-label" style="margin-top: 40px;">头像：</label>
					 	<label class="layui-form-label">
			                <img class="layui-upload-img" width="100px" height="100px" id="img_url"/>
			                <p id="demoText"></p>
			            </label>
			            <div class="layui-input-inline layui-upload" style="margin-top: 40px;">
				            <button type="button" class="layui-btn" id="upload">上传图片</button>
				        </div>
			         </div>
		        </div>
				
				<div class="layui-form-item">
					<div class="layui-inline">
						<label class="layui-form-label">年龄：</label>
						<div class="layui-input-inline">
							<input type="text" name="age" lay-verify="age" class="form-control" placeholder="请输入年龄">
						</div>
					</div>
				</div>
				
				<div class="layui-form-item">
				    <label class="layui-form-label">性别：</label>
				    <div class="layui-input-block">
				      <input type="radio" name="sex" value="1" title="男" checked="checked">
				      <input type="radio" name="sex" value="2" title="女">
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
layui.use(['layer', 'form','upload'], function () {
    var layer = layui.layer,
		$ = layui.jquery,
		form = layui.form,
		upload = layui.upload;
    
    
    upload.render({
	    elem: '#upload'
	    ,auto: false
	    ,choose: function(obj){
	    	//预读本地文件，如果是多文件，则会遍历。(不支持ie8/9)
	        obj.preview(function(index, file, result){
	        	$("#img_url").attr("src",result);
	        });
	    }
	  });

    form.verify({
    	phone: function (phone) {
            if (phone === ''){
            	return '请输入手机号';
            }
            if (!verifyphone(phone)){
            	return '手机号格式不正确';
            }
        },
        realName: function (realName) {
        	if(realName != null
        	   &&$.trim(realName) != ''
        	   && !is_chName(realName)){
        		return '请输入正确的真实姓名';
        	}
        },
        password: function (password) {
        	if(password === ''){
        		return '请输入密码';
        	}
        	
        	if(!verifypwd(password)) {
        		return '密码格式不正确';
        	}
        },
        configpwd: function (configpwd) {
        	if(configpwd === ''){
        		return '请输入确认密码';
        	}
        	
        	var password = $("input[name='password']").val();
        	if(configpwd != password){
        		return '两次输入的密码不一致';
        	}
        },
        age: function (age) {
        	if(age != null
               &&$.trim(age) != ''
               && !verifyNum(age)){
        		return '年龄必须为正整数';
        	}
        }
    });
    
    
    form.on('submit(save)', function (data) {
    	
    	var formData = new FormData($( "#userForm")[0]); 
		
		$.ajax({
			type : "post",
			url : "user/synch",
			data:formData,
			dataType : "json",
			processData:false,
	        contentType:false,
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