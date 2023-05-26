package foren.unilite.modules.coop.cpa;

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



@Service("cpa300ukrvService")
public class Cpa300ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	

	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "coop")
	public Object selectMaster(Map param) throws Exception {	
		
		
		return super.commonDao.select("cpa300ukrvServiceImpl.selectMaster", param);
	}
	
	/**
	 * 조합원배당금작업
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Object insertMaster(Map spParam, LoginVO user) throws Exception {
		logger.debug("parameter:" + spParam);
		super.commonDao.update("cpa300ukrvServiceImpl.spCooptorDivd", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");			
			if(messsage[0].equals("50000")){
				throw new  UniDirectValidateException(messsage[1]);
			}else{
				throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
			}		    
		}else{
			return true;
		}		
	}
}
