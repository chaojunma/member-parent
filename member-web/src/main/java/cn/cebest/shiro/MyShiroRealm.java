package cn.cebest.shiro;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.SimplePrincipalCollection;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import cn.cebest.entity.RolePermission;
import cn.cebest.entity.UserInfo;
import cn.cebest.entity.UserRole;
import cn.cebest.service.UserService;
import lombok.extern.slf4j.Slf4j;

/**
 * 自定义权限认证
 * @author maming
 * @date 2018/4/9
 */

@Slf4j
public class MyShiroRealm extends AuthorizingRealm{
	
	@Autowired
	private UserService userService;
	
	
	/*主要是用来进行身份认证的，也就是说验证用户输入的账号和密码是否正确。*/
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
		log.info("shiro身份认证开始...");
		//获取用户的输入的账号
		String userName = String.valueOf(token.getPrincipal());
		String password =  String.valueOf(token.getCredentials());
		log.info("登录用户的用户名为:{},密码为:{}",userName, password);
		
		//通过username从数据库中查找 User对象，如果找到，没找到.
	    //实际项目中，这里可以根据实际情况做缓存，如果不做，Shiro自己也是有时间间隔机制，2分钟内不会重复执行该方法
	    UserInfo userInfo = userService.findByPhone(userName);
	    log.info("userInfo:{}", userInfo);
	    if(userInfo == null){
	        return null;
	    }
	    
	    SimpleAuthenticationInfo authenticationInfo = new SimpleAuthenticationInfo(
	            userInfo, //用户名
	            userInfo.getPassword(), //密码
	            getName()  //realm name
	    );
	    
 		return authenticationInfo;
	}
	

	/*权限认证及权限分配*/
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
		log.info("权限分配开始...");
		SimpleAuthorizationInfo authorizationInfo = new SimpleAuthorizationInfo();
	    UserInfo userInfo  = (UserInfo)principals.getPrimaryPrincipal();
	    for(UserRole role:userInfo.getRoleList()){
	    	// 添加角色
	        authorizationInfo.addRole(role.getRoleCode());
	        if(!role.getPermissions().isEmpty()){
	        	// 获取用户所有权限(可以在数据库配置好或灵活配置)
		        for(RolePermission p:role.getPermissions()){
		        	// 添加权限
		            if(StringUtils.isNotEmpty(p.getPermission())){
		            	authorizationInfo.addStringPermission(p.getPermission());
		            }
		        }
	        }
	    }
	    return authorizationInfo;
	}

	
	
	/** 
     * 重新赋值权限(在比如:给一个角色临时添加一个权限,需要调用此方法刷新权限,否则还是没有刚赋值的权限) 
     * @param myRealm 自定义的realm 
     * @param username 用户名 
     */  
    public static void reloadAuthorizing(MyShiroRealm myRealm,Object user){  
        Subject subject = SecurityUtils.getSubject();   
        String realmName = subject.getPrincipals().getRealmNames().iterator().next();   
        //第一个参数为用户名,第二个参数为realmName,test想要操作权限的用户   
        SimplePrincipalCollection principals = new SimplePrincipalCollection(user, realmName);
        // 重新加载
        subject.runAs(principals);   
    } 
	
}
