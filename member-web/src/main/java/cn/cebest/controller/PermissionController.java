package cn.cebest.controller;

import java.util.Map;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.github.pagehelper.PageInfo;
import cn.cebest.entity.RolePermission;
import cn.cebest.service.PermissionService;
import cn.cebest.util.PageResult;
import cn.cebest.util.Result;
import cn.cebest.util.ResultCode;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/permission")
public class PermissionController {
	
	@Autowired
	private PermissionService permissionService;

	
	/**
	 * 权限资源分页查询
	 * @param param
	 * @return
	 */
	@RequestMapping(value="/list", method=RequestMethod.GET)
	@ResponseBody
	public PageResult<T> list(@RequestParam Map<String, Object> param){
		PageInfo<T> pageInfo = permissionService.pageList(param);
		PageResult<T> result  = new PageResult<>(pageInfo);
		return result;
	}
	
	
	/**
	 * 权限资源保存
	 * @param rolePermission
	 * @return
	 */
	@RequestMapping(value="/synch", method=RequestMethod.POST)
	@ResponseBody
	public Result synch(RolePermission rolePermission){
		try {
			return permissionService.synch(rolePermission);
		} catch (Exception e) {
			log.error("保存权限资源异常", e);
			return new Result(ResultCode.SERVER_ERROR);
		}
	}
	
	
	
	/**
	 * 删除权限资源
	 * @param resourceId
	 * @return
	 */
	@RequestMapping(value="/{resourceId:\\d+}", method=RequestMethod.DELETE)
	public Result delete(@PathVariable("resourceId") String resourceId){
		try {
			permissionService.delByPrimaryKey(resourceId);
			return new Result();
		} catch (Exception e) {
			log.error("删除权限资源异常", e);
			return new Result(ResultCode.SERVER_ERROR);
		}
	}
	
}
