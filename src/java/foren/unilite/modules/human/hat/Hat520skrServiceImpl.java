package foren.unilite.modules.human.hat;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hat520skrService")
public class Hat520skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 일근태현황조회  
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List<Map<String, Object>> selectList(Map param) throws Exception {		
		List dutyCode = selectDutycode(param.get("S_COMP_CODE").toString());		
		param.put("DUTY_CODE", dutyCode);		
		return (List) super.commonDao.list("hat520skrServiceImpl.selectDataList", param);
	}
	
	/**
	 * 근태코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectDutycode(String comp_code) throws Exception {
		return (List)super.commonDao.list("hat520skrServiceImpl.selectDutycode" ,comp_code);
	}
	
	
}
