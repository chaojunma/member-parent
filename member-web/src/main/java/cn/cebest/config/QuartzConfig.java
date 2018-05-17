package cn.cebest.config;

import org.quartz.Scheduler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;
import cn.cebest.service.SpringJobFactory;

@Configuration
public class QuartzConfig {

	@Autowired
	private SpringJobFactory springJobFactory;

	@Bean
	public SchedulerFactoryBean schedulerFactoryBean() {
		SchedulerFactoryBean schedulerFactoryBean = new SchedulerFactoryBean();
		schedulerFactoryBean.setJobFactory(springJobFactory);
		 //延时启动 应用启动完20秒后 QuartzScheduler 再启动 
        schedulerFactoryBean.setStartupDelay(20);
		return schedulerFactoryBean;
	}

	@Bean
	public Scheduler scheduler() {
		return schedulerFactoryBean().getScheduler();
	}

}
