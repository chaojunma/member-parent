<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
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
<!-- 用户列表模板 -->
<template id="userLT" style="display:none">
<tr>
	<td><input type="checkbox" value="{id}" /></td>
	<td>{nickName}</td>
	<td>{realName}</td>
	<td>{phone}</td>
	<td>{createTime}</td>
	<td>{state}</td>
	<td>{state}</td>
</tr>
</template>


<template id="noDataT">
	<tr>
		<td class="text-center" colspan="7">没有相关数据</td>
	</tr>
</template>
</head>
<body>

	<div class="container col-md-12" style="padding: 15px 0">
			<div class="col-md-12">
				<h3>用户列表</h3>
				<hr>
				<div class="form-inline">
					<div class="form-group">
						<input type="text" class="form-control" id="content"
							placeholder="输入昵称 / 帐号">
					</div>
					<span class="">
						<button type="button" class="btn btn-primary"
							onclick="initData(1)">查询</button>
						<shiro:hasPermission name="user:delete"> 
							<button type="button" id="deleteAll" class="btn  btn-danger">删除</button>
						</shiro:hasPermission>
					</span>
				</div>
				<hr>
				<table class="table table-bordered">
					<thead>
						<tr>
							<th><input type="checkbox" id="checkAll" /></th>
							<th>昵称</th>
							<th>真实姓名</th>
							<th>账号</th>
							<th>创建时间</th>
							<th>用户状态</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody id="userList">
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
			url : "/user/list",
			data : {
				"pageNum" : pageNum,
				"pageSize" : pageSize,
				"key" : $("#content").val()
			},
			dataType : "json",
			async : false,
			success : function(data) {
				totalCount = data.totalCount;
				//清空列表
				$("#userList").empty();
				if (totalCount > 0) { // 有数据
					var items = data.data;
					var arr = new Array("id", "nickName", "realName", "phone",
							"createTime", "state", "state");
					// 注意:需要特殊处理的字段绑定回调函数
					$.helper("state", funA);
					$.helper("state", funB);
					for (var i = 0; i < items.length; i++) {
						// 判断是否是最后一条
						var last = i == items.length-1 ? true : false;
						// 替换模板数据
						$.template($("#userList"), $("#userLT").html(), arr,items[i], last);
					}
				} else {// 无数据
					$("#userList").append($("#noDataT").html());
				}
			}// end success
		});//ajax end
	}

	function funA(cellData, rowData) {
		if (cellData == 1) {
			return "正常";
		} else {
			return "锁定";
		}
	}

	function funB(cellData, rowData) {
		var html = "";
		if (cellData == 1) {
			html = "<i class='glyphicon glyphicon-eye-close'></i>"
					+ "&nbsp;<a href='javascript:setState(" + rowData.id +", 2)'>禁止账户</a>"
					+ "&nbsp;<a href=javascript:warning(" + rowData.id +")>删除</a>";
		} else {
			html = "<i class='glyphicon glyphicon-eye-open'></i>"
					+ "&nbsp;<a href='javascript:setState(" + rowData.id +", 1)'>开启账户</a>"
					+ "&nbsp;<a href=javascript:warning(" + rowData.id +")>删除</a>";
		}
		return html;
	}
	
	
	// 删除提醒
	function warning(userId){
		layui.use('layer', function(){
			layer.confirm('确认删除?',{
				icon: 3, 
				title:'提示',
				btnAlign: 'c',
				yes: function(index){
					 layer.close(index);
					// 确认删除
					deleteUser(userId);
				}
			})
		});
	}
	
	
	
	// 删除用户
	function deleteUser(userId){
		$.ajax({
			type : "delete",
			url : "/user/" + userId,
			dataType : "json",
			async : false,
			success : function(data) {
				// 初始化数据
				initData(1);
			}// end success
		});//ajax end
	}
	
	// 设置用户状态
	function setState(userId, state){
		$.ajax({
			type : "put",
			url : "/user/" + userId + "/" + state,
			dataType : "json",
			async : false,
			success : function(data) {
				// 初始化数据
				initData(1);
			}// end success
		});//ajax end
	}
</script>
</html>