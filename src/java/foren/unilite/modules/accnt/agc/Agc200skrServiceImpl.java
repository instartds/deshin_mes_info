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



@Service("agc200skrService")
public class Agc200skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	/**
	 * 
	 * 집계항목이 적용된 데이터가 있는지 검사
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> fnCheckExistABA131(Map param) throws Exception {
		return super.commonDao.list("agc200skrService.fnCheckExistABA131", param);
	}	
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param , LoginVO user) throws Exception {			// 재무상태표
	    String finaldeptCode1 = "";
	    String finaldeptCode2 = "";
        String finaldeptCode3 = "";
        String finaldeptCode4 = "";
        String finaldeptCode5 = "";
        String finaldeptCode6 = "";
        
        if(param.get("DEPTS1") != null){
            String deptCode1 = (String) param.get("DEPTS1").toString().replace("[", "");
            finaldeptCode1 = deptCode1.replace("]", "");
        }
        if(param.get("DEPTS2") != null){
            String deptCode2 = (String) param.get("DEPTS2").toString().replace("[", "");
            finaldeptCode2 = deptCode2.replace("]", "");
        }
        if(param.get("DEPTS3") != null){
            String deptCode3 = (String) param.get("DEPTS3").toString().replace("[", "");
            finaldeptCode3 = deptCode3.replace("]", "");
        }
        if(param.get("DEPTS4") != null){
            String deptCode4 = (String) param.get("DEPTS4").toString().replace("[", "");
            finaldeptCode4 = deptCode4.replace("]", "");
        }
        if(param.get("DEPTS5") != null){ 
            String deptCode5 = (String) param.get("DEPTS5").toString().replace("[", "");
            finaldeptCode5 = deptCode5.replace("]", "");
        }
        if(param.get("DEPTS6") != null){
            String deptCode6 = (String) param.get("DEPTS6").toString().replace("[", "");
            finaldeptCode6 = deptCode6.replace("]", "");
        }
	    
	    param.put("DIVI", "20");
	    
        param.put("DEPT_CODE1", finaldeptCode1);
        param.put("DEPT_CODE2", finaldeptCode2);
        param.put("DEPT_CODE3", finaldeptCode3);
        param.put("DEPT_CODE4", finaldeptCode4);
        param.put("DEPT_CODE5", finaldeptCode5);
        param.put("DEPT_CODE6", finaldeptCode6);
		
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc200skrService.fnCheckExistABA131", param);
		if(ObjUtils.isEmpty(fnCheckExistABA131)){
			throw new  UniDirectValidateException(this.getMessage("55321", user));
		} else {
			List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc200skrService.selectList1", param);
            String errorDesc ="";
            if(ObjUtils.isNotEmpty(returnData)){
                errorDesc = ObjUtils.getSafeString(returnData.get(0).get("ERROR_DESC"));
            }
            if(ObjUtils.isNotEmpty(errorDesc)){
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
            } else {
                return returnData;
            }
        }
	}	
	
}
