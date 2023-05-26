package foren.unilite.modules.human.hpa;

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

@Service("hpa900rkrService")
public class Hpa900rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 급여 집계 내역 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("hpa900rkrServiceImpl.selectList", param);
	}
	
	/**
	 * 컬럼 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("hpa900rkrServiceImpl.selectColumns" ,loginVO);
	}

	/* 컬럼 조회2
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectColumns2(Map param) throws Exception {
		return (List)super.commonDao.list("hpa900rkrServiceImpl.selectColumns2" ,param);
	}
	
	/**
	 * COST_NAME 가져와서 그리드 컬러명 세팅
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getCostPoolName(Map param) throws Exception {
		return (List)super.commonDao.list("hpa900rkrServiceImpl.getCostPoolName" ,param);
		
	}
	
	@ExtDirectMethod(group = "hpa")
	public void createReportData(Map param) throws Exception {
		
		  super.commonDao.update("hpa900rkrServiceImpl.createTable", param);

	       Map wagesMap = new HashMap();

		   List<Map> wList1 = (List<Map>) super.commonDao.list("hpa900rkrServiceImpl.selectWages1", param);

			for(Map wCode : wList1) {

				wCode.put("SEQ",      wCode.get("SEQ"));
				wCode.put("SUB_CODE", wCode.get("SUB_CODE"));
				wCode.put("CODE_NAME", wCode.get("CODE_NAME"));

				super.commonDao.insert("hpa900rkrServiceImpl.insertWages1", wCode);

			 }

			List<Map> wList2 = (List<Map>) super.commonDao.list("hpa900rkrServiceImpl.selectWages2", param);

			for(Map wCode : wList2) {

				wCode.put("SEQ",      wCode.get("SEQ"));
				wCode.put("SUB_CODE", wCode.get("SUB_CODE"));
				wCode.put("CODE_NAME", wCode.get("CODE_NAME"));

				super.commonDao.insert("hpa900rkrServiceImpl.insertWages2", wCode);

			 }

			List<Map> wList3 = (List<Map>) super.commonDao.list("hpa900rkrServiceImpl.selectWages3", param);

			for(Map wCode : wList3) {

				wCode.put("SEQ",      wCode.get("SEQ"));
				wCode.put("WAGES_CODE", wCode.get("WAGES_CODE"));
				wCode.put("WAGES_NAME", wCode.get("WAGES_NAME"));
				wCode.put("WAGES_SEQ", wCode.get("WAGES_SEQ"));

				super.commonDao.insert("hpa900rkrServiceImpl.insertWages3", wCode);

			 }
	}
	
	/**
	 * COST_NAME 가져와서 그리드 컬러명 세팅
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectListPrint1356(Map param) throws Exception {
		return (List)super.commonDao.list("hpa900rkrServiceImpl.selectListPrint1356" ,param);
	}
	public List<Map<String, Object>> selectListPrint56(Map param) throws Exception {
		return (List)super.commonDao.list("hpa900rkrServiceImpl.selectListPrint56" ,param);
	}
	public List<Map<String, Object>> selectListPrint4(Map param) throws Exception {
		return (List)super.commonDao.list("hpa900rkrServiceImpl.selectListPrint4" ,param);
	}
	public List<Map<String, Object>> selectListPrint2(Map param) throws Exception {
		return (List)super.commonDao.list("hpa900rkrServiceImpl.selectListPrint2" ,param);
	}
	
	/**
	 * COST_NAME 가져와서 그리드 컬러명 세팅
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectSubListPrint12356(Map param) throws Exception {
		return (List)super.commonDao.list("hpa900rkrServiceImpl.selectSubListPrint12356" ,param);
	}
	public List<Map<String, Object>> selectSubListPrint56(Map param) throws Exception {
		return (List)super.commonDao.list("hpa900rkrServiceImpl.selectSubListPrint56" ,param);
	}
	public List<Map<String, Object>> selectSubListPrint4(Map param) throws Exception {
		return (List)super.commonDao.list("hpa900rkrServiceImpl.selectSubListPrint4" ,param);
	}
}
