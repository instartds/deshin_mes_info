package foren.unilite.modules.sales.ssa;

import java.util.Map;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("ssa670ukrvService")
@SuppressWarnings("rawtypes")
public class Ssa670ukrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 미수잔액이월 작업 Master 조회 및 set 
	 * 잔액이월Control에서 월마감(최종마감,기초잔액)년월 조회
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaster1(Map param) throws Exception {
		return super.commonDao.select("ssa670ukrvServiceImpl.selectMaster1", param);
	}

	/**
	 * 미수잔액이월 작업 Master 조회 및 set 
	 * 채권누계테이블에서 해당 사업장의 최종마감월과 최초마감월 조회
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaster2(Map param) throws Exception {
		return super.commonDao.select("ssa670ukrvServiceImpl.selectMaster2", param);
	}

	/**
	 * 사업자번호 조회
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectOrgInfo(Map param) throws Exception {
		return super.commonDao.select("ssa670ukrvServiceImpl.selectOrgInfo", param);
	}

	/**
	 * 미수잔액이월작업 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Object  insertMaster(Map spParam, LoginVO user) throws Exception {
		super.commonDao.queryForObject("ssa670ukrvServiceImpl.spReceiving", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
		if(!ObjUtils.isEmpty(errorDesc)){
			String[] messsage = errorDesc.split(";");
			throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		}else{
			return true;
		}
	}
}