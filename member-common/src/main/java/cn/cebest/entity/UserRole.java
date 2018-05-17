package cn.cebest.entity;

import java.io.Serializable;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import lombok.Data;


/**
 * 用户角色字段
 * @author maming
 * @date 2018年4月23日
 */
@Data
@JsonInclude(Include.NON_NULL) 
public class UserRole implements Serializable{

	private static final long serialVersionUID = 1L;

	private Integer id; //角色ID
	
	private String roleCode; //角色编号
	
	private String description; //角色描述
	
	private Integer isDelete; //是否已删除0未删除 1已删除
	
	private String createTime; //创建时间
	
	List<RolePermission> permissions; //用户权限
}
