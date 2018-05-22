package cn.cebest.service;

import java.util.List;
import java.util.Map;
import org.apache.poi.ss.formula.functions.T;
import com.github.pagehelper.PageInfo;
import cn.cebest.entity.QuartzTask;

/**
 * 定时任务 服务接口
 * @author maming
 * @date 2018年5月16日
 */

public interface QuartzTaskService {

	/**
     * 根据ID，查询定时任务
     */
    QuartzTask queryObject(Long jobId);
    
    /**
     * 分页查询定时任务列表
     */
    PageInfo<T> pageList(Map<String, Object> param);
    
    /**
     * 编辑定时任务
     */
    public void updateQuartzTask(QuartzTask quartzTask);
    
    /**
     * 批量更新定时任务状态
     */
    int updateBatchTasksStatus(List<Long> ids,Integer status);

    /**
     * 立即执行
     */
    void run(List<Long> jobIds);

    /**
     * 暂停运行
     */
    void paush(List<Long> jobIds);

    /**
     * 恢复运行
     */
    void resume(List<Long> jobIds);
    
    /**
     * 保存定时任务
     */
    void saveQuartzTask(QuartzTask quartzTask);
}
