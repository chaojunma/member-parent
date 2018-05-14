package cn.cebest.service.impl;

import java.util.List;
import java.util.Map;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.formula.functions.T;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import cn.cebest.entity.RolePermission;
import cn.cebest.mapper.PermissionMapper;
import cn.cebest.service.PermissionService;
import cn.cebest.service.ShiroService;
import cn.cebest.util.Result;
import cn.cebest.util.ResultCode;

@Service
public class PermissionServiceImpl implements PermissionService{
	
	@Autowired
	private PermissionMapper permissionMapper;
	
	@Autowired
	private ShiroService shiroService;
	
	@Autowired
	private ShiroFilterFactoryBean shiroFilterFactoryBean;

	
	/**
	 * 资源列表
	 * @param param
	 * @return
	 */
	@Override
	public PageInfo<T> pageList(Map<String, Object> param) {
		int pageNum = Integer.valueOf((String) param.get("pageNum"));
		int pageSize = Integer.valueOf((String) param.get("pageSize"));
		PageHelper.startPage(pageNum, pageSize);
		List<T> data = permissionMapper.pageList(param);
		PageInfo<T> pageInfo = new PageInfo<>(data);
		return pageInfo;
	}


	/**
	 * 新增权限资源
	 * @param param
	 * @return
	 */
	@Override
	public Result synch(RolePermission rolePermission) {
		String url = rolePermission.getUrl();
		if(permissionMapper.getByUrl(url) != null){
			return new Result(ResultCode.RESOURCE_URL_EXISTS_ERROR);
		}
		
		String permission = rolePermission.getPermission();
		if(permissionMapper.getByPermission(permission) != null){
			return new Result(ResultCode.PERMISSION_EXISTS_ERROR);
		}
		
		// 获取父标识
		String parentCode = rolePermission.getParentCode();
		if(StringUtils.isNotEmpty(parentCode)) {
			RolePermission rp = permissionMapper.getByUniqueCode(parentCode);
			if(rp == null)
				return new Result(ResultCode.PARENT_CODE_NOT_EXISTS);
			
			rolePermission.setParentId(rp.getId());
		}
		
		// 获取系统时间
		int time  = (int) System.currentTimeMillis();
		// 生成唯一标识
		rolePermission.setUniqueCode(Integer.toHexString(time).toUpperCase());
		
		//保存权限资源
		permissionMapper.synch(rolePermission);
		// 重置shiro权限配置
		shiroService.reloadFilterChains(shiroFilterFactoryBean);
		
		Result result = new Result();
		result.setData(rolePermission);
		return result;
	}


	
	/**
	 * 删除权限资源
	 * @param id
	 * @return
	 */
	@Override
	@Transactional
	public int delByPrimaryKey(String id) {
		// 根据资源ID删除
		int count = permissionMapper.delByPrimaryKey(id);
		// 删除角色资源关联关系
		permissionMapper.delRolePermission(id);
		// 重置shiro权限配置
		shiroService.reloadFilterChains(shiroFilterFactoryBean);
		return count;
	}

}
