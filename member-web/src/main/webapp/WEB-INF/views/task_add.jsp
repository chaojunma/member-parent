<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>首页</title>


<link rel="stylesheet" href="/static/layui/css/layui.css" media="screen">
<link rel="stylesheet"
	href="/static/bootstrap/3.3.5/css/bootstrap.min.css" type="text/css"
	media="screen" />
<link rel="stylesheet" href="/static/css/main.css" media="screen">

</head>
<body>
	<div class="container col-md-12" style="padding: 15px 0">
		<div class="col-md-12">
			<h3>添加定时任务</h3>
			<hr>
			<form class="layui-form" id="taskForm">
					
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label"><span class="must">*</span>任务名称：</label>
							<div class="layui-input-inline">
								<input type="text" name="name" lay-verify="name"
									class="form-control" placeholder="请输入任务名称">
							</div>
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label"><span class="must">*</span>任务表达式：</label>
							<div class="layui-input-inline">
								<input type="text" name="cron" lay-verify="cron"
									class="form-control" placeholder="请输入任务表达式">
							</div>
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label"><span class="must">*</span>执行的类：</label>
							<div class="layui-input-inline">
								<input type="text" name="targetBean" lay-verify="targetBean"
									class="form-control" placeholder="请输入执行的类">
							</div>
						</div>
					</div>
					
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label"><span class="must">*</span>执行方法：</label>
							<div class="layui-input-inline">
								<input type="text" name="targetMethod" lay-verify="targetMethod"
									class="form-control" placeholder="请输入执行方法">
							</div>
						</div>
					</div>
					
					<div class="layui-form-item">
						<div class="layui-inline">
						    <label class="layui-form-label"><span class="must">*</span>任务状态:</label>
						    <div class="layui-input-inline">
						      <input type="radio" name="status" value="0" title="正常" checked="checked">
				      		  <input type="radio" name="status" value="1" title="暂停">		
						    </div>
						 </div>
					  </div>
					  
					  
					  <div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label">备注：</label>
							<div class="layui-input-inline">
								<textarea name="remarks" style="width: 500px;height: 100px;" class="form-control"></textarea>
							</div>
						</div>
					</div>
					
					<div class="layui-form-item" style="margin-top: 30px;">
						<div class="layui-input-block" >
							<button class="btn btn-success" lay-submit="" lay-filter="save">保存</button>
						</div>
					</div>
				</form>
		</div>
	</div>
</body>

<script src="/static/layui/layui.js"></script>
<script src="/static/js/jquery.js"></script>
<script src="/static/js/main.js"></script>
<script>
layui.use(['layer', 'form'], function () {
    var layer = layui.layer,
		$ = layui.jquery,
		form = layui.form;

    form.verify({
    	name: function (name) {
            if (name === ''){
            	return '请输入任务名称';
            }
        },
        cron: function (cron) {
        	if (cron === ''){
            	return '请输入任务表达式';
            }
        	if(!cronValidate(cron)){
        		return '任务表达式格式不正确';
        	}
        },
        targetBean: function (targetBean) {
        	if (targetBean === ''){
            	return '请输入执行的类名称';
            }
        },
        targetMethod: function (targetMethod) {
        	if (targetMethod === ''){
            	return '请输入执行方法';
            }
        }
    });
    
    
    form.on('submit(save)', function (data) {
		
		$.ajax({
			type : "post",
			url : "/task/synch",
			data:$("#taskForm").serialize(),
			dataType : "json",
			success : function(data) {
				if(data.code == 200){
					layer.alert('保存成功', {icon: 1});
				} else {
					layer.alert(data.message, {icon: 2});
				}
			}
		});
		
		
		return false;
    });
    
    
});
</script>

</html>