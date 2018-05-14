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
<template id="permissionT" style="display:none">
<tr>
	<td><input type="checkbox" value="{id}" /></td>
	<td>{uniqueCode}</td>
	<td>{name}</td>
	<td>{resourceType}</td>
	<td>{url}</td>
	<td>{permission}</td>
	<td>{parentCode}</td>
	<td>{createTime}</td>
	<td>
		<a href="javascript:warning({id});">编辑</a>
		<a href="javascript:warning({id});">删除</a>
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
				<h3>资源列表</h3>
				<hr>
				<div class="form-inline">
					<div class="form-group">
						<input type="text" class="form-control" id="content"
							placeholder="输入名称/ 标识">
					</div>
					<span class="">
						<button type="button" class="btn btn-primary"
							onclick="initData(1)">查询</button>
						<button type="button" id="deleteAll" class="btn  btn-danger">删除</button>
						<button type="button" id="add" class="btn  btn-success">新增</button>
					</span>
				</div>
				<hr>
				<table class="table table-bordered">
					<thead>
						<tr>
							<th><input type="checkbox" id="checkAll" /></th>
							<th>唯一标识</th>
							<th>资源名称</th>
							<th>资源类型</th>
							<th>资源URL</th>
							<th>Permission</th>
							<th>父标识</th>
							<th>创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody id="permissionList">
					</tbody>
				</table>


				<div class="tc">
					<ul class="pagination">
					</ul>
				</div>

			</div>
	</div>
	
	
	
	<!-- 添加权限弹框 -->
	<div id="JpBox" style="display: none">
		<div class="container col-md-12" style="padding: 30px 0">
			<div class="col-md-12">

				<form class="layui-form" id="resourceForm">
				
					<div class="layui-form-item">
						<div class="layui-inline">
						    <label class="layui-form-label"><span class="must">*</span>资源类型:</label>
						    <div class="layui-input-inline">
						      <select name="resourceType" class="form-control">
						        <option value="menu">菜单</option>
						        <option value="button">按钮</option>
						      </select>
						    </div>
						 </div>
					  </div>
				
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label"><span class="must">*</span>资源名称：</label>
							<div class="layui-input-inline">
								<input type="text" name="name" lay-verify="name"
									class="form-control" placeholder="请输入资源名称">
							</div>
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label"><span class="must">*</span>资源URL：</label>
							<div class="layui-input-inline">
								<input type="text" name="url" lay-verify="url"
									class="form-control" placeholder="请输入资源URL">
							</div>
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label"><span class="must">*</span>Permission：</label>
							<div class="layui-input-inline">
								<input type="text" name="permission" lay-verify="permission"
									class="form-control" placeholder="请输入权限表达式">
							</div>
						</div>
					</div>
					
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label">父标识：</label>
							<div class="layui-input-inline">
								<input type="text" name="parentCode" lay-verify="parentCode"
									class="form-control" placeholder="请输入父标识">
							</div>
						</div>
					</div>
					
					<div class="layui-form-item">
						<div class="layui-input-block" >
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
		var form = layui.form;
		form.verify({
	    	name: function (name) {
	            if (name === ''){
	            	return '请输入资源名称';
	            }
	        },
	        url: function (url) {
	            if (url === ''){
	            	return '请输入资源URL';
	            }
	        },
	        permission: function (permission) {
	            if (permission === ''){
	            	return '请输入权限表达式';
	            }
	        }
	        
	    });
		
		
		
		form.on('submit(save)', function (data) {
	    	$.ajax({
				type : "post",
				url : "permission/synch",
				data:$( "#resourceForm").serialize(),
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
	
	
	// 删除提醒
	function warning(resourceId){
		layui.use('layer', function(){
			layer.confirm('确认删除?',{
				icon: 3, 
				title:'提示',
				btnAlign: 'c',
				yes: function(index){
					 layer.close(index);
					 delPermission(resourceId);
				}
			})
		});
	}
	
	
	// 删除权限资源
	function delPermission(resourceId){
		$.ajax({
			type : "delete",
			url : "/permission/" + resourceId,
			dataType : "json",
			async : false,
			success : function(data) {
				// 初始化数据
				initData(1);
			}// end success
		});//ajax end
	}
	
	$(function() {
		
		$("#add").on('click',function(){
			_index = layer.open({
				title:"添加资源",
		  		type: 1,
		  		skin: 'layui-layer-rim', //加上边框
		  		area: ['450px', '480px'], //宽高
		 	 	content: $("#JpBox"),
		 	 	shade: [0.8, '#000'],
		 	 	shadeClose :true,
		 	 	closeBtn: 0 //不显示关闭按钮
			});
		});
		
		
		$("#closeBt").on('click', function(){
			closeBox();
		});
		
		
		// 获取用户首页数据
		initData(1);
		
		// 初始化分页
		initPagePlugin();
	})
	
	
	
	// 关闭弹框
	function closeBox(){
		layer.close(_index);
		$("#resourceForm")[0].reset();
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

	// 初始用户
	function initData(pageNum) {
		$.ajax({
			type : "get",
			url : "/permission/list",
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
				$("#permissionList").empty();
				if (totalCount > 0) { // 有数据
					var items = data.data;
					var arr = new Array("reg_id","uniqueCode", "name", "resourceType", "url","permission", "parentCode", "createTime");
					// 注意:需要特殊处理的字段绑定回调函数
					$.helper("resourceType", funA);
					$.helper("parentCode", funB);
					$.helper("url", funC);
					for (var i = 0; i < items.length; i++) {
						// 判断是否是最后一条
						var last = i == items.length-1 ? true : false;
						// 替换模板数据
						$.template($("#permissionList"), $("#permissionT").html(), arr,items[i], last);
					}
				} else {// 无数据
					$("#permissionList").append($("#noData").html());
				}
			}// end success
		});//ajax end
	}

	function funA(cellData, rowData) {
		if (cellData == "menu") {
			return "菜单";
		} else {
			return "按钮";
		}
	}

	function funB(cellData, rowData) {
		if(cellData === ""){
			return "无";
		} else {
			return cellData;
		}
	}
	
	function funC(cellData, rowData) {
		if(cellData === ""){
			return rowData.permission;
		} else {
			return cellData;
		}
	}
</script>
</html>