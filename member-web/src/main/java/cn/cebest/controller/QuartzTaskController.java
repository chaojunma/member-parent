package cn.cebest.controller;

import java.util.List;
import java.util.Map;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.github.pagehelper.PageInfo;
import cn.cebest.entity.QuartzTask;
import cn.cebest.service.QuartzTaskService;
import cn.cebest.util.PageResult;
import cn.cebest.util.Result;
import cn.cebest.util.ResultCode;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/task")
public class QuartzTaskController extends BaseController{
	
	@Autowired
	private QuartzTaskService quartzTaskService;

	/**
	 * 定时任务列表
	 * @param param
	 * @return
	 */
	@RequestMapping(value="/list", method=RequestMethod.GET)
	@ResponseBody
	public PageResult<T> list(@RequestParam Map<String, Object> param){
		PageInfo<T> pageInfo = quartzTaskService.pageList(param);
		PageResult<T> result  = new PageResult<>(pageInfo);
		return result;
	}
	
	
	/**
	 * 获取任务详情
	 * @param taskId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/{taskId:\\d+}", method=RequestMethod.GET)
	public String detail(@PathVariable("taskId") long taskId, ModelMap model){
		QuartzTask quartzTask = quartzTaskService.queryObject(taskId);
		model.put("quartzTask", quartzTask);
		return "/task_detail";
	}
	
	
	/**
	 * 编辑定时任务
	 * @param quartzTask
	 * @return
	 */
	@RequestMapping(value="/{taskId:\\d+}", method=RequestMethod.POST)
	@ResponseBody
	public Result modify(@PathVariable("taskId") long taskId, QuartzTask quartzTask){
		try {
			quartzTask.setUpdateBy(currentUser.getId());
			quartzTaskService.updateQuartzTask(quartzTask);
			return new Result();
		} catch (Exception e) {
			log.error("编辑定时任务异常", e);
			return new Result(ResultCode.SERVER_ERROR);
		}
	}
	
	
	/**
	 * 批量停止定时任务
	 * @param ids
	 * @return
	 */
	@RequestMapping(value="/paush", method=RequestMethod.POST)
	@ResponseBody
    public Result paush(@RequestParam(value = "ids[]",required = false)List<Long> ids){
        try {
			quartzTaskService.paush(ids);
			return new Result();
		} catch (Exception e) {
			log.error("停止定时任务异常", e);
			return new Result(ResultCode.SERVER_ERROR);
		}
    }
	
	
	/**
	 * 批量启动定时任务
	 * @param ids
	 * @return
	 */
	@RequestMapping(value="/resume", method=RequestMethod.POST)
	@ResponseBody
    public Result resume(@RequestParam(value = "ids[]",required = false)List<Long> ids){
        try {
			quartzTaskService.resume(ids);
			return new Result();
		} catch (Exception e) {
			log.error("启动定时任务异常", e);
			return new Result(ResultCode.SERVER_ERROR);
		}
    }
}
