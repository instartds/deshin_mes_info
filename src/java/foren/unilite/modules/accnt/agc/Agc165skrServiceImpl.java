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



@Service("agc165skrService")
public class Agc165skrServiceImpl extends TlabAbstractServiceImpl {
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
		return super.commonDao.list("agc165skrService.fnCheckExistABA131", param);
	}	
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param , LoginVO user) throws Exception {			// 재무상태표
		if (param.get("UNIT").equals("2")){
			param.put("DEPTS1", param.get("CUST_ITEM_CODE1"));
			param.put("DEPTS2", param.get("CUST_ITEM_CODE2"));
			param.put("DEPTS3", param.get("CUST_ITEM_CODE3"));
			param.put("DEPTS4", param.get("CUST_ITEM_CODE4"));
			param.put("DEPTS5", param.get("CUST_ITEM_CODE5"));
			param.put("DEPTS6", param.get("CUST_ITEM_CODE6"));
		}
		param.put("DIVI", "20");
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc165skrService.fnCheckExistABA131", param);
		if(fnCheckExistABA131.isEmpty()){
			throw new  UniDirectValidateException(this.getMessage("55321", user));
			
		} else {
			List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc165skrService.selectList1", param);
            String errorDesc ="";
            if(!returnData.isEmpty()){
                errorDesc = ObjUtils.getSafeString(returnData.get(0).get("ERROR_DESC"));
            }
            if(!ObjUtils.isEmpty(errorDesc)){
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
                
            } else {
                return returnData;
            }
        }
	}	
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param , LoginVO user) throws Exception {			// 재무상태표

		param.put("DIVI", "30");
		
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc165skrService.fnCheckExistABA131", param);
		if(fnCheckExistABA131.isEmpty()){
			throw new  UniDirectValidateException(this.getMessage("55321", user));
			
		} else {
			List<Map<String, Object>> returnData = (List<Map<String, Object>>) super.commonDao.list("agc165skrService.selectList2", param);
            String errorDesc ="";
            if(!returnData.isEmpty()){
                errorDesc = ObjUtils.getSafeString(returnData.get(0).get("ERROR_DESC"));
            }
            
            if(!ObjUtils.isEmpty(errorDesc)){
                throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
                
            } else {
                return returnData;
            }
        }
	}
	
}
