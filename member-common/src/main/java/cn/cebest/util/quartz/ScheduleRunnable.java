package cn.cebest.util.quartz;

import java.lang.reflect.Method;
import org.apache.commons.lang.StringUtils;
import org.springframework.util.ReflectionUtils;
import cn.cebest.util.AppContextUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * 执行定时任务
 * @author maming
 * @date 2018年5月16日
 */
@Slf4j
public class ScheduleRunnable implements Runnable {

	// 目标类
	private Object target;
	// 目标方法
	private Method method;
	// 方法参数
	private String params;

	public ScheduleRunnable(String beanName, String methodName, String params)
			throws NoSuchMethodException, SecurityException {

		this.target = AppContextUtil.getBean(beanName);
		this.params = params;

		if (StringUtils.isNotBlank(params)) {
			this.method = target.getClass().getDeclaredMethod(methodName, String.class);
		} else {
			this.method = target.getClass().getDeclaredMethod(methodName);
		}
	}

	@Override
	public void run() {
		try {
			// 设置方法可访问
			ReflectionUtils.makeAccessible(method);
			if(StringUtils.isNotBlank(params)){
				method.invoke(target, params);
			}else{
				method.invoke(target);
			}
		}catch (Exception e) {
			log.error("执行定时任务失败", e);
		}
	}

}
