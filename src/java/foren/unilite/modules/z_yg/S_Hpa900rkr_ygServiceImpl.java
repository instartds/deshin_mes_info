package foren.unilite.modules.z_yg;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_hpa900rkr_ygService")
public class S_Hpa900rkr_ygServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 급여 집계 내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("s_hpa900rkr_ygServiceImpl.selectList", param);
	}
	
	/**
	 * 컬럼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("s_hpa900rkr_ygServiceImpl.selectColumns" ,loginVO);
	}

	/* 컬럼 조회2
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectColumns2(Map param) throws Exception {
		return (List)super.commonDao.list("s_hpa900rkr_ygServiceImpl.selectColumns2" ,param);
	}
	
	/**
	 * COST_NAME 가져와서 그리드 컬러명 세팅
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getCostPoolName(Map param) throws Exception {
		return (List)super.commonDao.list("s_hpa900rkr_ygServiceImpl.getCostPoolName" ,param);
		
	}

}
