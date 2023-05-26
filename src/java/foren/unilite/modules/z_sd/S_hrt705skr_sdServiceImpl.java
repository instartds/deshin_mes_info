package foren.unilite.modules.z_sd;

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


@Service("s_hrt705skr_sdService")
public class S_hrt705skr_sdServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		logger.debug("s_hrt705skr_sdServiceImpl.selectList1");
		return (List) super.commonDao.list("s_hrt705skr_sdServiceImpl.selectList1", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		logger.debug("s_hrt705skr_sdServiceImpl.selectList2");
		return (List) super.commonDao.list("s_hrt705skr_sdServiceImpl.selectList2", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		logger.debug("s_hrt705skr_sdServiceImpl.selectList32");
		return (List) super.commonDao.list("s_hrt705skr_sdServiceImpl.selectList3", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectSub1(Map param) throws Exception {
		logger.debug("s_hrt705skr_sdServiceImpl.selectSub1");
		return (List) super.commonDao.list("s_hrt705skr_sdServiceImpl.selectSub1", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectSub2(Map param) throws Exception {
		logger.debug("s_hrt705skr_sdServiceImpl.selectSub2");
		return (List) super.commonDao.list("s_hrt705skr_sdServiceImpl.selectSub2", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectSub3(Map param) throws Exception {
		logger.debug("s_hrt705skr_sdServiceImpl.selectSub3");
		return (List) super.commonDao.list("s_hrt705skr_sdServiceImpl.selectSub3", param);
	}

	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectSub4(Map param) throws Exception {
		logger.debug("s_hrt705skr_sdServiceImpl.selectSub4");
		return (List) super.commonDao.list("s_hrt705skr_sdServiceImpl.selectSub4", param);
	}
	
	@ExtDirectMethod(group = "hrt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		return super.commonDao.list("s_hrt705skr_sdServiceImpl.selectExcelUploadSheet1", param);
	}
	
	@ExtDirectMethod(group = "hrt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet2(Map param) throws Exception {
		return super.commonDao.list("s_hrt705skr_sdServiceImpl.selectExcelUploadSheet2", param);
	}
	
	@ExtDirectMethod(group = "hrt")
	public List<Map<String, Object>> selectExists(Map param) throws Exception {
		logger.debug("s_hrt705skr_sdServiceImpl.selectExists");
		return (List) super.commonDao.list("s_hrt705skr_sdServiceImpl.selectExists", param);
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
		//try {
			for(Map param : paramList )	{
				//logger.debug("[[param]]" + param);
				super.commonDao.update("s_hrt705skr_sdServiceImpl.insertList", param);
				
				if( param.get("BONUS_TYPE").equals("급여")){
					param.put("BONUS_TYPE",'1');
					super.commonDao.insert("s_hrt705skr_sdServiceImpl.insertAmount", param);
				}else if( param.get("BONUS_TYPE").equals("연차")){
					param.put("BONUS_TYPE",'F');
					super.commonDao.insert("s_hrt705skr_sdServiceImpl.insertYear", param);
				}else{
					param.put("BONUS_TYPE",'4');
					super.commonDao.insert("s_hrt705skr_sdServiceImpl.insertBonus", param);
				}
			}	
		//}
//		catch(Exception e){
//			throw new  UniDirectValidateException(this.getMessage("저장 중 오류가 발생했습니다.",user));
//		}
		
		return 0;
	}	

	
	
	

	/**
	 * 퇴직급여 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate1(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("s_hrt705skr_sdServiceImpl.getData1", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  { 
                param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE", data.get("COMP_CODE"));
			
			}
		}
	}
	
	/**
	 * 퇴직급여 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate2(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("s_hrt705skr_sdServiceImpl.getData2", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  { 
                param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE", data.get("COMP_CODE"));
			
			}
		}
	}

	
}
	
