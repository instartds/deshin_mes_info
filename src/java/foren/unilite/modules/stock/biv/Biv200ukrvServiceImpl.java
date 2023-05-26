package foren.unilite.modules.stock.biv;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("biv200ukrvService")
public class Biv200ukrvServiceImpl  extends TlabAbstractServiceImpl {
	
	@ExtDirectMethod(group = "stock", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		return  super.commonDao.select("biv200ukrvServiceImpl.userWhcode", param);
	}
	/**
	 * 제조품실적처리 SP호출
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Object  insertMaster(Map spParam, LoginVO user) throws Exception {
		spParam.put("LangCode", user.getLanguage());
		super.commonDao.update("biv200ukrvServiceImpl.callRawItemReducing", spParam);		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));				
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		}else{
			return true;
		}
	}
}
