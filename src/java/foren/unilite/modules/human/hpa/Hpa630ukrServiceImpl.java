package foren.unilite.modules.human.hpa;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.slf4j.Logger;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("hpa630ukrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Hpa630ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> selectListYear1(Map param) throws Exception {
		return (List) super.commonDao.list("hpa630ukrServiceImpl.selectListYear1", param);
	}

	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> selectListYear2(Map param) throws Exception {
		return (List) super.commonDao.list("hpa630ukrServiceImpl.selectListYear2", param);
	}

	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> selectListMonth1(Map param) throws Exception {
		return (List) super.commonDao.list("hpa630ukrServiceImpl.selectListMonth1", param);
	}

	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> selectListMonth2(Map param) throws Exception {
		return (List) super.commonDao.list("hpa630ukrServiceImpl.selectListMonth2", param);
	}

	@ExtDirectMethod(group = "hpa")
	public List<Map<String, Object>> selectListInfo(Map param) throws Exception {
		return (List) super.commonDao.list("hpa630ukrServiceImpl.selectListInfo", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpa")
	public String selectiwallyn(Map param) throws Exception {
		return (String) super.commonDao.select("hpa630ukrServiceImpl.selectiwallyn", param);
	}

//	@ExtDirectMethod(group = "hpa")
//	public int updateYear(Hpa630ukrModel param) throws Exception {
//		return super.commonDao.update("hpa630ukrServiceImpl.updateYear", param);
//	}
//
//	@ExtDirectMethod(group = "hpa")
//	public int updateMonth(Hpa630ukrModel param) throws Exception {
//		return super.commonDao.update("hpa630ukrServiceImpl.updateMonth", param);
//	}



	/**
	 * 년월차일수 조정 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
//	public void updateForm(Map params, LoginVO user) throws Exception {
//		super.commonDao.update("hpa630ukrServiceImpl.updateForm", params);
//	}

	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hpa")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null) {
			List<Map> updateList = null;
			List<Map> insertList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList != null) this.updateDetail(updateList, user);
			if(insertList != null) this.insertList(insertList, user);
		}
		paramList.add(0, paramMaster);
		return paramList;
	}
	
	/**
	 * 수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {			
			
			
			/*String arr[] = param.toString().split(",");
			for(int i=0;i<arr.length;i++){
				System.out.println(arr[i]);
			}*/
			
			super.commonDao.update("hpa630ukrServiceImpl.updateForm", param);							
		}
		return paramList;
	}

	/** 추가
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hpa")
	public List<Map> insertList(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList) {
			/*String arr[] = param.toString().split(",");
			for(int i=0;i<arr.length;i++){
				System.out.println(arr[i]);
			}*/
			super.commonDao.update("hpa630ukrServiceImpl.updateForm", param);
		}
		return paramList;
	}

	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		return super.commonDao.list("hpa630ukrServiceImpl.selectExcelUploadSheet1", param);
	}

	public void excelValidate1(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("hpa630ukrServiceImpl.getData1", param);

		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData ) { 
				param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE", data.get("COMP_CODE"));
			}
		}
	}
}