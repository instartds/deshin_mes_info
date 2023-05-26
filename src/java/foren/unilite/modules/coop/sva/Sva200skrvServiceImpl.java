package foren.unilite.modules.coop.sva;

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
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;



@Service("sva200skrvService")
public class Sva200skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	
	
	/**
	 * 자판기판매현황조회 왼쪽
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> gridUp(Map param) throws Exception {
		return super.commonDao.list("sva200skrvServiceImpl.gridUp", param);
	}
	
	/**
	 * 자판기판매현황조회 오른쪽
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> gridDown(Map param) throws Exception {
		return super.commonDao.list("sva200skrvServiceImpl.gridDown", param);
	}
	/**
	 * 
	 * 매출집계 체크 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "coop", value = ExtDirectMethodType.STORE_READ)
	public Object  billDateCheck(Map param) throws Exception {	
		
		return  super.commonDao.select("sva200skrvServiceImpl.billDateCheck", param);
	}
	/**
	 * 판매금액 확정
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Object  setConfirm(Map spParam, LoginVO user) throws Exception {

		super.commonDao.update("sva200skrvServiceImpl.setConfirm", spParam);
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
