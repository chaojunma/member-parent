package cn.cebest.service;

import com.github.pagehelper.PageInfo;
import cn.cebest.entity.UserInfo;
import cn.cebest.param.UserListParam;
import cn.cebest.param.UserSynchParam;
import cn.cebest.util.Result;
import java.util.Map;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.web.multipart.MultipartFile;


/**
 * 用户接口
 * @author maming
 * @param <T>
 * @date 2018年4月23日
 */
public interface UserService {

	/**
	 * 通过手机号获取用户信息
	 * @param phone
	 * @return
	 */
	public UserInfo findByPhone(String phone);
	
	
	/**
	 * 用户分页查询
	 * @param param
	 * @return
	 */
	public PageInfo<T> pageList(UserListParam param);
	
	
	/**
	 * 添加用户
	 * @param param
	 * @param file
	 */
	public Result synch(UserSynchParam param, MultipartFile file);
	
	
	/**
	 * 用户详情
	 * @param userId
	 * @return
	 */
	public UserInfo detail(String userId);
	
	
	/**
	 * 修改用户信息
	 * @return
	 */
	public int update(Map<String,Object> param, MultipartFile file);
	
	
	/**
	 * 删除用户
	 * @param userId
	 * @return
	 */
	public int delete(String userId);
	
	
	/**
	 *  设置用户状态
	 * @param userId
	 * @param state
	 * @return
	 */
	public int updateState(String userId, String state);
	
	
	/**
	 * 重置密码
	 * @param param
	 * @return
	 */
	public int resetPwd(Map<String,Object> param);
	
	
	/**
	 * 更新session 
	 */
	public void updateSession();
	
	
	/**
	 * 设置用户角色
	 * @param userId
	 * @param roleIds
	 */
	public void setUserRoles(String userId, Integer[] roleIds);
	
	
	
}
