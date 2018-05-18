package cn.cebest.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.ModelAttribute;
import cn.cebest.constant.Constants;
import cn.cebest.entity.UserInfo;

public class BaseController {

	protected HttpServletRequest request;
	protected HttpServletResponse response;
	protected HttpSession session;
	protected UserInfo currentUser;

	/**
	 * 说明：@ModelAttribute的作用 1)放置在方法的形参上：表示引用Model中的数据
	 * 2)放置在方法上面：表示请求该类的每个Action前都会首先执行它，也可以将一些准备数据的操作放置在该方法里面。
	 * 
	 * @param request
	 * @param response
	 */
	@ModelAttribute
	public void setReqAndRes(HttpServletRequest request, HttpServletResponse response) {
		this.request = request;
		this.response = response;
		this.session = request.getSession();
		this.currentUser = (UserInfo) this.session.getAttribute(Constants.CURRENT_USER);
	}

}
