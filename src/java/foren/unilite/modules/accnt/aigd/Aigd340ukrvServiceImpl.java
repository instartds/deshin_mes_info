package foren.unilite.modules.accnt.aigd;

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



@Service("aigd340ukrvService")
public class Aigd340ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 
	 * Detail 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("aigd340ukrvServiceImpl.selectList", param);
	}	
	


	
	
	/**
	 * SP호출을 위한 로그테이블 생성 / SP 호출 로직
	 * @param paramList
	 * @param paramMaster
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> callProcedure(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        if(paramList != null)   {
            List<Map> insertList = null;

            for(Map dataListMap: paramList) {
            	if(dataListMap.get("method").equals("runProcedure")) {
            		insertList = (List<Map>)dataListMap.get("data");
                }
            }           
            if(insertList != null) this.runProcedure(insertList, paramMaster, user);
        }
        paramList.add(0, paramMaster);
        return  paramList;
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    private List<Map> runProcedure(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		//1.로그테이블에서 사용할 Key 생성      
        String keyValue = getLogKey(); 
        
        //SP 호출시 넘길 MAP 정의
		Map<String, Object> spParam = new HashMap<String, Object>();
        //작업 구분 (A:자동기표, C:기표취소)
        String oprFlag	= (String) dataMaster.get("OPR_FLAG");
        //에러메세지 처리
        String errorDesc = "";
        
        Map<String, Object> sysDateMap =(Map<String, Object>) super.commonDao.select("aigd340ukrvServiceImpl.selectSysdate", paramMaster);
        
        //2.로그테이블에 KEY_VALUE 업데이트
        for(Map param: paramList)      {
        	param.put("KEY_VALUE"	, keyValue);
        	param.put("OPR_FLAG"	, oprFlag);
        	super.commonDao.insert("aigd340ukrvServiceImpl.insertLogTable", param);
        }       
	        
       	//OPR_FLAG 값에 따라 다른 SP 호출로직 구현
    	if(oprFlag.equals("D")) {
    		spParam.put("COMP_CODE"     , user.getCompCode());
            spParam.put("INPUT_USER_ID" , user.getUserID());
            spParam.put("INPUT_DATE"    , sysDateMap.get("SYS_DATE"));
            spParam.put("KEY_VALUE"     , keyValue);
            spParam.put("LANG_TYPE"     , user.getLanguage());
            spParam.put("CALL_PATH"     , dataMaster.get("CALL_PATH"));
    		super.commonDao.queryForObject("aigd340ukrvServiceImpl.cancelSlip", spParam);
    		
    	} else {
    		spParam.put("COMP_CODE"     , user.getCompCode());
            spParam.put("DATE_OPTION"   , dataMaster.get("DATE_OPTION"));
            spParam.put("WORK_DATE"     , dataMaster.get("WORK_DATE"));
            spParam.put("INPUT_USER_ID" , user.getUserID());
            spParam.put("INPUT_DATE"    , sysDateMap.get("SYS_DATE"));
            spParam.put("KEY_VALUE"     , keyValue);
            spParam.put("LANG_TYPE"     , user.getLanguage());
            spParam.put("CALL_PATH"     , dataMaster.get("CALL_PATH"));
            spParam.put("EBYN_MESSAGE"  , "");
            spParam.put("ERROR_DESC"    , "");
            spParam.put("SLIP_KEY_VALUE", "");
    		super.commonDao.queryForObject("aigd340ukrvServiceImpl.runAutoSlip", spParam);
    	}

    	errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		if(!ObjUtils.isEmpty(errorDesc)){
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		} 

       	return paramList;
    }
}
