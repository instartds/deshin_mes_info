package foren.unilite.modules.accnt.agd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("agd400ukrService")
public class Agd400ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		return  super.commonDao.list("agd400ukrServiceImpl.selectList", param);
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
        String keyValue	= getLogKey();
        
        //SP에서 작성한 변수에 맞추기
        //SP 호출시 넘길 MAP 정의
		Map<String, Object> spParam = new HashMap<String, Object>();
        //작업 구분 (N:자동기표, D:기표취소)
        String oprFlag	= (String) dataMaster.get("OPR_FLAG");
        //실행일
        String procDate	= (String) dataMaster.get("PROC_DATE");
        //language type
        String langType	= (String) dataMaster.get("LANG_TYPE");
        //에러메세지 처리
        String errorDesc = "";
        
        
        //2.로그테이블에 KEY_VALUE 업데이트
        for(Map param: paramList)      {
        	if(!oprFlag.equals("D")) {
	        	//AGD390T에 먼저 INSERT
	        	super.commonDao.insert("agd400ukrServiceImpl.insertAgd390", param);

        	}
        	//로그테이블에 키값 추가하여 INSERT
        	param.put("KEY_VALUE", keyValue);
        	param.put("PROC_DATE", procDate);
        	super.commonDao.insert("agd400ukrServiceImpl.insertLogTable", param);
        }  
        //OPR_FLAG 값에 따라 다른 SP 호출로직 구현
    	//기표취소이면..
    	if(oprFlag.equals("D")) {
            spParam.put("COMP_CODE"		, user.getCompCode());
    		spParam.put("KEY_VALUE"		, keyValue);
    		spParam.put("PROC_DATE"		, procDate);
    		spParam.put("LANG_TYPE"		, langType);
    		spParam.put("INPUT_USER_ID"	, user.getUserID());
    		spParam.put("ERROR_DESC"	, "");
    		super.commonDao.queryForObject("agd400ukrServiceImpl.cancelSlip", spParam);
    		
    		
    	} else {
            spParam.put("COMP_CODE"		, user.getCompCode());
    		spParam.put("KEY_VALUE"		, keyValue);
    		spParam.put("PROC_DATE"		, procDate);
    		spParam.put("LANG_TYPE"		, langType);
    		spParam.put("INPUT_USER_ID"	, user.getUserID());
    		spParam.put("ERROR_DESC"	, "");
    		super.commonDao.queryForObject("agd400ukrServiceImpl.runAutoSlip", spParam);
    	}
    	errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		if(!ObjUtils.isEmpty(errorDesc)){
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));

		} 

		return paramList;
    }

}
