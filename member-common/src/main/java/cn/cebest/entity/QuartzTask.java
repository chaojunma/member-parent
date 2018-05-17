package cn.cebest.entity;

import lombok.Data;

/**
 * 任务实体
 * @author maming
 * @date 2018年5月16日
 */

@Data
public class QuartzTask {

	/**
	 * 任务调度参数key
	 */
	public static final String JOB_PARAM_KEY = "JOB_PARAM_KEY";
	
	/**
	 * 主键ID
	 */
	private Long id;

	/**
	 * 任务名称
	 */
	private String name;
	/**
	 * 任务表达式
	 */
	private String cron;
	/**
	 * 执行的类
	 */
	private String targetBean;
	/**
	 * 执行方法
	 */
	private String targetMethod;
	/**
	 * 执行参数
	 */
	private String params;
	/**
	 * 任务状态 0:正常 1：暂停
	 */
	private Integer status;
	/**
	 * 创建时间
	 */
	private String createTime;
	/**
	 * 创建人
	 */
	private Integer createBy;
	/**
	 * 更新时间
	 */
	private String updateTime;
	/**
	 * 更新人
	 */
	private Integer updateBy;
	/**
	 * 备注
	 */
	private String remarks;
	/**
	 * 是否删除
	 */
	private Integer isDelete;

}
