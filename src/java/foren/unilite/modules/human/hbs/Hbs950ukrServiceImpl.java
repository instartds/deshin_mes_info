package foren.unilite.modules.human.hbs;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("hbs950ukrService")
public class Hbs950ukrServiceImpl  extends TlabAbstractServiceImpl {
	
	public String selectCloseyyyy(String comp_code) throws Exception {
		return super.commonDao.queryForObject("hbs950ukrServiceImpl.selectCloseyyyy" ,comp_code).toString();
	}
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "hum", value = ExtDirectMethodType.STORE_MODIFY)
	public int doBatch(Map param) throws Exception {
		return (int)super.commonDao.update("hbs950ukrServiceImpl.doBatch", param);		
	}
}
