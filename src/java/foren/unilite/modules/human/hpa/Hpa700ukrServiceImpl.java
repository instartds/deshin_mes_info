package foren.unilite.modules.human.hpa;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hpa700ukrService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Hpa700ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ,group = "hpa")
	public List<Map> selectList1(Map param, LoginVO loginVO) throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
		List<Map> result = new ArrayList();
		String arr[] = param.toString().split(",");
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		if(param.get("PROV_GUBUN").equals("1")){
			result = (List) super.commonDao.list("hpa700ukrServiceImpl.selectList1_1", param);
		}else if(param.get("PROV_GUBUN").equals("2")){
			result = (List) super.commonDao.list("hpa700ukrServiceImpl.selectList1_2", param);
		}
		return result;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map<String, Object>> selectList2(Map param, LoginVO loginVO) throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("USER_ID", loginVO.getUserID());
		String arr[] = param.toString().split(",");
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		List<Map<String, Object>> result = new ArrayList();
		if(param.get("rdoSelect").equals("1")){
			result = (List) super.commonDao.list("hpa700ukrServiceImpl.selectList2_1", param);
		}else if(param.get("rdoSelect").equals("2")){
			result = (List) super.commonDao.list("hpa700ukrServiceImpl.selectList2_2", param);
		}
		return result;
	}



	/**
	 * 추가
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> insertList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			String TO = (String)param.get("PAY_TO_YYYYMM");
			String FR = (String)param.get("PAY_FR_YYYYMM");
			param.put("PAY_TO_YYYYMM", TO.replace(".", ""));
			param.put("PAY_FR_YYYYMM", FR.replace(".", ""));
			param.put("rdoSelect", paramMaster.get("rdoSelect"));

			String arr[] = param.toString().split(",");
			for(int i=0;i<arr.length;i++){
				System.out.println(arr[i]);
			}
			super.commonDao.insert("hpa700ukrServiceImpl.insertList", param);
		}
		return paramList;
	}

	/**
	 * 수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> updateList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		for(Map param :paramList ) {	
			String TO = (String)param.get("PAY_TO_YYYYMM");
			String FR = (String)param.get("PAY_FR_YYYYMM");
			param.put("PAY_TO_YYYYMM", TO.replace(".", ""));
			param.put("PAY_FR_YYYYMM", FR.replace(".", ""));
			param.put("rdoSelect", paramMaster.get("rdoSelect"));

			String arr[] = param.toString().split(",");
			for(int i=0;i<arr.length;i++){
				System.out.println(arr[i]);
			}

			super.commonDao.update("hpa700ukrServiceImpl.updateList", param);
		}
		return paramList;
	}

	/**
	 * 삭제
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> deleteList(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			String TO = (String)param.get("PAY_TO_YYYYMM");
			String FR = (String)param.get("PAY_FR_YYYYMM");
			param.put("PAY_TO_YYYYMM", TO.replace(".", ""));
			param.put("PAY_FR_YYYYMM", FR.replace(".", ""));
			param.put("rdoSelect", paramMaster.get("rdoSelect"));

			super.commonDao.delete("hpa700ukrServiceImpl.deleteList", param);
		}	
		return paramList;
	}

	// sync All
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertList != null) this.insertList(insertList, dataMaster, user);
			if(updateList != null) this.updateList(updateList, dataMaster, user);
			if(deleteList != null) this.deleteList(deleteList, dataMaster, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}



	/**
	 * 엑셀의 내용을 읽어옴
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		return super.commonDao.list("hpa700ukrServiceImpl.selectExcelUploadSheet1", param);
	}

	public void excelValidate(String jobID, Map param) {
		logger.debug("validate: {}", jobID);
		super.commonDao.update("hpa700ukrServiceImpl.excelValidate", param);
	}

	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_READ)		// 엑셀데이터 저장
	public void saveExcelData(Map param) throws Exception {
		super.commonDao.update("hpa700ukrServiceImpl.saveExcel", param);
	}

	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_READ)		// 301T insert
	public int insertExcelData(Map param) throws Exception {
		return super.commonDao.update("hpa700ukrServiceImpl.insertExcelHpa700T", param);
	}



	/**
	 * 20200720 추가: 엑셀업로드2(주민등록번호 기준)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate2(String jobID, Map param) {
		logger.debug("validate: {}", jobID);
		super.commonDao.update("hpa700ukrServiceImpl.excelValidate2", param);
	}

	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet2(Map param) throws Exception {
		return super.commonDao.list("hpa700ukrServiceImpl.selectExcelUploadSheet2", param);
	}

	@ExtDirectMethod(group = "hpa", value = ExtDirectMethodType.STORE_READ)
	public int insertExcelData2(Map param) throws Exception {
		super.commonDao.update("hpa700ukrServiceImpl.insertExcelHpa700T2_1", param);
		return super.commonDao.update("hpa700ukrServiceImpl.insertExcelHpa700T2_2", param);
	}
}