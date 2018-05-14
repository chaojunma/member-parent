
//手机号验证
function verifyphone(phone){
	var reg = /^1[34578][0-9]{9}$/;
	return reg.test(phone);
}

//中文姓名验证
function is_chName(myName){
	return(new RegExp(/^[\u4E00-\u9FA5]{2,6}$/).test(myName));
};


// 验证密码
function verifypwd(password){
	var reg = new RegExp(/^\w{6,32}$/);
	return reg.test(password);
}

//验证正整数
function verifyNum(num){
	var reg = new RegExp(/^\d+$/);
	return reg.test(num);
}

//验证角色编码
function verifyRoleCode(roleCode){
	var reg = new RegExp(/^[A-Z]{4,15}$/);
	return reg.test(roleCode);
}
