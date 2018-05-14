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
<link rel="stylesheet" href="/static/css/main.css" media="screen">
<!-- 用户列表模板 -->
<template id="userLT" style="display:none">
	<tr>
		<td><input type="checkbox" value="{id}" /></td>
		<td>{description}</td>
		<td>{roleCode}</td>
		<td>{createTime}</td>
		<td>{permissions}</td>
		<td>
			<i class="glyphicon glyphicon-share-alt"></i>
			<a href="javascript:setPermission({id});">设置权限</a>
			<shiro:hasPermission name="role:delete">
				<a href="javascript:warning({id});">删除</a>
			</shiro:hasPermission>
		</td>
	</tr>
</template>


<template id="permissionT" style="display:none">
	<tr>
		<td><input type="checkbox" value="{id}" /></td>
		<td>{name}</td>
		<td>{url}</td>
		<td>{resourceType}</td>
		<td>{createTime}</td>
	</tr>
</template>

<template id="noDataT" style="display:none">
	<tr>
		<td class="text-center" colspan="6">没有相关数据</td>
	</tr>
</template>

<template id="noData" style="display:none">
	<tr>
		<td class="text-center" colspan="5">没有相关数据</td>
	</tr>
</template>
</head>
<body>

	<div class="container col-md-12" style="padding: 15px 0">
			<div class="col-md-12">
				<h3>角色列表</h3>
				<hr>
				<div class="form-inline">
					<div class="form-group">
						<input type="text" class="form-control" id="content"
							placeholder="输入角色名称 / 编号">
					</div>
					<span class="">
						<button type="button" class="btn btn-primary"
							onclick="initData(1)">查询</button>
						<shiro:hasPermission name="role:delete">
							<button type="button" id="deleteAll1" class="btn  btn-danger">删除</button>
						</shiro:hasPermission>
						<shiro:hasPermission name="role:add">
							<button type="button" class="btn  btn-success" id="addRole">新增</button>
						</shiro:hasPermission>
					</span>
				</div>
				<hr>
				<table class="table table-bordered">
					<thead>
						<tr>
							<th><input type="checkbox" id="checkAll1" /></th>
							<th>角色名称</th>
							<th>角色编号</th>
							<th>创建时间</th>
							<th>拥有的权限</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody id="roleList">
					</tbody>
				</table>


				<div class="tc">
					<ul class="pagination">
					</ul>
				</div>

			</div>
	</div>
	
	
	<!-- 弹框内容 -->
	<div id="JuserBox" style="display: none">
		<div class="container col-md-12" style="padding: 50px 0">
			<div class="col-md-12">
				<div class="form-inline">
					<div class="form-group">
						<input type="text" class="form-control" id="key"
							placeholder="输入角色名称 / 编号">
					</div>
					<span class="">
						<button type="button" class="btn btn-primary"
							onclick="initPermissions(1)">查询</button>
					</span>
				</div>
				<hr>
				<table class="table table-bordered">
					<thead>
						<tr>
							<th><input type="checkbox" id="checkAll" /></th>
							<th>资源名称</th>
							<th>资源权限</th>
							<th>资源类型</th>
							<th>创建时间</th>
						</tr>
					</thead>
					<tbody id="pList">
					</tbody>
				</table>


				<div class="tc" style="margin-top: 80px;">
						<button class="btn btn-success" id="setPermission" lay-submit="">保存</button>
						<button type="reset" id="closeBox" class="btn btn-default" style="margin-left: 20px">关闭</button>
				</div>

			</div>
	</div>
	</div>
	
	
	
	<!-- 添加角色弹框 -->
	<div id="roleBox" style="display: none">
		<div class="container col-md-12" style="padding: 30px 0">
			<div class="col-md-12">

				<form class="layui-form" id="roleForm">
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label"><span class="must">*</span>角色名称：</label>
							<div class="layui-input-inline">
								<input type="text" name="description" lay-verify="description"
									class="form-control" placeholder="请输入角色名称">
							</div>
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label"><span class="must">*</span>角色编号：</label>
							<div class="layui-input-inline">
								<input type="text" name="roleCode" lay-verify="roleCode"
									class="form-control" placeholder="角色编号[大写字母4-15位]">
							</div>
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-input-block">
							<button class="btn btn-success" lay-submit="" lay-filter="save">保存</button>
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
<script src="static/js/main.js"></script>

<script>
var layer;
var total;
var index; // layer弹框下标
var _roleId; // 角色ID
layui.use(['layer','form'], function () {
    layer = layui.layer;
    var form = layui.form;
    form.verify({
    	description: function (description) {
            if (description === ''){
            	return '请输入角色名称';
            }
        },
        roleCode: function (roleCode) {
            if (roleCode === ''){
            	return '请输入角色编号';
            }
            
            if(!verifyRoleCode(roleCode)){
            	return '角色编号格式不正确';
            }
        }
    });
    
    
    form.on('submit(save)', function (data) {
    	$.ajax({
			type : "post",
			url : "role/synch",
			data:$( "#roleForm").serialize(),
			dataType : "json",
			success : function(data) {
				if(data.code == 200){
					closeBox();
					initData(1);
				} else {
					layer.alert(data.message, {icon: 2});
				}
			}
		}); 
		
		
		return false;
    });
    
});


