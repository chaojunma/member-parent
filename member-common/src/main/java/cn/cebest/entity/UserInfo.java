package cn.cebest.entity;

import java.io.Serializable;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import lombok.Data;


/**
 * 用户字段
 * @author maming
 * @date 2018年4月23日
 */
@Data
@JsonInclude(Include.NON_NULL) 
public class UserInfo implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private Integer id; //用户ID
	
	private String nickName; //昵称
	
	private String realName; //真实姓名
	
	private String phone; //手机号
	
	private String password; //密码
	
	private String photo; //头像
	
	private Integer age; //年龄
	
	private Integer sex; //性别 1男 2女
	
	private Integer state; // 用户状态 1正常 2锁定
	
	private Integer isDelete; //是否已删除0未删除 1已删除
	
	private String createTime; //创建时间
	
	private List<UserRole> roleList; //用户角色
	
	
}
