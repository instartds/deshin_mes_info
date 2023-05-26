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



@Service("agc190skrService")
public class Agc190skrServiceImpl extends TlabAbstractServiceImpl {
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
		return super.commonDao.list("agc190skrService.fnCheckExistABA131", param);
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param , LoginVO user) throws Exception {			// 
		
		String divCode = (String) param.get("DIV_CODE").toString().replace("[", "");
		String finaldivCode = divCode.replace("]", "");
		
		param.put("DIV_CODE", finaldivCode);
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc190skrService.fnCheckExistABA131", param);
		if(fnCheckExistABA131.isEmpty()){
			throw new  UniDirectValidateException(this.getMessage("55321", user));
		}else{
			super.commonDao.list("agc190skrService.selectList1", param);
			
			String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
			
			if(!ObjUtils.isEmpty(errorDesc)){
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			}else{
				return super.commonDao.list("agc190skrService.selectList1", param);
			}
		}
	}
	
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param , LoginVO user) throws Exception {			// 
		
		String divCode = (String) param.get("DIV_CODE").toString().replace("[", "");
		String finaldivCode = divCode.replace("]", "");
		
		param.put("DIV_CODE", finaldivCode);
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc190skrService.fnCheckExistABA131", param);
		if(fnCheckExistABA131.isEmpty()){
			throw new  UniDirectValidateException(this.getMessage("55321", user));
		}else{
			super.commonDao.list("agc190skrService.selectList2", param);
			
			String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
			
			if(!ObjUtils.isEmpty(errorDesc)){
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			}else{
				return super.commonDao.list("agc190skrService.selectList2", param);
			}
		}
	}
	
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList3(Map param , LoginVO user) throws Exception {			// 
		
		String divCode = (String) param.get("DIV_CODE").toString().replace("[", "");
		String finaldivCode = divCode.replace("]", "");
		
		param.put("DIV_CODE", finaldivCode);
		List<Map> fnCheckExistABA131 = (List<Map>) super.commonDao.list("agc190skrService.fnCheckExistABA131", param);
		if(fnCheckExistABA131.isEmpty()){
			throw new  UniDirectValidateException(this.getMessage("55321", user));
		}else{
			super.commonDao.list("agc190skrService.selectList3", param);
			
			String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
			
			if(!ObjUtils.isEmpty(errorDesc)){
				String[] messsage = errorDesc.split(";");
			    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			}else{
				return super.commonDao.list("agc190skrService.selectList3", param);
			}
		}
	}
}
