<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
        + request.getServerName() + ":" + request.getServerPort()
        + path + "/";
    response.setHeader("Cache-Control","no-store"); 
    response.setHeader("Pragrma","no-cache"); 
    response.setDateHeader("Expires",0); 

%>
<html>
<head>
<base href="<%=basePath%>">
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
			<h3>个人详情</h3>
			<hr>
			<form class="layui-form" id="userForm" enctype="multipart/form-data">
			
				<input name="id" value="${user.id}" style="display: none" readonly="readonly"/>
			
				<div class="layui-form-item">
					<div class="layui-inline">
						<label class="layui-form-label">账户：</label>
						<div class="layui-input-inline">
							<input type="text" name="phone" value="${user.phone}" disabled="disabled" class="form-control">
						</div>
					</div>
				</div>
				
				<div class="layui-form-item">
					<div class="layui-inline">
						<label class="layui-form-label">创建时间：</label>
						<div class="layui-input-inline">
							<input type="text" name="createTime" value="${user.createTime}" disabled="disabled" class="form-control">
						</div>
					</div>
				</div>
				
				<div class="layui-form-item">
					<div class="layui-inline">
						<label class="layui-form-label">昵称：</label>
						<div class="layui-input-inline">
							<input type="text" name="nickName" value="${user.nickName}" class="form-control" placeholder="请输入昵称">
						</div>
					</div>
				</div>
				
				<div class="layui-form-item">
					<div class="layui-inline">
						<label class="layui-form-label">真实姓名：</label>
						<div class="layui-input-inline">
							<input type="text" name="realName" value="${user.realName}" lay-verify="realName" class="form-control" placeholder="请输入真实姓名">
						</div>
					</div>
				</div>
				
				
			 <div class="layui-form-item">
			 	<div class="layui-inline">
			 		<label class="layui-form-label" style="margin-top: 40px;">头像：</label>
				 	<label class="layui-form-label">
		                <img class="layui-upload-img" width="100px" height="100px" id="img_url" src="${user.photo}"/>
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
							<input type="text" name="age" value="${user.age}" lay-verify="age" class="form-control" placeholder="请输入年龄">
						</div>
					</div>
				</div>
				
				<div class="layui-form-item">
				    <label class="layui-form-label">性别：</label>
				    <div class="layui-input-block">
				      <c:choose>
				      	<c:when test="${user.sex == 1}">
				      		<input type="radio" name="sex" value="1" title="男" checked="checked">
				      		<input type="radio" name="sex" value="2" title="女">
				      	</c:when>
				      	<c:otherwise>
				      		<input type="radio" name="sex" value="1" title="男" >
				      		<input type="radio" name="sex" value="2" title="女" checked="checked">
				      	</c:otherwise>
				      </c:choose>
				    </div>
				</div>
				  
				  
				<div class="layui-form-item">
					<div class="layui-input-block">
						<button class="btn btn-success" style="margin-left: 30px;" lay-submit=""  lay-filter="save">保存</button>
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
        realName: function (realName) {
        	if(realName != null
        	   &&$.trim(realName) != ''
        	   && !is_chName(realName)){
        		return '请输入正确的真实姓名';
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
			url : "user/modify",
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