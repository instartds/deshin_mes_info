package foren.unilite.modules.prodt.pbs;

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
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.prodt.pbs.Pbs060ukrvModel;


@Service("pbs060ukrvService")
public class Pbs060ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	@Resource(name = "tlabMenuService")
	 TlabMenuService tlabMenuService;
	
	/**
	 * 생산업무설정
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectForm(Map param) throws Exception {
		return super.commonDao.select("pbs060ukrvServiceImpl.selectForm", param);
	}

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectForm2(Map param) throws Exception {
		return super.commonDao.select("pbs060ukrvServiceImpl.selectForm2", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "prodt")
	public ExtDirectFormPostResult syncForm(Pbs060ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
	
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		super.commonDao.update("pbs060ukrvServiceImpl.updateForm", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
		return extResult;
		
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "prodt")
	public ExtDirectFormPostResult syncForm2(Pbs060ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
	
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		super.commonDao.update("pbs060ukrvServiceImpl.updateForm2", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		tlabMenuService.reload(true);	
		return extResult;
		
	}
}

