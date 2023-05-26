package foren.unilite.modules.human.ham;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ham900skrService")
public class Ham900skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 분기별 일용근로소득내용조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("ham900skrServiceImpl.selectList", param);
	}
	

}
