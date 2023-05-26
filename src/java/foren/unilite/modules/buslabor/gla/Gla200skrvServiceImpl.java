package foren.unilite.modules.buslabor.gla;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;


@Service("gla200skrvService")
public class Gla200skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "buslabor", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList(Map param) throws Exception {	
		return  super.commonDao.list("gla200skrvServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "buslabor", value = ExtDirectMethodType.STORE_READ)
	public List<Map<Object, String>>  selectList2(Map param) throws Exception {	
		return  super.commonDao.list("gla200skrvServiceImpl.selectList2", param);
	}
	
/*	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busevalution")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
				
//		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
//		Map<String, Object> rMap;
//		
//		if(ObjUtils.isEmpty(dataMaster.get("REQUEST_NUM")))	{
//			rMap = (Map<String, Object>) super.commonDao.queryForObject("gre100ukrvServiceImpl.insert", dataMaster);
//			dataMaster.put("REQUEST_NUM", rMap.get("REQUEST_NUM"));
//		}else {
//			super.commonDao.update("gre100ukrvServiceImpl.update", dataMaster);
//		}		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail(deleteList, user);
			if(insertList != null) this.insertDetail(insertList, user);
			if(updateList != null) this.updateDetail(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "busevalution")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("bpr101ukrvService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("bpr101ukrvService.bpr100tInsertDetail", param);
					 
					 if(ObjUtils.parseInt(param.get("SALE_BASIS_P")) != 0 && !"".equals(param.get("SALE_BASIS_P"))){
						 super.commonDao.update("bpr101ukrvService.bpr400tInsertDetail", param);	//판매단가 저장
					 }					 
					 String divCodeList[] = ((String) param.get("DIV_CODE")).split(",");
					 for(int i = 0; i<divCodeList.length; i++){
						 param.put("DIV_CODE", divCodeList[i]);
						 super.commonDao.update("bpr101ukrvService.bpr200tInsertDetail", param);
					 }					 
				 }					 
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "busevalution")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("bpr101ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {				 
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 String divCodeList[] = ((String) param.get("DIV_CODE")).split(",");
				 for(int i = 0; i<divCodeList.length; i++){
					 param.put("DIV_CODE", divCodeList[i]);
					 super.commonDao.update("bpr101ukrvService.bpr200tUpdateDetail", param);//detail 저장
				 }
				 Map chkItemPriceMap = (Map) super.commonDao.select("bpr101ukrvService.checkItemPrice", param);
				 if(ObjUtils.parseInt(chkItemPriceMap.get("CNT")) > 0)	{	//등록된 item판매단가가있을시 update else insert 
					 super.commonDao.update("bpr101ukrvService.bpr400tUpdateDetail", param);
				 }else {
					 super.commonDao.update("bpr101ukrvService.bpr400tInsertDetail", param);
			 	 }				
				 super.commonDao.update("bpr101ukrvService.bpr100tUpdateDetail", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "busevalution", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("bpr101ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 List chkChildList = (List) super.commonDao.list("bpr101ukrvService.checkChildCode", param);
				 if(chkChildList.size() > 0)	{
					 throw new UniDirectValidateException(this.getMessage("547", user)+"[품목코드:"+ObjUtils.getSafeString(param.get("ITEM_CODE"))+"]");
				 }else {
					 try {
						 super.commonDao.delete("bpr101ukrvService.bpr200tDeleteDetail", param);
						 super.commonDao.delete("bpr101ukrvService.bpr100tDeleteDetail", param);						
					 }catch(Exception e)	{
			    			throw new  UniDirectValidateException(this.getMessage("547",user));
			    	}	
				 }
			 }
		 }
		 return 0;
	}*/
}
