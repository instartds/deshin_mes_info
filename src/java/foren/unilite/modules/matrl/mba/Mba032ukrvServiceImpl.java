package foren.unilite.modules.matrl.mba;

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


@Service("mba032ukrvService")
public class Mba032ukrvServiceImpl  extends TlabAbstractServiceImpl {
	
	/**
	 * 미수잔액이월 작업 Master 조회 및 set 
	 * 잔액이월Control에서 월마감(최종마감,기초잔액)년월 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaster1(Map param) throws Exception {
		return super.commonDao.select("mba032ukrvServiceImpl.selectMaster1", param);
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
		return super.commonDao.select("mba032ukrvServiceImpl.selectMaster2", param);
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
		return super.commonDao.select("mba032ukrvServiceImpl.selectOrgInfo", param);
	}
	
	
	/**
	 * 미수잔액이월작업 저장
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public void  insertMaster(Map spParam) throws Exception {

		super.commonDao.update("mba032ukrvServiceImpl.spBalanceClosing", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
				
		if(errorDesc != null){
			throw new Exception(errorDesc);			
		}
	}
}
