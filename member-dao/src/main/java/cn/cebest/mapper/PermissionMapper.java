package cn.cebest.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.poi.ss.formula.functions.T;

import cn.cebest.entity.RolePermission;

/**
 * 权限资源DAO接口
 * @author maming
 * @date 2018年5月2日
 */
@Mapper
public interface PermissionMapper {

	/**
	 * 资源分页查询
	 * @param param
	 * @return
	 */
	public List<T> pageList(Map<String, Object> param);
	
	
	/**
	 * 删除角色权限
	 * @param roleId
	 * @return
	 */
	public int delPermissions(@Param("roleId")String roleId);
	
	
	/**
	 * 设置角色权限
	 * @param roleId
	 * @param ids
	 * @return
	 */
	public int setPermissions(@Param("roleId")String roleId, @Param("ids")Integer[] ids);
	
	
	/**
	 * 通过URL获取权限资源
	 * @param url
	 * @return
	 */
	public RolePermission getByUrl(@Param("url") String url);
	
	
	/**
	 * 通过permission获取权限资源
	 * @param url
	 * @return
	 */
	public RolePermission getByPermission(@Param("permission") String permission);
	
	
	/**
	 * 通过唯一标识获取权限资源
	 * @param url
	 * @return
	 */
	public RolePermission getByUniqueCode(@Param("uniqueCode") String uniqueCode);
	
	
	/**
	 * 添加权限资源
	 * @param param
	 */
	public void synch(RolePermission rolePermission);
	
	
	/**
	 * 删除权限资源
	 * @param id
	 * @return
	 */
	public int delByPrimaryKey(@Param("id") String id);
	
	
	/**
	 * 删除角色资源关联关系
	 * @param permissionId
	 * @return
	 */
	public int delRolePermission(@Param("permissionId") String permissionId);
	
}
