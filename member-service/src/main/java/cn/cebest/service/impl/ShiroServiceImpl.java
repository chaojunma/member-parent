package cn.cebest.service.impl;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.apache.poi.ss.formula.functions.T;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.web.filter.mgt.DefaultFilterChainManager;
import org.apache.shiro.web.filter.mgt.PathMatchingFilterChainResolver;
import org.apache.shiro.web.servlet.AbstractShiroFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import cn.cebest.entity.RolePermission;
import cn.cebest.mapper.PermissionMapper;
import cn.cebest.service.ShiroService;
import lombok.extern.slf4j.Slf4j;

/**
 * shiro相关服务
 * @author maming
 * @date 2018年5月7日
 */
@Slf4j
@Service
public class ShiroServiceImpl implements ShiroService{
	
	@Autowired
	private PermissionMapper permissionMapper;

	@Override
	public Map<String, String> loadFilterChainDefinitions() {
		 //拦截器.
        Map<String,String> filterChainDefinitionMap = new LinkedHashMap<String,String>();
        // 配置不会被拦截的链接 顺序判断
        filterChainDefinitionMap.put("/static/**", "anon");
        filterChainDefinitionMap.put("/user/login", "anon");
        //配置退出 过滤器,其中的具体的退出代码Shiro已经替我们实现了
       // filterChainDefinitionMap.put("/user/logout", "logout");
        
        Map<String,Object> param = new HashMap<>();
        param.put("pageNum", "1");
        param.put("pageSize", "0"); // 查询全部
        List<T> data = permissionMapper.pageList(param);
        
        // 添加自定义权限
        for (int i = 0; i < data.size(); i++) {
        	Class<RolePermission>  clazz = RolePermission.class;
        	RolePermission permission = clazz.cast( data.get(i));  
        	String url = permission.getUrl();
        	String permissionV = "perms[" + permission.getPermission() + "]";
        	filterChainDefinitionMap.put(url, permissionV);
		}
        
        filterChainDefinitionMap.put("/**", "user");
        
        return filterChainDefinitionMap;
	}

	
	/**
	 * 重置shiro权限配置
	 * 
	 * @param shiroFilterFactoryBean
	 */
	@Override
	public void reloadFilterChains(ShiroFilterFactoryBean shiroFilterFactoryBean) {
		synchronized (this) {
			AbstractShiroFilter shiroFilter = null;
			try {
				shiroFilter = (AbstractShiroFilter) shiroFilterFactoryBean.getObject();
				PathMatchingFilterChainResolver filterChainResolver = (PathMatchingFilterChainResolver) shiroFilter
						.getFilterChainResolver();
				DefaultFilterChainManager manager = (DefaultFilterChainManager) filterChainResolver.getFilterChainManager();
				// 清空老的权限控制
				manager.getFilterChains().clear();
				shiroFilterFactoryBean.getFilterChainDefinitionMap().clear();
				shiroFilterFactoryBean.setFilterChainDefinitionMap(loadFilterChainDefinitions());
				// 重新构建生成
				Map<String, String> chains = shiroFilterFactoryBean.getFilterChainDefinitionMap();
				for (Map.Entry<String, String> entry : chains.entrySet()) {
					String url = entry.getKey();
					String chainDefinition = entry.getValue().trim().replace(" ", "");
					manager.createChain(url, chainDefinition);
				}
			} catch (Exception e) {
				log.error("重置shiro权限配置异常", e);
			}
		}

	}

}
