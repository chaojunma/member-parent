package cn.cebest.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

@Configuration
public class JacksonConfig {

	 @Bean
	    public ObjectMapper objectMapper() {
		 	ObjectMapper objectMapper = new ObjectMapper();
		 	// 序列化为NULL时字段不返回
		 	objectMapper.setSerializationInclusion(Include.NON_NULL);
		 	// 对于空的对象转json的时候不抛出错误
		 	objectMapper.disable(SerializationFeature.FAIL_ON_EMPTY_BEANS);
	        return objectMapper;
	    }
}
