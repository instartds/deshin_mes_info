package foren.unilite.modules.human.hrt;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
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
import foren.unilite.com.validator.UniDirectValidateException;


@Service("hrt700skrService")
public class Hrt700skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		logger.debug("Hrt700skrServiceImpl.selectList1");
		return (List) super.commonDao.list("hrt700skrServiceImpl.selectList1", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		logger.debug("Hrt700skrServiceImpl.selectList2");
		return (List) super.commonDao.list("hrt700skrServiceImpl.selectList2", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		logger.debug("Hrt700skrServiceImpl.selectList32");
		return (List) super.commonDao.list("hrt700skrServiceImpl.selectList3", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectSub1(Map param) throws Exception {
		logger.debug("Hrt700skrServiceImpl.selectSub1");
		return (List) super.commonDao.list("hrt700skrServiceImpl.selectSub1", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectSub2(Map param) throws Exception {
		logger.debug("Hrt700skrServiceImpl.selectSub2");
		return (List) super.commonDao.list("hrt700skrServiceImpl.selectSub2", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectSub3(Map param) throws Exception {
		logger.debug("Hrt700skrServiceImpl.selectSub3");
		return (List) super.commonDao.list("hrt700skrServiceImpl.selectSub3", param);
	}

	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectSub4(Map param) throws Exception {
		logger.debug("Hrt700skrServiceImpl.selectSub4");
		return (List) super.commonDao.list("hrt700skrServiceImpl.selectSub4", param);
	}
	
	@ExtDirectMethod(group = "hrt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		return super.commonDao.list("hrt700skrServiceImpl.selectExcelUploadSheet1", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectExists(Map param) throws Exception {
		logger.debug("Hrt700skrServiceImpl.selectExists");
		return (List) super.commonDao.list("hrt700skrServiceImpl.selectExists", param);
	}


	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "hrt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)	{
			List<Map> insertList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertList")) {
					insertList = (List<Map>)dataListMap.get("data");
				} 
			}			
			if(insertList != null) this.insertList(insertList, user, dataMaster);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	/**추가**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hrt")
	public Integer insertList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		/* 데이터 insert */
		try {
			for(Map param : paramList )	{	
				super.commonDao.insert("hrt700skrServiceImpl.insert", param);
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}
		
		return 0;
	}	

	
	
	
	
	/**
	 * 퇴직급여 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("hrt700skrServiceImpl.getData", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  { 
                param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE", data.get("COMP_CODE"));
				param.put("PERSON_NUMB", data.get("PERSON_NUMB"));
				param.put("RETR_DATE", data.get("RETR_DATE"));
				param.put("RETR_TYPE", data.get("RETR_TYPE"));
				
				//업로드 된 데이터의 사번 등록여부 확인
				String custExistYn =  (String) super.commonDao.select("hrt700skrServiceImpl.checkPersonNum", param);
				if (custExistYn.equals("N")) {
					param.put("MSG", "사번 [" + data.get("PERSON_NUMB") +"]을 확인하십시오.");
					super.commonDao.update("hrt700skrServiceImpl.insertErrorMsg", param);
				}
				
				//업로드 된 데이터의 정산일 등록여부 확인
				String retrExistYn =  (String) super.commonDao.select("hrt700skrServiceImpl.checkRetrDate", param);
				if (retrExistYn.equals("Y")) {
					param.put("MSG", "정산일 [" + data.get("RETR_DATE") +"]이 존재합니다..");
					super.commonDao.update("hrt700skrServiceImpl.insertErrorMsg", param);
				}
				
			}
		}
	}

	
}
	
