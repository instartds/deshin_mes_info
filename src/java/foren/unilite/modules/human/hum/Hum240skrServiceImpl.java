package foren.unilite.modules.human.hum;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hum240skrService")
public class Hum240skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 연간입퇴사자 목록 조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectDataList(Map param) throws Exception {
		
		return (List) super.commonDao.list("hum240skrServiceImpl.selectDataList", param);
	}
	
	
}
