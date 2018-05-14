package cn.cebest.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.poi.ss.formula.functions.T;
import cn.cebest.entity.UserInfo;
import cn.cebest.param.UserListParam;
import cn.cebest.param.UserSynchParam;

/**
 * 用户DAO接口
 * @author maming
 * @date 2018年4月23日
 */
@Mapper
public interface UserMapper {

	/**
	 * 通过手机号获取用户信息
	 * @param phone
	 * @return
	 */
	public UserInfo findByPhone(@Param("phone")String phone);
	
	
	/**
	 * 用户分页查询
	 * @param param
	 * @return
	 */
	public List<T> pageList(UserListParam param);
	
	
	/**
	 * 添加用户
	 * @param param
	 * @param file
	 */
	public void synch(UserSynchParam param);
	
	
	/**
	 * 用户详情
	 * @param userId
	 * @return
	 */
	public UserInfo detail(@Param("id")String id);
	
	
	
	/**
	 * 修改用户信息
	 * @return
	 */
	public int update(Map<String,Object> param);
	
	
	
	/**
	 * 删除用户
	 * @param userId
	 * @return
	 */
	public int delete(@Param("id")String id);
	
	
	/**
	 *  设置用户状态
	 * @param userId
	 * @param state
	 * @return
	 */
	public int updateState(@Param("id")String id, @Param("state")String state);
	
	
	/**
	 * 重置密码
	 * @param param
	 * @return
	 */
	public int resetPwd(Map<String,Object> param);
	
	
	/**
	 * 设置用户角色
	 * @param userId
	 * @param roleIds
	 */
	public void setUserRoles(@Param("userId")String userId, @Param("roleIds")Integer[] roleIds);
	
	
	/**
	 * 删除用户角色
	 * @param userId
	 * @return
	 */
	public int delUserRoles(String userId);
}
