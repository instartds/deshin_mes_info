package foren.unilite.modules.human.hpa;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("hpa950skrService")
public class Hpa950skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	private Map<String, Object> result;
	
	/* 컬럼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("hpa950skrServiceImpl.selectColumns" ,loginVO);
	}
	
	/* 컬럼 조회2
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectColumns2(Map param) throws Exception {
		return (List)super.commonDao.list("hpa950skrServiceImpl.selectColumns2" ,param);
	}
	
	/* 개인 급여 내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("hpa950skrServiceImpl.selectList", param);
	}
		
	public List<Map<String, Object>> getCostPoolName(Map param) throws Exception {
		return (List)super.commonDao.list("hpa950skrServiceImpl.getCostPoolName" ,param);
		
	}
}
