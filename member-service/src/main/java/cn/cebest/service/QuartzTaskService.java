package cn.cebest.service;

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
}
