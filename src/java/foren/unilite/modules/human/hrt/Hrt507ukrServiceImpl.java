package foren.unilite.modules.human.hrt;

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
import foren.unilite.utils.AES256DecryptoUtils;
import foren.unilite.utils.AES256EncryptoUtils;
import foren.framework.sec.cipher.ase.AES256Cipher;



@Service("hrt507ukrService")
public class Hrt507ukrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	private AES256EncryptoUtils encrypto = new AES256EncryptoUtils();
	private AES256DecryptoUtils	decrypto = new AES256DecryptoUtils();
	
	

	
	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "human")			// 조회
	public Object selectMaster(Map param) throws Exception {
		Map dataMap = (Map)super.commonDao.select("hrt507ukrServiceImpl.selectMaster", param);
        if (ObjUtils.isNotEmpty(dataMap)) {
        	dataMap.put("REPRE_NUM", decrypto.getDecryptWithType(dataMap.get("REPRE_NUM"),param.get("S_COMP_CODE") , "hrt507ukr", "A"));
    		dataMap.put("BANK_ACCOUNT", decrypto.getDecryptWithType(dataMap.get("BANK_ACCOUNT"),param.get("S_COMP_CODE") , "hrt507ukr", "B"));   	
        }
        return dataMap;
	}	
	/**
	 * 퇴직금영수증 저장
	 * @param param
	 * @param user
	 * @param result
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "human")
	public ExtDirectFormPostResult syncMaster(Hrt507ukrModel param, LoginVO user,  BindingResult result) throws Exception {
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
		param.setM_COMPANY_NUM(param.getM_COMPANY_NUM().replace("-", ""));
		super.commonDao.update("hrt507ukrServiceImpl.insert", param);
		
		if("DB".equals(param.getRETR_PENSION_KIND()))	{
			super.commonDao.update("hrt507ukrServiceImpl.insertRetrPension", param);
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		return extResult;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public Map  retireProcStChangedSuppTotal(Map param, LoginVO user) throws Exception {
		logger.info("param :: {}", param);
        Map rtn = (Map)super.commonDao.queryForObject("hrt506ukrServiceImpl.retireProcStChangedSuppTotal", param);
        if(rtn != null && ObjUtils.isNotEmpty(rtn.get("errorDesc")))	{
        	throw new  UniDirectValidateException(this.getMessage(ObjUtils.getSafeString(rtn.get("errorDesc")), user));
        }
        return rtn;
	}
	
}
