package cn.cebest.util;

import java.util.List;
import com.github.pagehelper.PageInfo;
import lombok.Getter;
import lombok.Setter;


/**
 *  分页返回数据封装类
 * @author maming
 * @date 2018年4月24日
 */
@Setter
@Getter
public class PageResult<T> {
	
	private Long totalCount = 0L;  //总条数
	
	private List<T> data;  //结果集

	public PageResult(Long totalCount,List<T> data){
		this.totalCount = totalCount;
		this.data = data;
	}
	
	public PageResult(PageInfo<T> pageInfo) {
	    if(pageInfo != null){
	    	this.totalCount = pageInfo.getTotal();
		    this.data = pageInfo.getList();
	    }
	}
}
