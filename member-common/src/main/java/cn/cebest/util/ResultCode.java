package cn.cebest.util;

/**
 * @author maming
 * @date 2017/11/23
 */
public class ResultCode {

	public static final ResultCode SUCCESS = new ResultCode(200, "成功");
	public static final ResultCode PARAMETER_ERROR = new ResultCode(400, "请求数据非法");
	public static final ResultCode AUTHORIZE_FAIL_ERROR = new ResultCode(401, "用户未授权");
	public static final ResultCode FORBID_REQUEST_ERROR = new ResultCode(403, "访问被禁止");
	public static final ResultCode NOT_EXIST_ERROR = new ResultCode(404, "资源不存在");
	public static final ResultCode UNSUPPORTED_MEDIA_TYPE = new ResultCode(415, "错误的请求格式");
	public static final ResultCode METHOD_ERROR = new ResultCode(405, "请求方法错误");
	public static final ResultCode SERVER_ERROR = new ResultCode(500, "服务器错误");

	public static final ResultCode RESOURCE_URL_EXISTS_ERROR = new ResultCode(4001, "资源URL已存在");
	public static final ResultCode PERMISSION_EXISTS_ERROR = new ResultCode(4002, "权限表达式已存在");
	public static final ResultCode PARENT_CODE_NOT_EXISTS = new ResultCode(4003, "父标识不存在");
	public static final ResultCode PHONE_EXIST_ERROR = new ResultCode(4004, "手机号已注册");
	
	public Integer code;
	public String message;

	private ResultCode(Integer code, String message) {
		this.code = code;
		this.message = message;
	}

	public Integer getCode() {
		return code;
	}

	public void setCode(Integer code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}
