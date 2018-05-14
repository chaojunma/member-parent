package cn.cebest.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.poi.ss.formula.functions.T;

import cn.cebest.entity.UserRole;


/**
 * 角色DAO接口
 * @author maming
 * @date 2018年5月2日
 */
@Mapper
public interface RoleMapper {
	
	/**
	 * 角色分页查询
	 * @param param
	 * @return
	 */
	public List<T> pageList(Map<String, Object> param);
	
	
	/**
	 * 角色权限列表
	 * @param param
	 * @return
	 */
	public List<T> permissions(Map<String, Object> param);
	
	
	/**
	 * 添加角色
	 * @param param
	 * @return
	 */
	public int synch(UserRole role);
	
	
	/**
	 * 删除角色
	 * @param roleId
	 * @return
	 */
	public int delete(@Param("id")String id);
	
}
