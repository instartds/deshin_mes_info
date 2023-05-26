package foren.unilite.modules.busevaluation.grb;

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
import foren.unilite.modules.busevaluation.grb.Grb100ukrvModel;


@Service("grb100ukrvService")
public class Grb100ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busevalution", value = ExtDirectMethodType.FORM_LOAD)
	public Object  selectList(Map param) throws Exception {	
		return  super.commonDao.select("grb100ukrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "busevalution")
	public ExtDirectFormPostResult syncMaster(Grb100ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
		
		param.setS_USER_ID(user.getUserID());
		super.commonDao.update("grb100ukrvServiceImpl.deleteUpdate", param);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			
		return extResult;
	}
}
