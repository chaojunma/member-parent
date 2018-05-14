package cn.cebest.util;

import lombok.Getter;
import lombok.Setter;

/**
 * @author maming
 * @date 2017/11/23
 */
@Setter
@Getter
public class Result {

	private Integer code; //状态码
	
	private String message; //描述
	
	private Object data; //返回数据
	
	public Result() {
		code = 200;
		message = "success";
	}
	
	public Result(Integer code,String message) {
		this.code = code;
		this.message = message;
	}
	
	public Result(Integer code,String message,Object data) {
		this.code = code;
		this.message = message;
		this.data = data;
	}
	
	public Result(ResultCode resultCode) {
		this.code = resultCode.getCode();
		this.message = resultCode.getMessage();
	}
	
	
}
