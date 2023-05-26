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


@Service("gtt100skrvService")
public class Gtt100skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gtt100skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectListSummary(Map param) throws Exception {	
		return  super.commonDao.list("gtt100skrvServiceImpl.selectListSummary", param);
	}	
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  opDriver(Map param) throws Exception {	
		return  super.commonDao.list("gtt100skrvServiceImpl.opDriver", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  gcdDriver(Map param) throws Exception {	
		return  super.commonDao.list("gtt100skrvServiceImpl.gcdDriver", param);
	}
	
	@ExtDirectMethod(group = "main", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  summaryPortal(Map param) throws Exception {	
		return  super.commonDao.list("gtt100skrvServiceImpl.summary", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  groupSummary(Map param) throws Exception {	
		return  super.commonDao.list("gtt100skrvServiceImpl.groupSummary", param);
	}
	
	@ExtDirectMethod(group = "busoperate", value = ExtDirectMethodType.STORE_MODIFY)
	public Object  summary(Map param, LoginVO user) throws Exception {		
	
		String keyValue = getLogKey();	
		
		param.put("KEY_VALUE", keyValue);
		
		// 로그테이블 저장
		super.commonDao.update("gtt100skrvServiceImpl.saveSummary", param);	
		
		//배차프로시저실행
		super.commonDao.update("gtt100skrvServiceImpl.operationWorkingSummary", param);
		String errorDesc = ObjUtils.getSafeString(param.get("ErrorDesc"));
		if(ObjUtils.isNotEmpty(errorDesc)){				
			String messsage = errorDesc.replaceAll("\\;", "");
			throw new  UniDirectValidateException(this.getMessage(messsage, user));
		}
		return param;
	}

}
