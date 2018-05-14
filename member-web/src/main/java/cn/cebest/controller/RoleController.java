package cn.cebest.controller;

import java.util.Map;
import org.apache.poi.ss.formula.functions.T;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.mgt.RealmSecurityManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.github.pagehelper.PageInfo;

import cn.cebest.entity.UserInfo;
import cn.cebest.entity.UserRole;
import cn.cebest.service.RoleService;
import cn.cebest.service.UserService;
import cn.cebest.shiro.MyShiroRealm;
import cn.cebest.util.PageResult;
import cn.cebest.util.Result;
import cn.cebest.util.ResultCode;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
@RequestMapping("/role")
public class RoleController {
	
	@Autowired
	private RoleService roleService;
	
	@Autowired
	private UserService userService;

	
	/**
	 * 角色分页查询
	 * @param param
	 * @return
	 */
	@RequestMapping(value="/list", method=RequestMethod.GET)
	@ResponseBody
	public PageResult<T> list(@RequestParam Map<String, Object> param){
		PageInfo<T> pageInfo = roleService.pageList(param);
		PageResult<T> result  = new PageResult<>(pageInfo);
		return result;
	}
	
	
	/**
	 * 角色权限
	 * @param param
	 * @return
	 */
	@RequestMapping(value="/{roleId:\\d+}/permissions", method=RequestMethod.GET)
	@ResponseBody
	public PageResult<T> permissions(@PathVariable("roleId") String roleId, 
			@RequestParam Map<String, Object> param) {
		param.put("roleId", roleId);
		PageInfo<T> pageInfo = roleService.permissions(param);
		PageResult<T> result  = new PageResult<>(pageInfo);
		return result;
	}
	
	
	/**
	 * 设置用户权限
	 * @param roleId
	 * @param ids
	 * @return
	 */
	@RequestMapping(value="/{roleId:\\d+}/permissions", method=RequestMethod.POST)
	@ResponseBody
	public Result setPermissions(@PathVariable("roleId") String roleId, 
			@RequestParam(value = "ids[]", required=false) Integer[] ids) {
		try {
			roleService.setPermissions(roleId, ids);
			
			 
			 RealmSecurityManager rsm = (RealmSecurityManager) SecurityUtils.getSecurityManager();  
			 MyShiroRealm shiroRealm = (MyShiroRealm)rsm.getRealms().iterator().next();
			 UserInfo user = (UserInfo) SecurityUtils.getSubject().getPrincipal();
			 user = userService.findByPhone(user.getPhone());
			 // 重新赋值权限
			 MyShiroRealm.reloadAuthorizing(shiroRealm, user);
			return new Result();
		} catch (Exception e) {
			log.error("修改角色权限异常", e);
			return new Result(ResultCode.SERVER_ERROR);
		}
	}
	
	
	/**
	 * 添加角色
	 * @param param
	 * @return
	 */
	@RequestMapping(value="/synch", method=RequestMethod.POST)
	@ResponseBody
	public Result synch(UserRole role){
		try {
			roleService.synch(role);
			Result result = new Result();
			result.setData(role);
			return result;
		} catch (Exception e) {
			log.error("添加角色异常", e);
			return new Result(ResultCode.SERVER_ERROR);
		}
	}
	
	
	/**
	 * 删除角色
	 * @param roleId
	 * @return
	 */
	@RequestMapping(value="/{roleId:\\d+}", method=RequestMethod.DELETE)
	@ResponseBody
	public Result delete(@PathVariable("roleId") String roleId){
		try {
			roleService.delete(roleId);
			Result result = new Result();
			return result;
		} catch (Exception e) {
			log.error("删除角色异常", e);
			return new Result(ResultCode.SERVER_ERROR);
		}
	}
	
}
