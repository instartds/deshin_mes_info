package foren.unilite.modules.trade.tbs;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.modules.trade.tbs.Tbs020ukrvModel;


@Service("tbs020ukrvService")
public class Tbs020ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	
	@Resource(name = "tlabMenuService")
	 TlabMenuService tlabMenuService;
	/**
	 * 구매자재업무설정 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	
	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectForm(Map param) throws Exception {
		return super.commonDao.select("tbs020ukrvServiceImpl.selectForm", param);
	}
	@ExtDirectMethod(group = "trade", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectForm2(Map param) throws Exception {
		return super.commonDao.select("tbs020ukrvServiceImpl.selectForm2", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "trade")
	public ExtDirectFormPostResult syncForm(Tbs020ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
	
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		super.commonDao.update("tbs020ukrvServiceImpl.updateForm", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		tlabMenuService.reload(true);
		
		return extResult;
		
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "trade")
	public ExtDirectFormPostResult syncForm2(Tbs020ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
	
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		super.commonDao.update("tbs020ukrvServiceImpl.updateForm2", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		
		return extResult;
		
	}
	
}
