package foren.unilite.modules.accnt.afb;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

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
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("afb300ukrService")
public class Afb300ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	
	
	/**
	 * 예산업무설정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectForm(Map param) throws Exception {	
		return super.commonDao.select("afb300ukrServiceImpl.selectForm", param);

	}
	/**
	 * AFB300T 데이터 체크
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectCheckDataCopy1(Map param) throws Exception {	
		return  super.commonDao.list("afb300ukrServiceImpl.selectCheckDataCopy1", param);
	}
	/**
	 * AFB400T 데이터 체크
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectCheckDataCopy2(Map param) throws Exception {	
		return  super.commonDao.list("afb300ukrServiceImpl.selectCheckDataCopy2", param);
	}
	
	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(Afb300ukrModel param, LoginVO user,  BindingResult result) throws Exception {

		param.setS_USER_ID(user.getUserID());
		param.setS_COMP_CODE(user.getCompCode());
		
		if(param.getSAVE_FLAG().equals("D")){
			super.commonDao.update("afb300ukrServiceImpl.deleteForm", param);
		}else{
			
			if(param.getOnDataCopy().equals("on")){
				super.commonDao.update("afb300ukrServiceImpl.deleteForm2", param);
				super.commonDao.update("afb300ukrServiceImpl.insertDataCopy", param);
			}else{
				super.commonDao.update("afb300ukrServiceImpl.deleteForm", param);
				super.commonDao.update("afb300ukrServiceImpl.insertForm", param);
			}
		}
		
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}
}
