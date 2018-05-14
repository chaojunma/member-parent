package cn.cebest.controller;

import java.util.Map;
import java.util.Set;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;


/**
 * 页面跳转
 * @author maming
 * @date 2018年4月20日
 */
@Controller
public class PageJumpController {
	
	
	/**
	 * 页面跳转 放行的调用此接口
	 * 
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/{page:^[0-9a-zA-Z_]+$}", method = RequestMethod.GET)
	public String pagePermit(@PathVariable("page") String page,@RequestParam Map<String,String>params,ModelMap model) {
		// 获取所有参数的key
		Set<String> keys = params.keySet();
		// 遍历所有参数
		for (String key : keys) {
			String value = params.get(key);
			// 将参数放入request作用域
			model.put(key, value);
		}
		return page;
	}

}
