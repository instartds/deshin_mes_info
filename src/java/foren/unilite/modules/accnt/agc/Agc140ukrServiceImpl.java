package foren.unilite.modules.accnt.agc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;


@SuppressWarnings("unused")
@Service("agc140ukrService")
public class Agc140ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/** 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param, LoginVO user) throws Exception {
		//Key 생성      
        String keyValue	= getLogKey();
        
    	param.put("KEY_VALUE", keyValue);
    	param.put("LANG_TYPE", user.getLanguage());
    	
    	
    	//변수 선언 
    	//SP실행 후, list 받을 변수
    	List<Map<String, Object>> errorCheck = new ArrayList<Map<String, Object>>();
    	//error 메세지 담을 변수
        String errorDesc ="";
    	
    	
    	//SP 실행 - 재참조일 경우
		if (!ObjUtils.isEmpty(param.get("QUERY_FLAG"))) {
			errorCheck = (List<Map<String, Object>>) super.commonDao.list("agc140ukrServiceImpl.reReference", param);
			
    	//SP 실행 - 일반적인 조회일 경우
		} else {
			errorCheck = (List<Map<String, Object>>) super.commonDao.list("agc140ukrServiceImpl.selectList", param);
		}
		
        if(!errorCheck.isEmpty()){
            errorDesc = ObjUtils.getSafeString(errorCheck.get(0).get("ErrorDesc"));
        }
		
		if(!ObjUtils.isEmpty(errorDesc)){
		    throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		    
		} else {
			return errorCheck;
		}
	}	
	
	
	
	/** 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null)	{
			List<Map> dataList = new ArrayList<Map>();
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				dataList = (List<Map>) dataListMap.get("data");

				for(Map param:  dataList) {
					//필요한 데이터를 가공해서 넘김
					param.put("FR_AC_DATE"	, dataMaster.get("FR_AC_DATE"));
					param.put("TO_AC_DATE"	, dataMaster.get("TO_AC_DATE"));
					param.put("FR_DATE"		, dataMaster.get("FR_DATE"));
					param.put("TO_DATE"		, dataMaster.get("TO_DATE"));
					param.put("CASH_DIVI"	, dataMaster.get("CASH_DIVI"));
					param.put("DIV_CODE"	, dataMaster.get("DIV_CODE"));
					
					//AMT_I 값 입력
					if(ObjUtils.isEmpty(param.get("AMT_I1")) || param.get("AMT_I1").equals(0)) {
						param.put("AMT_I", param.get("AMT_I2"));
						
					} else {
						param.put("AMT_I", param.get("AMT_I1"));
					}
				}

				if(dataListMap.get("method").equals("insertList")) {		
					insertList = (List<Map>)dataListMap.get("data");
					
				} else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");
					
				} else if(dataListMap.get("method").equals("deleteList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(insertList != null) this.insertList(insertList, user, paramMaster);
			if(updateList != null) this.insertList(updateList, user, paramMaster);	
			if(deleteList != null) this.deleteList(deleteList, user, paramMaster);			
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	/** 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes" })
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer insertList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		try {
			//INSERT 전, 이전 데이터 삭제
			this.deleteList(paramList, user, paramMaster);

			for(Map param : paramList )	{
				//AMT_I가 있을 때, INSERT
				if(!ObjUtils.isEmpty(param.get("AMT_I")) && ObjUtils.parseInt(param.get("AMT_I")) != 0){
					super.commonDao.update("agc140ukrServiceImpl.insertList", param);
				}
			}
			
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}		
		
		
		return 0;
	}	
	
	
	/** 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {		
		 return 0;
	} 
	
	
	/** 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteList(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList )	{
			try {
				 super.commonDao.delete("agc140ukrServiceImpl.deleteList", param);

			}catch(Exception e)	{
	    			throw new  UniDirectValidateException(this.getMessage("547",user));
			 }
		 }
		 return 0;
	}
}
