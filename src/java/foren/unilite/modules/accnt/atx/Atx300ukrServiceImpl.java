package foren.unilite.modules.accnt.atx;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.derby.tools.sysinfo;
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



@Service("atx300ukrService")
public class Atx300ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 *  부가세신고서
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "accnt")
	public Object selectForm(Map param) throws Exception {	
		if(param.get("RE_REFERENCE").equals("Y")){
			return super.commonDao.select("atx300ukrServiceImpl.selectListSecond", param);
		}else{
			if( super.commonDao.select("atx300ukrServiceImpl.selectListFirst", param) == null){
				return super.commonDao.select("atx300ukrServiceImpl.selectListSecond", param);
			}else{
				return super.commonDao.select("atx300ukrServiceImpl.selectListFirst", param);
			}
		}
	}
	/**
	 * 재참조버튼 관련 체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	 
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> dataCheck(Map param) throws Exception {	
		return  super.commonDao.list("atx300ukrServiceImpl.selectListFirst", param);
	}
	
	/**
	 * 재참조버튼 관련 체크
	 * @param param
	 * @return
	 * @throws Exception
	 */
	 
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> mainCheck(Map param) throws Exception {	
		return  super.commonDao.list("atx300ukrServiceImpl.selectTermCode", param);
	}
	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncMaster(Atx300ukrModel param, LoginVO user,  BindingResult result) throws Exception {

		param.setS_USER_ID(user.getUserID());
		param.setS_COMP_CODE(user.getCompCode());
		
		if(param.getSAVE_FLAG().equals("") || param.getSAVE_FLAG().equals("N")){
			super.commonDao.update("atx300ukrServiceImpl.deleteForm", param);
			super.commonDao.update("atx300ukrServiceImpl.insertForm", param);
		}else if(param.getSAVE_FLAG().equals("U")){
			super.commonDao.update("atx300ukrServiceImpl.updateForm", param);
		}else if(param.getSAVE_FLAG().equals("D")){
			super.commonDao.update("atx300ukrServiceImpl.deleteForm", param);
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);

		return extResult;
	}
	
	
	
}
