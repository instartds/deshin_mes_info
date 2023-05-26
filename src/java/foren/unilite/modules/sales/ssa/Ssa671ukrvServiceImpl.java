package foren.unilite.modules.sales.ssa;

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

@Service("ssa671ukrvService")
public class Ssa671ukrvServiceImpl  extends TlabAbstractServiceImpl {
	
	/**
	 * 미수잔액이월 작업 Master 조회 및 set 
	 * 잔액이월Control에서 월마감(최종마감,기초잔액)년월 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaster1(Map param) throws Exception {
		return super.commonDao.select("ssa671ukrvServiceImpl.selectMaster1", param);
	}
	
	/**
	 * 미수잔액이월 작업 Master 조회 및 set 
	 * 채권누계테이블에서 해당 사업장의 최종마감월과 최초마감월 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaster2(Map param) throws Exception {
		return super.commonDao.select("ssa671ukrvServiceImpl.selectMaster2", param);
	}
	
	/**
	 * 사업자번호 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectOrgInfo(Map param) throws Exception {
		return super.commonDao.select("ssa671ukrvServiceImpl.selectOrgInfo", param);
	}
	
	
	/**
	 * 미수잔액이월작업 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Object  insertMaster(Map spParam, LoginVO user) throws Exception {

		super.commonDao.update("ssa671ukrvServiceImpl.spReceiving", spParam);
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
