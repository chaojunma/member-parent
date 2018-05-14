package cn.cebest.service;

import java.util.Map;
import org.apache.poi.ss.formula.functions.T;
import com.github.pagehelper.PageInfo;

import cn.cebest.entity.RolePermission;
import cn.cebest.util.Result;

/**
 * 权限资源接口
 * @author maming
 * @param <T>
 * @date 2018年5月2日
 */
public interface PermissionService {
	
	/**
	 * 资源列表
	 * @param param
	 * @return
	 */
	public PageInfo<T> pageList(Map<String, Object> param);
	
	
	/**
	 * 新增权限资源
	 * @param param
	 * @return
	 */
	public Result synch(RolePermission rolePermission);
	
	
	/**
	 * 删除权限资源
	 * @param id
	 * @return
	 */
	public int delByPrimaryKey(String id);

}
