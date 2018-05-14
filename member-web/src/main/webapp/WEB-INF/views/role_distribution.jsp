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
<!-- 用户列表模板 -->
<template id="userLT" style="display:none">
<tr>
	<td><input type="checkbox" value="{id}" /></td>
	<td>{nickName}</td>
	<td>{realName}</td>
	<td>{phone}</td>
	<td>{state}</td>
	<td>{roleList}</td>
	<td>
		<i class="glyphicon glyphicon-share-alt"></i>
		<a href="javascript:setRole({id});">角色分配</a>
	</td>
</tr>
</template>


<template id="noDataT">
	<tr>
		<td class="text-center" colspan="7">没有相关数据</td>
	</tr>
</template>

<template id="checkboxT"> 
	<input type="checkbox" name="role" lay-skin="primary" title="{description}" value="{id}"/>
	<br>
</template>
</head>
<body>

	<div class="container col-md-12" style="padding: 15px 0">
			<div class="col-md-12">
				<h3>角色分配</h3>
				<hr>
				<div class="form-inline">
					<div class="form-group">
						<input type="text" class="form-control" id="content"
							placeholder="输入昵称 / 帐号">
					</div>
					<span class="">
						<button type="button" class="btn btn-primary"
							onclick="initData(1)">查询</button>
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
							<th>用户状态</th>
							<th>拥有的角色</th>
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


	<!-- 分配权限弹框 -->
	<div id="roleBox" style="display: none">
		<div class="container col-md-12" style="padding: 30px 0">
			<div class="col-md-12">

				<form class="layui-form" id="roleForm">
					<div class="layui-form-item" pane="">
					    <div class="layui-input-block" id="roleL">
					    </div>
					 </div>
  
					<div class="layui-form-item" style="margin-top: 50px;">
						<div class="layui-input-block">
							<button type="button" class="btn btn-success"  id="saveBt">保存</button>
							<button type="reset" class="btn btn-default" id="closeBt">关闭</button>
						</div>
					</div>
				</form>

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
	// 弹框下标
	var _index;
	var layer;
	var form;
	var _userId;
	
	layui.use(['layer', 'form'], function () {
	    layer = layui.layer;
	    form = layui.form;
	});   
	
	$(function() {
		
		// 关闭弹框
		$("#closeBt").on('click',function(){
			closeBox();
		})
		
		$("#saveBt").on('click',function(){
			var roleIds = new Array(); 
			$("#roleL").find("input[type='checkbox']:checked").each(function(){
				roleIds.push($(this).val());
			});
			
			$.ajax({
				type : "post",
				url : "user/" + _userId + "/roles",
				data:{
					"roleIds":roleIds
				},
				dataType : "json",
				success : function(data) {
					layer.msg('保存成功');
				}
			});
			
		});
		
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
					var arr = new Array("reg_id", "nickName", "realName", "phone",
							"state", "roleList");
					// 注意:需要特殊处理的字段绑定回调函数
					$.helper("state", funA);
					$.helper("roleList", funB);
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
		var roles = new Array();
		if(cellData.length > 0) {
			for(var i = 0; i < cellData.length; i++){
				roles.push(cellData[i].description);
			}
		} else {
			return '暂无分配';
		}
		return roles.join(",");
	}
	
	
	// 设置用户角色
	function setRole(userId){
		_userId = userId;
		_index = layer.open({
			title:"角色分配",
	  		type: 1,
	  		skin: 'layui-layer-rim', //加上边框
	  		area: ['400px', '300px'], //宽高
	 	 	content: $("#roleBox"),
	 	 	shade: [0.8, '#000'],
	 	 	shadeClose :true,
	 	 	closeBtn: 0 //不显示关闭按钮
		});
		
		// 初始化全部角色
		initRole();
		// 初始化用户角色
		initUserRole(userId);
	}
	
	
	// 初始化角色
	function initRole() {
		$.ajax({
			type : "get",
			url : "/role/list",
			data : {
				"pageNum" : 1,
				"pageSize" : 0 // 查询全部
			},
			dataType : "json",
			async : false,
			success : function(data) {
				var items = data.data;
				var arr = new Array("reg_description","id");
				for (var i = 0; i < items.length; i++) {
					// 判断是否是最后一条
					var last = i == items.length-1 ? true : false;
					$.template($("#roleL"), $("#checkboxT").html(), arr,items[i], last);
				}
			}// end success
		});//ajax end
	}

	
	function initUserRole(userId){
		$.ajax({
			type : "get",
			url : "/user/detail/" + userId,
			dataType : "json",
			success : function(data) {
				var roles = data.roleList;
				for(var i=0;i<roles.length;i++){
					$("#roleL").find("input[value="+ roles[i].id +"]").attr("checked", true);
				}
				form.render();
			}// end success
		});//ajax end
	}
	
	function closeBox(){
		layer.close(_index);
		$("#roleL").empty();
		initData(1);
	}
	
	
</script>
</html>