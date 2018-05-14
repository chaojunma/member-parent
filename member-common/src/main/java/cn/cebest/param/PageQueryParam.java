package cn.cebest.param;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class PageQueryParam {
	
	//页号
	private Integer pageNum = 1;
	
	//每页显示的条数
	private Integer pageSize = 10;

}
