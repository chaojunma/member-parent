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
<link rel="stylesheet" href="static/css/pagination.css" type="text/css" />
<link rel="stylesheet" href="/static/css/main.css" media="screen">
<!-- 用户列表模板 -->
<template id="taskT" style="display:none">
<tr>
	<td><input type="checkbox" value="{id}" /></td>
	<td>{name}</td>
	<td>{cron}</td>
	<td>{targetBean}</td>
	<td>{targetMethod}</td>
	<td>{status}</td>
	<td>{remarks}</td>
	<td>{createTime}</td>
	<td>
		<a href="/task/{id}">编辑</a>
		{status}
		<a href="javascript:warning({id});">立即执行</a>
	</td>
</tr>
</template>


<template id="noDataT">
	<tr>
		<td class="text-center" colspan="10">没有相关数据</td>
	</tr>
</template>
</head>
<body>

	<div class="container col-md-12" style="padding: 15px 0">
			<div class="col-md-12">
				<h3>任务列表</h3>
				<hr>
				<div class="form-inline">
					<span>任务名称:</span>
					<div class="form-group">
						<input type="text" class="form-control" id="content"
							placeholder="输入任务名称/类名/方法名">
					</div>
					<span style="margin-left: 20px;">任务状态:</span>
					<div class="form-group">
						<select name="status" id="status" class="form-control" style="width: 150px;">
							<option value="-1">请选择任务状态</option>
							<option value="0">正常</option>
							<option value="1">暂停</option>
						</select>
					</div>
					<span style="margin-left: 20px;">
						<button type="button" class="btn btn-primary"
							onclick="initData(1)">查询</button>
						<button type="button" id="add" class="btn  btn-success">新增</button>
					</span>
				</div>
				<hr>
				<table class="table table-bordered">
					<thead>
						<tr>
							<th><input type="checkbox" id="checkAll" /></th>
							<th>任务名称</th>
							<th>任务表达式</th>
							<th>执行的类</th>
							<th>执行的方法</th>
							<th>任务状态</th>
							<th>任务说明</th>
							<th>创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody id="taskList">
					</tbody>
				</table>


				<div class="tc">
					<ul class="pagination">
					</ul>
				</div>

			</div>
	</div>

</body>
<script src="static/layui/layui.js"></script>
<script src="static/js/jquery.js"></script>
<script src="static/js/template.js"></script>
<script src="static/js/jquery.pagination.js"></script>
<script type="text/javascript">

	//总条数
	var totalCount = 0;
	//每页显示的条数
	var pageSize = 10;
	//弹框下标
	var _index;
	var layer;
	
	layui.use(['layer','form'], function () {
		layer = layui.layer;
	});
	
	
	// 删除提醒
	function warning(taskId){
		layui.use('layer', function(){
			layer.confirm('确认暂停?',{
				icon: 3, 
				title:'提示',
				btnAlign: 'c',
				yes: function(index){
					 layer.close(index);
					 paush(taskId);
				}
			})
		});
	}
	
	
	// 暂停任务
	function paush(taskId){
		$.post("/task/paush",{"ids":[taskId]},
			function (data){
	            if(data.code == 200){
	                layer.msg("暂停成功",{time: 200},function(){
	                    location.reload();
	                });
	            }else{
	                layer.msg(data.message);
	            }
        });
	}
	
	// 启动任务
	function resume(taskId){
		$.post("/task/resume",{"ids":[taskId]},
			function (data){
	            if(data.code == 200){
	                layer.msg("启动成功",{time: 200},function(){
	                    location.reload();
	                });
	            }else{
	                layer.msg(data.message);
	            }
        });
	}
	
	
	$(function() {
		// 获取用户首页数据
		initData(1);
		
		// 初始化分页
		initPagePlugin();
	})
	

	//初始化分页插件
	function initPagePlugin() {
		$(".pagination").pagination(totalCount, {
			callback : PageCallback,
			prev_text : "上一页",
			next_text : "下一页",
			items_per_page : pageSize,
			num_display_entries : 5,
			num_edge_entries : 1,
			link_to : "javascript:void(0)"
		});
	}
	
	
	// 分页回调函数
	function PageCallback(index, jq) { 
		initData(index+1);	    
	}

	// 初始用户
	function initData(pageNum) {
		$.ajax({
			type : "get",
			url : "/task/list",
			data : {
				"pageNum" : pageNum,
				"pageSize" : pageSize,
				"key" : $("#content").val(),
				"status":$("#status").val()
			},
			dataType : "json",
			async : false,
			success : function(data) {
				totalCount = data.totalCount;
				//清空列表
				$("#taskList").empty();
				if (totalCount > 0) { // 有数据
					var items = data.data;
					var arr = new Array("reg_id","name", "cron", "targetBean", "targetMethod","status", "remarks", "createTime", "status");
					// 注意:需要特殊处理的字段绑定回调函数
					$.helper("status", funA);
					$.helper("status", funB);
					for (var i = 0; i < items.length; i++) {
						// 判断是否是最后一条
						var last = i == items.length-1 ? true : false;
						// 替换模板数据
						$.template($("#taskList"), $("#taskT").html(), arr,items[i], last);
					}
				} else {// 无数据
					$("#taskList").append($("#noData").html());
				}
			}// end success
		});//ajax end
	}

	function funA(cellData, rowData) {
		if (cellData == 0) {
			return "正常";
		} else {
			return "暂停";
		}
	}
	
	
	function funB(cellData, rowData) {
		if (cellData == 0) {
			return "<a href='javascript:warning(" + rowData.id + ");'>暂停</a>";
		} else {
			return "<a href='javascript:resume(" + rowData.id + ");'>开启</a>";
		}
	}

</script>
</html>