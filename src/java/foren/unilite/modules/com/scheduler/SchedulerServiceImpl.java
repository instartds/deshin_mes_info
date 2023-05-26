package foren.unilite.modules.com.scheduler;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("schedulerService")
public class SchedulerServiceImpl extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "com", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSyTalkId(Map param) throws Exception {
		return super.commonDao.list("schedulerServiceImpl.selectSyTalkId", param);
	}
	
	@ExtDirectMethod(group = "com", value = ExtDirectMethodType.STORE_READ)
	public Map<String, Object> selectBif100(Map param) throws Exception {
		return (Map<String, Object>) super.commonDao.select("schedulerServiceImpl.selectBif100", param);
	}
	@ExtDirectMethod(group = "com", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectSof100(Map param) throws Exception {
		return super.commonDao.list("schedulerServiceImpl.selectSof100", param);
	}
}
