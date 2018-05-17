package cn.cebest.util;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;

/**
 * spring上下文
 * @author maming
 * @date 2018年5月16日
 */
public class AppContextUtil{

	// Spring应用上下文环境
    private static ApplicationContext applicationContext;
    /**
     * 实现ApplicationContextAware接口的回调方法，设置上下文环境
     *
     * @param applicationContext
     */
    public static void setApplicationContext(ApplicationContext applicationContext) {
        AppContextUtil.applicationContext = applicationContext;
    }

    public static ApplicationContext getApplicationContext() {
        return applicationContext;
    }

    public static Object getBean(String name) throws BeansException {
        return applicationContext.getBean(name);
    }

}
