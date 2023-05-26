package foren.unilite.modules.z_kd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("s_hpa900rkr_kdService")
public class S_Hpa900rkr_kdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 급여 집계 내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("s_hpa900rkr_kdServiceImpl.selectList", param);
	}
	
	/**
	 * 컬럼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("s_hpa900rkr_kdServiceImpl.selectColumns" ,loginVO);
	}

	/* 컬럼 조회2
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectColumns2(Map param) throws Exception {
		return (List)super.commonDao.list("s_hpa900rkr_kdServiceImpl.selectColumns2" ,param);
	}
	
	/**
	 * COST_NAME 가져와서 그리드 컬러명 세팅
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getCostPoolName(Map param) throws Exception {
		return (List)super.commonDao.list("s_hpa900rkr_kdServiceImpl.getCostPoolName" ,param);
		
	}
	
	@ExtDirectMethod(group = "hpa")
	public void createReportData(Map param) throws Exception {
		
		  super.commonDao.update("s_hpa900rkr_kdServiceImpl.createTable", param);

	       Map wagesMap = new HashMap();

		   List<Map> wList1 = (List<Map>) super.commonDao.list("s_hpa900rkr_kdServiceImpl.selectWages1", param);

			for(Map wCode : wList1) {

				wCode.put("SEQ",      wCode.get("SEQ"));
				wCode.put("SUB_CODE", wCode.get("SUB_CODE"));
				wCode.put("CODE_NAME", wCode.get("CODE_NAME"));

				super.commonDao.insert("s_hpa900rkr_kdServiceImpl.insertWages1", wCode);

			 }

			List<Map> wList2 = (List<Map>) super.commonDao.list("s_hpa900rkr_kdServiceImpl.selectWages2", param);

			for(Map wCode : wList2) {

				wCode.put("SEQ",      wCode.get("SEQ"));
				wCode.put("SUB_CODE", wCode.get("SUB_CODE"));
				wCode.put("CODE_NAME", wCode.get("CODE_NAME"));

				super.commonDao.insert("s_hpa900rkr_kdServiceImpl.insertWages2", wCode);

			 }

			List<Map> wList3 = (List<Map>) super.commonDao.list("s_hpa900rkr_kdServiceImpl.selectWages3", param);

			for(Map wCode : wList3) {

				wCode.put("SEQ",      wCode.get("SEQ"));
				wCode.put("WAGES_CODE", wCode.get("WAGES_CODE"));
				wCode.put("WAGES_NAME", wCode.get("WAGES_NAME"));
				wCode.put("WAGES_SEQ", wCode.get("WAGES_SEQ"));

				super.commonDao.insert("s_hpa900rkr_kdServiceImpl.insertWages3", wCode);

			 }
	}
}
