package cn.cebest.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;
import cn.cebest.constant.Constants;
import cn.cebest.entity.UserInfo;
import cn.cebest.service.UserService;


/**
 * session拦截器
 * @author maming
 * @date 2018年5月9日
 */
public class SessionInterceptor implements HandlerInterceptor {

	@Autowired
	private UserService userService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object arg2) throws Exception {

		Subject subject = SecurityUtils.getSubject();
		// 判断用户是通过记住我功能自动登录,此时session失效
		if (!subject.isAuthenticated() && subject.isRemembered()) {
			try {
				UserInfo principal = (UserInfo) subject.getPrincipals().getPrimaryPrincipal();
				UserInfo user = userService.findByPhone(principal.getPhone());
				// 对密码进行加密后验证
				UsernamePasswordToken token = new UsernamePasswordToken(user.getPhone(), user.getPassword(),
						subject.isRemembered());
				// 把当前用户放入session
				subject.login(token);
				Session session = subject.getSession();
				session.setAttribute(Constants.CURRENT_USER, user);
				// 设置会话的过期时间--ms,默认是30分钟，设置负数表示永不过期
				session.setTimeout(-1000l);
			} catch (Exception e) {
				// 自动登录失败,跳转到登录页面
				response.sendRedirect(request.getContextPath() + "/login");
				return false;
			}
			if (!subject.isAuthenticated()) {
				// 自动登录失败,跳转到登录页面
				response.sendRedirect(request.getContextPath() + "/login");
				return false;
			}
		}
		return true;
	}

	@Override
	public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3)
			throws Exception {

	}

	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, ModelAndView arg3)
			throws Exception {

	}

}
