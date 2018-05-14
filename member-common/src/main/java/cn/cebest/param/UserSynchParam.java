package cn.cebest.param;

import lombok.Getter;
import lombok.Setter;

/**
 * 保存用户参数
 * @author maming
 * @date 2018年4月26日
 */

@Setter
@Getter
public class UserSynchParam {
	
	private Integer id; // 主键ID

	private String nickName; //昵称
	
	private String realName; //真实姓名
	
	private String phone; //手机号
	
	private String password; //密码
	
	private String photo; //头像
	
	private Integer age; //年龄
	
	private Integer sex; //性别 1男 2女
}
