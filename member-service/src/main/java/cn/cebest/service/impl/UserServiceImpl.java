package cn.cebest.service.impl;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.apache.poi.ss.formula.functions.T;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import cn.cebest.constant.Constants;
import cn.cebest.entity.UserInfo;
import cn.cebest.mapper.UserMapper;
import cn.cebest.param.UserListParam;
import cn.cebest.param.UserSynchParam;
import cn.cebest.service.UserService;
import cn.cebest.util.Result;
import cn.cebest.util.ResultCode;
import lombok.extern.slf4j.Slf4j;

/**
 * 用户接口实现
 * @author maming
 * @date 2018年4月23日
 */
@Service
@Slf4j
public class UserServiceImpl implements UserService {

	@Value("${web.upload-path}")
	private String filePath;

	@Autowired
	private UserMapper userMapper;

	/**
	 * 通过手机号获取用户信息
	 * @param phone
	 * @return
	 */
	@Override
	public UserInfo findByPhone(String phone) {
		return userMapper.findByPhone(phone);
	}

	/**
	 * 用户分页查询
	 * @param param
	 * @return
	 */
	@Override
	public PageInfo<T> pageList(UserListParam param) {
		PageHelper.startPage(param.getPageNum(), param.getPageSize());
		List<T> data = userMapper.pageList(param);
		PageInfo<T> pageInfo = new PageInfo<>(data);
		return pageInfo;
	}

	/**
	 * 添加用户
	 * @param param
	 * @param file
	 */
	@Override
	public Result synch(UserSynchParam param, MultipartFile file) {
		
		// 通过手机号查询用户信息
		UserInfo user = userMapper.findByPhone(param.getPhone());
		 // 手机号已被注册
		if(user != null){
			return new Result(ResultCode.PHONE_EXIST_ERROR);
		}
		
		if (file != null && file.getSize() > 0) {
			String[] strs = file.getOriginalFilename().split("\\.");
			// 组装文件名
			String fileName = new Date().getTime() + "." + strs[strs.length - 1];
			param.setPhoto(fileName);
			File targetFile = new File(filePath);
			// 判断文件是否存在
			if (!targetFile.exists()) {
				targetFile.mkdirs();
			}
			try {
				// 保存文件
				FileOutputStream out = new FileOutputStream(filePath + fileName);
				out.write(file.getBytes());
				out.flush();
				out.close();
			} catch (Exception e) {
				log.error("保存用户上传文件异常", e);
			}
		}

		// 保存用户信息
		userMapper.synch(param);

		// 将数据复制到用户数据模型
		user = new UserInfo();
		BeanUtils.copyProperties(param, user);

		// 创建返回对象
		Result result = new Result();
		result.setData(user);
		return result;
	}

	
	
	/**
	 * 用户详情
	 * @param userId
	 * @return
	 */
	@Override
	public UserInfo detail(String userId) {
		return userMapper.detail(userId);
	}

	
	
	/**
	 * 修改用户信息
	 * @return
	 */
	@Override
	public int update(Map<String, Object> param, MultipartFile file) {
		if (file != null && file.getSize() > 0) {
			String[] strs = file.getOriginalFilename().split("\\.");
			// 组装文件名
			String fileName = new Date().getTime() + "." + strs[strs.length - 1];
			param.put("photo", fileName);
			File targetFile = new File(filePath);
			// 判断文件是否存在
			if (!targetFile.exists()) {
				targetFile.mkdirs();
			}
			try {
				// 保存文件
				FileOutputStream out = new FileOutputStream(filePath + fileName);
				out.write(file.getBytes());
				out.flush();
				out.close();
				
				String userId = (String) param.get("id");
				UserInfo user = userMapper.detail(userId);
				if(user.getPhoto() != null) {
					File origin = new File(filePath, user.getPhoto());
					if(origin.exists()){
						// 删除原文件
						origin.delete();
					}
				}
				
			} catch (Exception e) {
				log.error("保存用户上传文件异常", e);
			}
		}
		// 修改用户信息
		return userMapper.update(param);
	}

	
	
	/**
	 * 删除用户
	 * @param userId
	 * @return
	 */
	@Override
	public int delete(String userId) {
		return userMapper.delete(userId);
	}

	
	
	/**
	 *  设置用户状态
	 * @param userId
	 * @param state
	 * @return
	 */
	@Override
	public int updateState(String userId, String state) {
		return userMapper.updateState(userId, state);
	}

	
	
	/**
	 * 重置密码
	 * @param param
	 * @return
	 */
	@Override
	public int resetPwd(Map<String, Object> param) {
		return userMapper.resetPwd(param);
	}

	
	/**
	 * 更新session 
	 */
	@Override
	public void updateSession() {
		// 获取session
		Session session = SecurityUtils.getSubject().getSession();
		UserInfo userInfo = (UserInfo) session.getAttribute(Constants.CURRENT_USER);
		// 获取用户信息
		userInfo = userMapper.detail(String.valueOf(userInfo.getId()));
		// 更新session 
		session.setAttribute(Constants.CURRENT_USER, userInfo);
	}

	
	
	/**
	 * 设置用户角色
	 * @param userId
	 * @param roleIds
	 */
	@Override
	public void setUserRoles(String userId, Integer[] roleIds) {
		// 删除用户角色
		userMapper.delUserRoles(userId);
		if(roleIds != null && roleIds.length > 0){
			// 设置用户角色
			userMapper.setUserRoles(userId, roleIds);
		}
	}

}
