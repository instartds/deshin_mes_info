package foren.unilite.modules.z_jw;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.google.gson.Gson;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("s_hbo300ukr_jwService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Hbo300ukr_jwServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 조회
	 * 
	 * @param param	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbo")
	public List<Map<String, Object>> selectList(Map param, LoginVO loginVO) throws Exception {
	
		System.out.println(param.toString());
		
		return (List) super.commonDao.list("s_hbo300ukr_jwServiceImpl.selectList", param);
//		return null;
	}
	
	/**
	 * 일괄등록 프로시져 실행 
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbo")
	public Map procHbo300(Map param, LoginVO loginVO) throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("S_USER_ID", loginVO.getUserID());
		
		System.out.println(param.toString());		
		Map result = (Map)super.commonDao.queryForObject("s_hbo300ukr_jwServiceImpl.proc", param);		
		
		String errorDesc = "";
		errorDesc = (String) result.get("ERROR_CODE");
		
		if(!ObjUtils.isEmpty(errorDesc)){			
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[1], loginVO));
		}
		
		return result;
		
	}
	/**
	 * saveAll
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 
		if(paramList != null)	{
			List<Map> deleteList = null;
			List<Map> updateList = null;
			List<Map> insertList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete")) {
					deleteList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} else if(dataListMap.get("method").equals("insert")) {
					insertList = (List<Map>)dataListMap.get("data");	
				}
			}			
			if(deleteList != null) this.delete(deleteList, user);
			if(updateList != null) this.update(updateList, user);				
			if(insertList != null) this.insert(insertList, user);				
		}
	 	paramList.add(0, paramMaster);
			
	 	return  paramList;
	}
	
	/**
	 * 입력
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbo")
	public List<Map> insert(List<Map> paramList,LoginVO loginVO) throws Exception {
		for(Map param :paramList )	{			
			super.commonDao.update("s_hbo300ukr_jwServiceImpl.insert", param);
		}
		System.out.println(paramList.toString());
		return paramList;
	}
	
	/**
	 * 수정
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbo")
	public List<Map> update(List<Map> paramList,LoginVO loginVO) throws Exception {
		for(Map param :paramList )	{			
			super.commonDao.update("s_hbo300ukr_jwServiceImpl.update", param);
		}		
		return paramList;
	}
	
	/**
	 * 삭제
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "hbo")
	public List<Map> delete(List<Map> paramList,LoginVO loginVO) throws Exception {
		for(Map param :paramList )	{			
			param.put("S_COMP_CODE",loginVO.getCompCode());
			super.commonDao.update("s_hbo300ukr_jwServiceImpl.delete", param);
		}
		return paramList;		
	}
	
	/** 
	 * 기존 데이타가 있는지 Check
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hbo")
	public int checkData(Map param, LoginVO user) throws Exception {
		List<Map> checkDataCnt = (List<Map>) super.commonDao.queryForObject("s_hbo300ukr_jwServiceImpl.checkData", param);
		if (!ObjUtils.isEmpty(checkDataCnt)) {
			throw new  UniDirectValidateException(this.getMessage("54281", user));
		} else {
			return (int) super.commonDao.select("s_hbo300ukr_jwServiceImpl.checkData2", param);
		}
	}
	@ExtDirectMethod(group = "hbo", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		return super.commonDao.list("s_hbo300ukr_jwServiceImpl.selectExcelUploadSheet1", param);
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
		List<Map> getData = (List<Map>) super.commonDao.list("s_hbo300ukr_jwServiceImpl.getData", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  { 
                param.put("ROWNUM", data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE", data.get("COMP_CODE"));
			
			}
		}
	}


}
