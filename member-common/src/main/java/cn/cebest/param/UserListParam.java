package cn.cebest.param;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UserListParam extends PageQueryParam{

	private String key; // 查询关键字
}
