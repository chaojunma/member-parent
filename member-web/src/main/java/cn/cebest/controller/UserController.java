package cn.cebest.controller;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import com.github.pagehelper.PageInfo;
import cn.cebest.constant.Constants;
import cn.cebest.entity.UserInfo;
import cn.cebest.param.UserListParam;
import cn.cebest.param.UserSynchParam;
import cn.cebest.service.UserService;
import cn.cebest.util.PageResult;
import cn.cebest.util.Result;
import cn.cebest.util.ResultCode;
import lombok.extern.slf4j.Slf4j;
import java.util.Map;
import org.apache.poi.ss.formula.functions.T;

@Slf4j
@Controller
@RequestMapping("/user")
public class UserController {
	
	@Autowired
	private UserService userService;
	
	
	/**
	 * 用户登录
	 * @param user
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/login", method=RequestMethod.POST)
	public String login(UserInfo user, Model model, boolean rememberMe) throws Exception {
		
		log.info("用户登录...");
		String msg = "success";
		
		Subject subject = SecurityUtils.getSubject();
		if (!subject.isAuthenticated()) {
			// 把用户名和密码封装为 UsernamePasswordToken 对象
			UsernamePasswordToken token = new UsernamePasswordToken(user.getPhone(), user.getPassword(), rememberMe);
			// 选中记住我
			//token.setRememberMe(true);
			try {
				// 登录,自定义的realm
				subject.login(token);
			} catch (UnknownAccountException e) {
				log.info("用户不存在UnknownAccountException:{}", e);
				msg = "用户不存在";
			} catch (IncorrectCredentialsException ice) {
				log.info("用户密码错误IncorrectCredentialsException:{}", ice);
				msg = "用户密码错误";
			} catch (AuthenticationException ae) {
				log.info("用户名或密码错误AuthenticationException:{}", ae);
				msg = "用户名或密码错误";
			}
		}
		
		//将提示信息放到request作用域
		model.addAttribute("msg", msg);

		//验证是否登录成功
		if(subject.isAuthenticated()){
			Session session = subject.getSession();
			UserInfo userInfo = (UserInfo) subject.getPrincipals().getPrimaryPrincipal();
			session.setAttribute(Constants.CURRENT_USER, userInfo);
			return "redirect:/index";
		} else {
			return "/login";
		}
	}
	
	
	
	/**
	 * 用户注销
	 */
	@RequestMapping(value="/logout", method=RequestMethod.GET)
	public String logout(){
		Subject subject = SecurityUtils.getSubject();
		if(subject.isAuthenticated()){
			// 注销
			subject.logout();
		}
		// 重定向到登录页
		return "redirect:/login";
	}
	
	
	/**
	 * 用户分页查询
	 * @param param
	 * @return
	 */
	@RequestMapping(value="/list", method=RequestMethod.GET)
	@ResponseBody
	public PageResult<T> list(UserListParam param){
		PageInfo<T> pageInfo = userService.pageList(param);
		PageResult<T> result  = new PageResult<>(pageInfo);
		return result;
	}
	
	
	/**
	 * 添加用户
	 * @param param
	 * @param file
	 * @return
	 */
	@RequestMapping(value="/synch", method=RequestMethod.POST)
	@ResponseBody
	public Result synch(UserSynchParam param, @RequestParam(value = "file", required = false) MultipartFile file){
		Result result = null;
		try {
			// 保存用户信息
			result = userService.synch(param, file);
		} catch (Exception e) {
			log.error("保存用户信息异常", e);
			result = new Result(ResultCode.SERVER_ERROR);
		}
		return result;
	}
	
	
	
	/**
	 * 获取用户详情
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/{userId:\\d+}", method = RequestMethod.GET)
	public String detail(@PathVariable("userId") String userId, ModelMap model) {
		// 获取用户详情
		UserInfo user = userService.detail(userId);
		// 将数据放入request作用域
		model.put("user", user);
		// 跳转页面
		return "/user_detail";
	}
	
	
	/**
	 * 获取用户详情
	 * @param userId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/detail/{userId:\\d+}", method = RequestMethod.GET)
	@ResponseBody
	public UserInfo userDetail(@PathVariable("userId") String userId, ModelMap model) {
		// 获取用户详情
		UserInfo user = userService.detail(userId);
		// 跳转页面
		return user;
	}
	

/**
 * 修改用户信息
 * @param param
 * @param file
 * @return
 */
	@RequestMapping(value = "/modify", method = RequestMethod.POST)
	@ResponseBody
	public Result update(@RequestParam Map<String, Object> param,
			@RequestParam(value = "file", required = false) MultipartFile file) {
		try {
			userService.update(param, file);
			return new Result();
		} catch (Exception e) {
			log.error("修改用户信息异常", e);
			return new Result(ResultCode.SERVER_ERROR);
		}
	}
	
	
	
	/**
	 * 删除用户
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/{userId:\\d+}", method = RequestMethod.DELETE)
	@ResponseBody
	public Result delete(@PathVariable("userId") String userId){
		try {
			userService.delete(userId);
			return new Result();
		} catch (Exception e) {
			log.error("删除用户信息异常", e);
			return new Result(ResultCode.SERVER_ERROR);
		}
	}
	
	
	/**
	 * 修改用户状态
	 * @return
	 */
	@RequestMapping(value = "/{userId:\\d+}/{state:\\d+}", method = RequestMethod.PUT)
	@ResponseBody
	public Result userState(@PathVariable("userId") String userId,
												    @PathVariable("state") String state) {
		try {
			userService.updateState(userId, state);
			return new Result();
		} catch (Exception e) {
			log.error("设置户状态异常", e);
			return new Result(ResultCode.SERVER_ERROR);
		}
	}
	
	
	/**
	 * 重置密码
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/password", method = RequestMethod.POST)
	@ResponseBody
	public Result resetPwd(@RequestParam Map<String, Object> param){
		try {
			// 重置密码
			userService.resetPwd(param);
			// 更新session
			userService.updateSession();
			return new Result();
		} catch (Exception e) {
			log.error("重置密码异常", e);
			return new Result(ResultCode.SERVER_ERROR);
		}
	}
	
	
	/**
	 * 设置用户角色
	 * @param userId
	 * @param roleIds
	 * @return
	 */
	@RequestMapping(value = "/{userId:\\d+}/roles", method = RequestMethod.POST)
	@ResponseBody
	public Result setUserRoles(@PathVariable("userId") String userId, 
			@RequestParam(value = "roleIds[]", required=false) Integer[] roleIds){
		try {
			userService.setUserRoles(userId, roleIds);
			return new Result();
		} catch (Exception e) {
			log.error("设置用户角色异常", e);
			return new Result(ResultCode.SERVER_ERROR);
		}
	}
	

}
