package foren.unilite.modules.base.bsa;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("bsa800ukrvService")
public class Bsa800ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	/**
	 *  프로그램 설정 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "base")
	public Object select(Map param) throws Exception {		
		
		return super.commonDao.select("bsa800ukrvServiceImpl.select", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_LOAD, group = "base")
	public Object receiptSelect(Map param) throws Exception {	
		return super.commonDao.select("bsa800ukrvServiceImpl.receiptSelect", param);
	}
	
	
	/**
	 *  프로그램 설정 입력/수정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "base")
	public ExtDirectFormPostResult save(Bsa800ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
		param.setPGM_ID("$");
		super.commonDao.update("bsa800ukrvServiceImpl.save", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			
		return extResult;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "base")
	public ExtDirectFormPostResult receiptSave(Bsa800ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
        param.setPGM_ID("$");
		super.commonDao.update("bsa800ukrvServiceImpl.receiptSave", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			
		return extResult;
	}
	

}
