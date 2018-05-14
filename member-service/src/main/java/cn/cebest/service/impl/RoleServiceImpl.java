package cn.cebest.service.impl;

import java.util.List;
import java.util.Map;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import cn.cebest.entity.UserRole;
import cn.cebest.mapper.PermissionMapper;
import cn.cebest.mapper.RoleMapper;
import cn.cebest.service.RoleService;

@Service
public class RoleServiceImpl implements RoleService{
	
	@Autowired
	private RoleMapper roleMapper;
	
	@Autowired
	private PermissionMapper permissionMapper;

	
	/**
	 * 角色列表
	 * @param param
	 * @return
	 */
	@Override
	public PageInfo<T> pageList(Map<String, Object> param) {
		int pageNum = Integer.valueOf((String) param.get("pageNum"));
		int pageSize = Integer.valueOf((String) param.get("pageSize"));
		PageHelper.startPage(pageNum, pageSize);
		List<T> data = roleMapper.pageList(param);
		PageInfo<T> pageInfo = new PageInfo<>(data);
		return pageInfo;
	}


	
	/**
	 * 角色权限列表
	 * @param param
	 * @return
	 */
	@Override
	public PageInfo<T> permissions(Map<String, Object> param) {
		int pageNum = Integer.valueOf((String) param.get("pageNum"));
		int pageSize = Integer.valueOf((String) param.get("pageSize"));
		PageHelper.startPage(pageNum, pageSize);
		List<T> data = roleMapper.permissions(param);
		PageInfo<T> pageInfo = new PageInfo<>(data);
		return pageInfo;
	}



	/**
	 * 设置角色权限
	 * @param roleId
	 * @param ids
	 * @return
	 */
	@Override
	public int setPermissions(String roleId, Integer[] ids) {
		// 清空角色权限
		permissionMapper.delPermissions(roleId);
		int count = 0;
		if(ids != null && ids.length > 0){
			// 重置角色权限
			count = permissionMapper.setPermissions(roleId, ids);
		}
		
		return count;
	}


	/**
	 * 添加角色
	 * @param param
	 * @return
	 */
	@Override
	public UserRole synch(UserRole role) {
		roleMapper.synch(role);
		return role;
	}


	/**
	 * 删除角色
	 * @param roleId
	 * @return
	 */
	@Override
	@Transactional
	public int delete(String roleId) {
		int count = 0;
		// 删除角色
		count = roleMapper.delete(roleId);
		// 根据角色ID删除相关权限
		permissionMapper.delPermissions(roleId);
		return count;
	}

}
