package cn.cebest.service;

import java.util.Map;
import org.apache.poi.ss.formula.functions.T;
import com.github.pagehelper.PageInfo;
import cn.cebest.entity.UserRole;


/**
 * 角色接口
 * @author maming
 * @param <T>
 * @date 2018年5月2日
 */
public interface RoleService {

	/**
	 * 角色列表
	 * @param param
	 * @return
	 */
	public PageInfo<T> pageList(Map<String, Object> param);
	
	
	/**
	 * 角色权限列表
	 * @param param
	 * @return
	 */
	public PageInfo<T> permissions(Map<String, Object> param);
	
	
	/**
	 * 设置角色权限
	 * @param roleId
	 * @param ids
	 * @return
	 */
	public int setPermissions(String roleId, Integer[] ids);
	
	
	/**
	 * 添加角色
	 * @param param
	 * @return
	 */
	public UserRole synch(UserRole role);
	
	
	/**
	 * 删除角色
	 * @param roleId
	 * @return
	 */
	public int delete(String roleId);
}
