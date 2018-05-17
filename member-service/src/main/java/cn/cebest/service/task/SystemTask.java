package cn.cebest.service.task;

import org.springframework.stereotype.Component;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component("systemTask")
public class SystemTask {

	public void job(){
		log.info("===========我被执行了===============");
	}
}
