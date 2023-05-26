package foren.unilite.modules.base.bpr;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("bpr103ukrvService")
public class Bpr103ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/**
	 * 품목정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectDetailList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("bpr103ukrvService.selectDetailList", param);
	}
	
	/**
	 * 매입단가 정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectSubDetailList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("bpr103ukrvService.selectSubDetailList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
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
//			if(insertList != null) this.insertDetail(insertList, user);	//updateList에서 BPR200T로 INSERT, UPDATE 둘다 이뤄짐
			if(updateList != null) this.updateDetail(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
//	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
//		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("bpr103ukrvService.checkCompCode", compCodeMap);
//			for(Map param : paramList )	{			 
//				 for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
////					 super.commonDao.update("bpr103ukrvService.bpr100tInsertDetail", param);
//					 
//					 if(ObjUtils.parseInt(param.get("SALE_BASIS_P")) == 0 || "".equals(param.get("SALE_BASIS_P"))){
//						 //skip
//					 }else{
//						 super.commonDao.update("bpr103ukrvService.bpr400tInsertDetail", param);	//판매단가 저장
//					 }					 
////					 String divCodeList[] = ((String) param.get("DIV_CODE")).split(",");
////					 for(int i = 0; i<divCodeList.length; i++){
////						 param.put("DIV_CODE", divCodeList[i]);
//						 super.commonDao.update("bpr103ukrvService.bpr200tInsertDetail", param);
////					 }					 
//				 }					 
//			}	
//		}catch(Exception e){
//			throw new  UniDirectValidateException(this.getMessage("2627", user));
//		}
//		
//		return 0;
//	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("bpr103ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {				 
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 Map chkItemMap = (Map) super.commonDao.select("bpr103ukrvService.checkExistBpr200tInfo", param);
				 if(ObjUtils.parseInt(chkItemMap.get("CNT")) > 0)	{
					 super.commonDao.update("bpr103ukrvService.bpr200tUpdateDetail", param);//detail 저장
					 param.put("CLASS", "U");		
					 param.put("data", super.commonDao.insert("bpr103ukrvService.insertLogDetail", param));
				 }else {
					 super.commonDao.update("bpr103ukrvService.bpr200tInsertDetail", param);//detail 저장
					 param.put("CLASS", "N");		
					 param.put("data", super.commonDao.insert("bpr103ukrvService.insertLogDetail", param));
				 }
//				 String divCodeList[] = ((String) param.get("DIV_CODE")).split(",");
//				 for(int i = 0; i<divCodeList.length; i++){
//					 param.put("DIV_CODE", divCodeList[i]);
					
//				 }
//				 Map chkItemPriceMap = (Map) super.commonDao.select("bpr103ukrvService.checkItemPrice", param);
//				 if(ObjUtils.parseInt(chkItemPriceMap.get("CNT")) > 0)	{	//등록된 item판매단가가있을시 update else insert 
//					 super.commonDao.update("bpr103ukrvService.bpr400tUpdateDetail", param);
//				 }else {
//					 super.commonDao.update("bpr103ukrvService.bpr400tInsertDetail", param);
//			 	 }				
//				 super.commonDao.update("bpr103ukrvService.bpr100tUpdateDetail", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "sales", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("bpr103ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 List chkChildList = (List) super.commonDao.list("bpr103ukrvService.checkChildCode", param);
				 if(chkChildList.size() > 0)	{
					 throw new UniDirectValidateException(this.getMessage("547", user)+"[품목코드:"+ObjUtils.getSafeString(param.get("ITEM_CODE"))+"]");
				 }else {
					 try {
						 Map chkItemMap = (Map) super.commonDao.select("bpr103ukrvService.checkExistBpr200tInfo", param);
						 if(ObjUtils.parseInt(chkItemMap.get("CNT")) > 0)	{
							 super.commonDao.delete("bpr103ukrvService.bpr200tDeleteDetail", param);
							 param.put("CLASS", "D");		
							 param.put("data", super.commonDao.insert("bpr103ukrvService.insertLogDetail", param));
						 }
//						 super.commonDao.delete("bpr103ukrvService.bpr100tDeleteDetail", param);						
					 }catch(Exception e)	{
			    			throw new  UniDirectValidateException(this.getMessage("547",user));
			    	}	
				 }
			 }
		 }
		 return 0;
	}
	
	
	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> subSaveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteSubDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertSubDetail")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateSubDetail")) {
					if( "2".equals(dataMaster.get("REG_FLAG"))){	//복사화면(등록여부:'아니오')에서는 UPDATE도 INSERT처리함.
						insertList = (List<Map>)dataListMap.get("data");
					}else{
						updateList = (List<Map>)dataListMap.get("data");
					}
						
				} 
			}			
			if(deleteList != null) this.deleteSubDetail(deleteList, user);
			if(insertList != null) this.insertSubDetail(insertList, user);
			if(updateList != null) this.updateSubDetail(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer  insertSubDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("bpr103ukrvService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));

					 super.commonDao.update("bpr103ukrvService.insertSubDetail", param);
					 }
				}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateSubDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("bpr103ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				
					 super.commonDao.insert("bpr103ukrvService.updateSubDetail", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "sales", needsModificatinAuth = true)
	public Integer deleteSubDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("bpr103ukrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 
					 try {
						 super.commonDao.delete("bpr103ukrvService.deleteSubDetail", param);
						 
					 }catch(Exception e)	{
			    			throw new  UniDirectValidateException(this.getMessage("547",user));
			    	}	
				 }
			 }
		 return 0;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> checkExistBpr400tInfo(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("bpr103ukrvService.checkExistBpr400tInfo", param);
	}
	
	/**
	 * 품목등록여부 검사(매입단가 저장전)
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> checkItemCode(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("bpr103ukrvService.checkItemCode", param);
	}
	
	/**
	 * 품목 인터페이스 갱신
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")
	public void  goInterFace(Map spParam, LoginVO user) throws Exception {
		super.commonDao.queryForObject("bpr103ukrvService.goInterFace", spParam);
	}

}
