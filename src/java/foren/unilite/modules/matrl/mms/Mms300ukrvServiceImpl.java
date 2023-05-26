package foren.unilite.modules.matrl.mms;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("mms300ukrvService")
public class Mms300ukrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 수주현황- 품목별 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		return  super.commonDao.list("mms300ukrvServiceImpl.selectList", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "mpo")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {		
		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(updateList != null) this.updateDetail(updateList, user);				
		}
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		paramList.add(0, paramMaster);
		return  paramList;
	}
	/*@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "coop")		// INSERT
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			
			List<Map> chkList = (List<Map>) super.commonDao.list("dhl200ukrvService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("dhl200ukrvService.insertDetail", param);
				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	*/
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "mpo")		// UPDATE
	public Integer updateDetail(List<Map> updateList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());		
		for(Map updateData : updateList) {
			super.commonDao.update("mms300ukrvServiceImpl.updateDetail", updateData);
		}
		return 0;
	} 
	
	/*@ExtDirectMethod(group = "coop", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("dhl200ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("dhl200ukrvService.deleteDetail", param);
			 }
		 }
		 return 0;
	}*/
	
	
	/**
	 * 
	 * userID에 따른 납품창고 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "mpo", value = ExtDirectMethodType.STORE_READ)
	public Object  userWhcode(Map param) throws Exception {	
		
		return  super.commonDao.select("mms300ukrvServiceImpl.userWhcode", param);
	}
	
	
	
	private int parseInt(String text) {
		// TODO Auto-generated method stub
		return 0;
	}
	

}
