package foren.unilite.modules.busevaluation.gri;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("gri300ukrvService")
public class Gri300ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busevalution", value = ExtDirectMethodType.FORM_LOAD)
	public Object  selectList(Map param) throws Exception {	
		return  super.commonDao.select("gri300ukrvService.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "busevalution")
	public ExtDirectFormPostResult syncMaster(Gri300ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
		
		param.setS_USER_ID(user.getUserID());
		super.commonDao.update("gri300ukrvService.deleteUpdate", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			
		return extResult;
	}
}
