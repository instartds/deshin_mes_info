package foren.unilite.modules.accnt.agd;

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



@Service("agd370ukrService")
public class Agd370ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList (Map param) throws Exception {
		return super.commonDao.list("agd370ukrServiceImpl.selectList", param);
	}

	
	/**
	 * SP호출을 위한 로그테이블 생성 / SP 호출 로직
	 * @param paramList
	 * @param paramMaster
	 */
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
    public List<Map> callProcedure(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
        Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
        if(paramList != null)   {
            List<Map> insertList = null;

            for(Map dataListMap: paramList) {
            	if(dataListMap.get("method").equals("runProcedure")) {
            		insertList = (List<Map>)dataListMap.get("data");
                }
            }           
            if(insertList != null) this.runProcedure(insertList, user);
            

        }
        paramList.add(0, paramMaster);
        return  paramList;
    }
    
    @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
    private void runProcedure(List<Map> paramList, LoginVO user) throws Exception {
        
    	try {
            Map<String, Object> spParam = new HashMap<String, Object>();
            
            String ProcType = "1"; 
            String ProcDate = "";

            //1.로그테이블에서 사용할 Key 생성      
	        String keyValue = getLogKey(); 
	        
	        //2.로그테이블에 KEY_VALUE 업데이트
	        for(Map param: paramList)      {
	            
	            if(param.get("OPR_FLAG").equals("IS")){    //개별 자동기표 base_date로 전표생성함.
	                
                    param.put("OPR_FLAG", 'N');          
                    ProcType = "1";
                
                }else if(param.get("OPR_FLAG").equals("AS")){ //일괄 자동기표 proc_date로 전표생성함.
	                
                    param.put("OPR_FLAG", 'N');          
                    ProcType = "2";
                    ProcDate = param.get("PROC_DATE").toString();
	            
	            }else{
                
	                param.put("OPR_FLAG", 'D');  // 전표취소
                    ProcType = "3";
	                
	            }
	            
                param.put("KEY_VALUE", keyValue);
                
	        	super.commonDao.insert("agd370ukrServiceImpl.insertLogTable", param);
      	        	
	        }   

            //3.차입금자동기표 Stored Procedure 실행
            if (ProcType.equals("1")) {//개별 자동기표    
                
                spParam.put("CompCode", user.getCompCode());
                spParam.put("KeyValue", keyValue);
                spParam.put("WorkDate",ProcDate); 
                spParam.put("ProcType",ProcType); 
                spParam.put("LangCode", user.getLanguage());
                spParam.put("UserId", user.getUserID());
                
               
                super.commonDao.queryForObject("spUspAccntAutoSlip84", spParam);
                
                String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
                
                if (!ObjUtils.isEmpty(errorDesc)) {
                    throw new Exception(errorDesc);
                }
            }else if (ProcType.equals("2")) {//일괄자동기표
                
                spParam.put("CompCode", user.getCompCode());
                spParam.put("KeyValue", keyValue);
                spParam.put("WorkDate",ProcDate); 
                spParam.put("ProcType",ProcType); 
                spParam.put("LangCode", user.getLanguage());
                spParam.put("UserId", user.getUserID());
                
               
                super.commonDao.queryForObject("spUspAccntAutoSlip84", spParam);
                
                String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
                
                if (!ObjUtils.isEmpty(errorDesc)) {
                    throw new Exception(errorDesc);
                }
            } else if (ProcType.equals("3")) {
                //3.차입금자동기표취소 Stored Procedure 실행
                
                spParam.put("CompCode", user.getCompCode());
                spParam.put("UserId", user.getUserID());
                spParam.put("KeyValue", keyValue);
                spParam.put("LangCode", user.getLanguage());
                
                super.commonDao.queryForObject("spUspAccntAutoSlip84Cancel", spParam);
                
                String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
                
                if (!ObjUtils.isEmpty(errorDesc)) {
                    throw new Exception(errorDesc);
                }
                
            }       
	        
    	} catch(Exception e) {
            throw new  UniDirectValidateException(this.getMessage("2627", user));
        }
    	
        //OPR_FLAG 값에 따라 다른 SP 호출로직 구현
        //super.commonDao.insert("agd370ukrServiceImpl.runProcedure", paramList);


       	return;
    }

}
