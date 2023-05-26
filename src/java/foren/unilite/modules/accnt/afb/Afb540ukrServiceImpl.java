package foren.unilite.modules.accnt.afb;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("afb540ukrService")
public class Afb540ukrServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// BUDG_NAME컬럼수
	public List<Map<String, Object>>  selectBudgName(Map param) throws Exception {	
		return  super.commonDao.list("afb540ukrServiceImpl.selectBudgName", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 그리드1
	public List<Map<String, Object>>  selectList(Map param) throws Exception {	
		super.commonDao.list("afb540ukrServiceImpl.selectBudgName", param);
		return  super.commonDao.list("afb540ukrServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 그리드2
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {	
		if(param.get("BUDG_YYYYMM") != null ) param.put("BUDG_YYYYMM", ObjUtils.getSafeString( param.get("BUDG_YYYYMM")).replaceAll("\\.", "")); 
		if(param.get("DIVERT_YYYYMM") != null ) param.put("DIVERT_YYYYMM", ObjUtils.getSafeString( param.get("DIVERT_YYYYMM")).replaceAll("\\.", "")); 
		return  super.commonDao.list("afb540ukrServiceImpl.selectList2", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")		// 저장전 REF_CODE1 검사
	public List<Map<String, Object>>  selectDivertGroup(Map param) throws Exception {	
		return  super.commonDao.list("afb540ukrServiceImpl.selectDivertGroup", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	 public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 if(paramList != null)	{
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(updateList != null) this.updateDetail(updateList, user);				
		}
	 	paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList )	{	
			Map selectDivertGroup = (Map) super.commonDao.queryForObject("afb540ukrServiceImpl.selectDivertGroup", param);
			if(selectDivertGroup.isEmpty()) {
				param.put("sDivertGroup", param.get("DIVERT_DIVI"));
			} else {
				param.put("sDivertGroup", (String) selectDivertGroup.get("REF_CODE1"));
			}
			if(param.get("BUDG_YYYYMM") != null ) param.put("BUDG_YYYYMM", ObjUtils.getSafeString( param.get("BUDG_YYYYMM")).replaceAll("\\.", "")); 
			if(param.get("DIVERT_YYYYMM") != null ) param.put("DIVERT_YYYYMM", ObjUtils.getSafeString( param.get("DIVERT_YYYYMM")).replaceAll("\\.", "")); 
			super.commonDao.update("afb540ukrServiceImpl.saveApprove", param);
		}
		return 0;
	} 
}
