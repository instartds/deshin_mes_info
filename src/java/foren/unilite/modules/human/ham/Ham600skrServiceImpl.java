package foren.unilite.modules.human.ham;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("ham600skrService")
public class Ham600skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 비정규직 근태현황 조회 - 일근태
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		
		List dutyCode = selectColumns(param.get("S_COMP_CODE").toString());		
		param.put("DUTY_CODE", dutyCode);
		
		return (List) super.commonDao.list("ham600skrServiceImpl.selectList", param);
	}
	
	/**
	 * 비정규직 근태현황 조회 - 월근태
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		
		List dutyCode = selectColumns(param.get("S_COMP_CODE").toString());		
		param.put("DUTY_CODE", dutyCode);
		
		return (List) super.commonDao.list("ham600skrServiceImpl.selectList2", param);
	}
	
	/**
	 * 월근태 하단 폼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "ham")
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		return (List) super.commonDao.list("ham600skrServiceImpl.selectList3", param);
	}
	
	/**
	 * 컬럼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(String comp_code) throws Exception {
		return (List)super.commonDao.list("ham600skrServiceImpl.selectColumns" ,comp_code);
	}
	

}
