package cn.cebest.entity;

import java.io.Serializable;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import lombok.Data;

@Data
@JsonInclude(Include.NON_NULL) 
public class RolePermission implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private Integer Id; //主键ID
	
	private String uniqueCode; // 唯一标识
	
	private String name; //资源名称
	
	private String resourceType; //资源类型 menu|button
	
	private String url; //资源路径
	
	private String permission; //权限字符串 menu例子：role:*，button例子：role:create,role:update,role:delete,role:view
	
	private Integer parentId; //父ID
	
	private  String parentCode; //父标识
	
	private Integer isDelete; //是否删除

	private String createTime; //创建时间
}
