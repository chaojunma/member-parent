<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>首页</title>

<script type="text/javascript" src="static/js/jquery.min.js"></script>

<link rel="stylesheet" href="static/css/add.css" type="text/css" media="screen" />
<link rel="stylesheet" href="static/utilLib/bootstrap.min.css" type="text/css" media="screen" />

</head>
<body>
<div class="div_from_aoto" style="width: 500px;">
    <FORM>
        <DIV class="control-group">
            <label class="laber_from">用户名</label>
            <DIV  class="controls" ><INPUT class="input_from" type=text placeholder=" 请输入用户名"><P class=help-block></P></DIV>
        </DIV>
        <DIV class="control-group">
            <LABEL class="laber_from">密码</LABEL>
            <DIV  class="controls" ><INPUT class="input_from" type=text placeholder=" 请输入密码"><P class=help-block></P></DIV>
        </DIV>
        <DIV class="control-group">
            <LABEL class="laber_from" >确认密码</LABEL>
            <DIV  class="controls" ><INPUT class="input_from" type=text placeholder=" 请输入确认密码"><P class=help-block></P></DIV>
        </DIV>
        <DIV class="control-group">
            <LABEL class="laber_from">角色</LABEL>
            <DIV  class="controls" >
                <SELECT class="input_select">
                    <OPTION selected>董事长</OPTION>
                    <OPTION>总经理</OPTION>
                    <OPTION>经理</OPTION>
                    <OPTION>主管</OPTION>
                </SELECT>
            </DIV>
        </DIV>
        <DIV class="control-group">
            <LABEL class="laber_from" ></LABEL>
            <DIV class="controls" ><button class="btn btn-success" style="width:120px;" >确认</button></DIV>
        </DIV>
    </FORM>
</div>
</body>
</html>