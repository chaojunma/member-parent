package cn.cebest.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import cn.cebest.interceptor.SessionInterceptor;


/**
 * 配置拦截器
 * @author maming
 * date 2018年5月9日
 */

@Configuration
public class WebMvcConfig extends WebMvcConfigurerAdapter {

	
	/**
     * 此方法把该拦截器实例化成一个bean,否则在拦截器里无法注入其它bean
     * @return
     */
    @Bean
    SessionInterceptor sessionInterceptor() {
        return new SessionInterceptor();
    }
    /**
     * 配置拦截器
     * @param registry
     */
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(sessionInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns("/login");
    }
	
	
}
