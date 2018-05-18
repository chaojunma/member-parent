package cn.cebest.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.PostConstruct;
import org.apache.poi.ss.formula.functions.T;
import org.quartz.CronTrigger;
import org.quartz.Scheduler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import cn.cebest.constant.Constants;
import cn.cebest.entity.QuartzTask;
import cn.cebest.mapper.QuartzTaskMapper;
import cn.cebest.service.QuartzTaskService;
import cn.cebest.util.quartz.ScheduleUtils;

@Service
public class QuartzTaskServiceImpl implements QuartzTaskService {

	@Autowired
	private Scheduler scheduler;

	@Autowired
	private QuartzTaskMapper quartzTaskMapper;

	/**
	 * 项目启动时，初始化定时器
	 */
	@PostConstruct
	public void init() {
		PageHelper.startPage(1, 0); // 查询全部
		List<T> scheduleJobList = quartzTaskMapper.pageList(null);
		for (int i = 0; i < scheduleJobList.size(); i++) {
			QuartzTask scheduleJob = QuartzTask.class.cast(scheduleJobList.get(i));
			CronTrigger cronTrigger = ScheduleUtils.getCronTrigger(scheduler, scheduleJob.getId());
			// 如果不存在，则创建
			if (cronTrigger == null) {
				ScheduleUtils.createScheduleJob(scheduler, scheduleJob);
			} else {
				ScheduleUtils.updateScheduleJob(scheduler, scheduleJob);
			}
		}
	}

	/**
	 * 根据ID，查询定时任务
	 */
	@Override
	public QuartzTask queryObject(Long jobId) {
		return quartzTaskMapper.queryObject(jobId);
	}

	/**
	 * 分页查询定时任务列表
	 */
	@Override
	public PageInfo<T> pageList(Map<String, Object> param) {
		int pageNum = Integer.valueOf((String) param.get("pageNum"));
		int pageSize = Integer.valueOf((String) param.get("pageSize"));
		PageHelper.startPage(pageNum, pageSize);
		List<T> list = quartzTaskMapper.pageList(param);
		PageInfo<T> pageInfo = new PageInfo<>(list);
		return pageInfo;
	}

	/**
	 * 编辑定时任务
	 */
	@Override
	public void updateQuartzTask(QuartzTask quartzTask) {
		quartzTaskMapper.updateById(quartzTask);
		ScheduleUtils.updateScheduleJob(scheduler, quartzTask);
	}

	/**
     * 批量更新定时任务状态
     */
	@Override
	public int updateBatchTasksStatus(List<Long> ids, Integer status) {
		return quartzTaskMapper.updateBatchTasksStatus(ids, status);
	}

	/**
     * 立即执行
     */
	@Override
	public void run(List<Long> jobIds) {
		for (Long jobId : jobIds) {
			ScheduleUtils.run(scheduler, queryObject(jobId));
		}
	}

	/**
     * 暂停运行
     */
	@Override
	public void paush(List<Long> jobIds) {
		for (Long jobId : jobIds) {
			ScheduleUtils.pauseJob(scheduler, jobId);
		}
		updateBatchTasksStatus(jobIds, Constants.QUARTZ_STATUS_PUSH);
	}

	/**
     * 恢复运行
     */
	@Override
	public void resume(List<Long> jobIds) {
		for (Long jobId : jobIds) {
			ScheduleUtils.resumeJob(scheduler, jobId);
		}
		updateBatchTasksStatus(jobIds, Constants.QUARTZ_STATUS_NOMAL);
	}

}
