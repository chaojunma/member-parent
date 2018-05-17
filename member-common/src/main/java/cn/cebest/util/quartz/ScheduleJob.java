package cn.cebest.util.quartz;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.QuartzJobBean;
import cn.cebest.entity.QuartzTask;
import lombok.extern.slf4j.Slf4j;

/**
 * 定时任务
 * @author maming
 * @date 2018年5月16日
 */
@Slf4j
public class ScheduleJob extends QuartzJobBean {

	// 创建单个线程
	private ExecutorService excutorService = Executors.newSingleThreadExecutor();

	@Override
	protected void executeInternal(JobExecutionContext context) throws JobExecutionException {
		QuartzTask scheduleJob = (QuartzTask) context.getMergedJobDataMap().get(QuartzTask.JOB_PARAM_KEY);

		try {
			// 执行任务
			log.info("任务准备执行，任务ID：" + scheduleJob.getId());
			// 创建线程
			ScheduleRunnable task = new ScheduleRunnable(scheduleJob.getTargetBean(), scheduleJob.getTargetMethod(),
					scheduleJob.getParams());
			// 执行线程
			excutorService.submit(task);
		} catch (Exception e) {
			log.error("任务执行失败，任务ID：" + scheduleJob.getId(), e);
		} 
	}

}
