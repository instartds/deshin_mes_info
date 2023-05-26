package foren.unilite.modules.stock.biv;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.utils.UniliteUtil;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("biv470skrvService")
public class Biv470skrvServiceImpl  extends TlabAbstractServiceImpl {


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "stock")
	public List<Map<String, Object>>  selectList(Map param,LoginVO user) throws Exception {
		param.put("COMP_CODE", user.getCompCode());
		param.put("SUBCON_YN", param.get("SUBCON_YN")==null?"":param.get("SUBCON_YN"));
		param.put("QRY_TYPE", param.get("QRY_TYPE")==null?"":param.get("QRY_TYPE"));
		return  super.commonDao.list("biv470skrvServiceImpl.selectList", param);
	}
	
}
