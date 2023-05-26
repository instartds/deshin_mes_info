package foren.unilite.modules.pos.pos;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("pos200skrvService")
public class Pos200skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "pos")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
	
		return  super.commonDao.list("pos200skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "pos")
	public Object  insertMaster(Map spParam, LoginVO user) throws Exception {

		super.commonDao.update("pos200skrvServiceImpl.CardImportStart", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		}else{
			return true;
		}		
//		if(errorDesc != null){
//			throw new Exception(errorDesc);			
//		}
	}
}
