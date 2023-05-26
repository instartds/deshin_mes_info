package foren.unilite.modules.busoperate.gtt;

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
import foren.unilite.com.validator.UniDirectValidateException;


@Service("gtt200skrvService")
public class Gtt200skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busmaintain", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gtt200skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectListSummary(Map param) throws Exception {	
		return  super.commonDao.list("gtt200skrvServiceImpl.selectListSummary", param);
	}	
	
	@ExtDirectMethod(group = "busmaintain", value = ExtDirectMethodType.STORE_MODIFY)
	public Object  summary(Map param, LoginVO user) throws Exception {		
	
		String keyValue = getLogKey();	
		
		param.put("KEY_VALUE", keyValue);
		
		// 로그테이블 저장
		super.commonDao.update("gtt200skrvServiceImpl.saveSummary", param);	
		
		//배차프로시저실행
		super.commonDao.update("gtt200skrvServiceImpl.operationWorkingSummaryForMechanic", param);
		String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
		if(ObjUtils.isNotEmpty(errorDesc)){				
			String messsage = errorDesc.replaceAll("\\;", "");
			throw new  UniDirectValidateException(this.getMessage(messsage, user));
		}
		return param;
	}

}