$(function(){
	
	// 全选/反选
	$("#checkAll").on('change',function(){
		if($(this).attr("checked")){// 选中
			$("#pList").find("input[type='checkbox']").each(function(){
				$(this).attr("checked",true);
			})
		} else { // 取消选中
			$("#pList").find("input[type='checkbox']").each(function(){
				$(this).attr("checked",false);
			})
		}
	});
	
	
	// 关闭弹框
	$("#closeBox").on('click',function(){
		layer.close(index);
		$("#key").val('');
		$("#checkAll").attr("checked", false);
		// 更新数据
		initData(1);
	});
	
	
	//点击保存
	$("#setPermission").on('click', function(){
		var ids = new Array();
		$("#pList").find("input[type='checkbox']:checked").each(function(){
			ids.push($(this).val());
		});
		
		$.ajax({
			type : "post",
			url : "/role/" + _roleId + "/permissions",
			data : {
				ids:ids
			},
			dataType : "json",
			success : function(data) {
				layer.msg('保存成功');
			}// end success
		});//ajax end
	})
	
	
});


// 设置权限
function setPermission(roleId){
	_roleId = roleId;
	index = layer.open({
		title:"设置权限",
  		type: 1,
  		skin: 'layui-layer-rim', //加上边框
  		area: ['600px', '450px'], //宽高
 	 	content: $("#JuserBox"),
 	 	shade: [0.8, '#000'],
 	 	shadeClose :true,
 	 	closeBtn: 0 //不显示关闭按钮
	});
	
	
	// 初始化资源
	initPermissions(1);
	
	// 初始化角色权限
	initRoleP(roleId);
	
}


// 初始化资源
function initPermissions(pageNum){
	$.ajax({
		type : "get",
		url : "/permission/list",
		data : {
			"pageNum" : pageNum,
			"pageSize" : 0, // 查询全部
			"key" : $("#key").val()
		},
		dataType : "json",
		async : false,
		success : function(data) {
			total = data.totalCount;
			//清空列表
			$("#pList").empty();
			if (total > 0) { // 有数据
				var items = data.data;
				var arr = new Array("id", "name", "url","resourceType", "createTime");
				$.helper("url", funC);
				for (var i = 0; i < items.length; i++) {
					// 判断是否是最后一条
					var last = i == items.length-1 ? true : false;
					// 替换模板数据
					$.template($("#pList"), $("#permissionT").html(), arr,items[i], last);
				}
			} else {// 无数据
				$("#pList").append($("#noData").html());
			}
		}// end success
	});//ajax end
}


function funC(cellData, rowData) {
	if(cellData === ""){
		return rowData.permission;
	} else {
		return cellData;
	}
}


//初始化角色权限
function initRoleP(roleId){
	$.ajax({
		type : "get",
		url : "/role/" + roleId + "/permissions",
		data : {
			"pageNum": 1,
			"pageSize" : 0, // 查询全部
		},
		dataType : "json",
		success : function(data) {
			var items = data.data;
			for (var i = 0; i < items.length; i++) {
				var id = items[i].id;
				$("#pList").find("input[value="+ id +"]").attr("checked", true);
			}
		}// end success
	});//ajax end
}
</script>

<script type="text/javascript">

	//总条数
	var totalCount = 0;
	//每页显示的条数
	var pageSize = 10;
	
	$(function() {
		
		// 点击新增
		$("#addRole").on('click',function(){
			index = layer.open({
				title:"添加角色",
		  		type: 1,
		  		skin: 'layui-layer-rim', //加上边框
		  		area: ['400px', '300px'], //宽高
		 	 	content: $("#roleBox"),
		 	 	shade: [0.8, '#000'],
		 	 	shadeClose :true,
		 	 	closeBtn: 0 //不显示关闭按钮
			});
		});
		
		// 关闭弹框
		$("#closeBt").on('click',function(){
			closeBox();
		})
		
		
		// 获取用户首页数据
		initData(1);
		
		// 初始化分页
		initPagePlugin();
	})
	
	
	
	function closeBox(){
		layer.close(index);
		// 清空表单
		$("#roleForm")[0].reset();
	}
	
	

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

	// 初始化角色
	function initData(pageNum) {
		$.ajax({
			type : "get",
			url : "/role/list",
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
				$("#roleList").empty();
				if (totalCount > 0) { // 有数据
					var items = data.data;
					var arr = new Array("reg_id", "description", "roleCode",
							"createTime", "permissions");
					// 注意:需要特殊处理的字段绑定回调函数
					$.helper("permissions", funA);
					for (var i = 0; i < items.length; i++) {
						// 判断是否是最后一条
						var last = i == items.length-1 ? true : false;
						// 替换模板数据
						$.template($("#roleList"), $("#userLT").html(), arr,items[i], last);
					}
				} else {// 无数据
					$("#roleList").append($("#noDataT").html());
				}
			}// end success
		});//ajax end
	}

	function funA(cellData, rowData) {
		var permissions = new Array();
		if(cellData.length > 0) {
			for(var i = 0; i < cellData.length; i++){
				permissions.push(cellData[i].name);
			}
		} else {
			return '暂无权限';
		}
		return permissions.join(",");
	}
	
	
	// 提示确认
	function warning(id){
		layui.use('layer', function(){
			layer.confirm('确认删除?',{
				icon: 3, 
				title:'提示',
				btnAlign: 'c',
				yes: function(index){
					 layer.close(index);
					// 确认删除
					delRole(id);
				}
			})
		});
	}
	
	// 删除角色
	function delRole(id){
		$.ajax({
			type : "delete",
			url : "/role/" + id,
			dataType : "json",
			success : function(data) {
				// 初始化数据
				initData(1);
			}// end success
		});//ajax end
	}
	
</script>
</html>