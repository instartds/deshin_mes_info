package foren.unilite.modules.z_kocis;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_hpa950skrService_KOCIS")
public class S_Hpa950skrServiceImpl_KOCIS extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	private Map<String, Object> result;
	
	/* 컬럼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
    public List selectColumns(Map param) throws Exception {
        return (List)super.commonDao.list("s_hpa950skrServiceImpl_KOCIS.selectColumns" ,param);
    }
	
	/* 컬럼 조회2
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectColumns2(Map param) throws Exception {
		return (List)super.commonDao.list("s_hpa950skrServiceImpl_KOCIS.selectColumns2" ,param);
	}
	
	/* 개인 급여 내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("s_hpa950skrServiceImpl_KOCIS.selectList", param);
	}
		
	public List<Map<String, Object>> getCostPoolName(Map param) throws Exception {
		return (List)super.commonDao.list("s_hpa950skrServiceImpl_KOCIS.getCostPoolName" ,param);
		
	}
}
