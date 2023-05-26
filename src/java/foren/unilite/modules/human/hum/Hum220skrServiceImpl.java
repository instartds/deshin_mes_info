package foren.unilite.modules.human.hum;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hum220skrService")
public class Hum220skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 인사변동사항조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectDataList(Map param) throws Exception {
		
		return (List) super.commonDao.list("hum220skrServiceImpl.selectDataList", param);
	}
	
	
}
