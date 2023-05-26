package foren.unilite.modules.base.bpr;

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

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.fileman.FileMnagerService;

@Service("bpr101skrvService")
public class Bpr101skrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	/** 품목정보 엑셀 업로드 **/
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)		// 엑셀 업로드
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("bpr101skrvService.selectExcelUploadSheet1", param);
    }
	
	public void excelValidate(String jobID, Map param) {							// 엑셀 Validate
	    logger.debug("validate: {}", jobID);
		super.commonDao.update("bpr101skrvService.excelValidate", param);
	}
	
	@ExtDirectMethod(group = "base", value = ExtDirectMethodType.STORE_READ)		// 엑셀데이터 저장
    public void saveExcelData(Map param) throws Exception {
        super.commonDao.update("bpr101skrvService.saveExcel", param);
    }
	
	/**
	 * 품목정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectDetailList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("bpr101skrvService.selectDetailList", param);
	}
	
	/**
	 * 품목중복검사
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> checkItemDuplicate(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("bpr101skrvService.checkItemDuplicate", param);
	}
	
	/**
	 * 품목중복검사
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> checkItemCode(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("bpr101skrvService.checkItemCode", param);
	}
	
	/**
	 * 매입단가 정보 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectStockList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("bpr101skrvService.selectStockList", param);
	}
	
	/**
	 * 창고별재고현황 조회
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectSubDetailList(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("bpr101skrvService.selectSubDetailList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "busmaintain")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {		
		//인터페이스 품목 UPDATE처리 위한 LOG생성..
		List<Map> dataList = new ArrayList<Map>();
		String keyValue = getLogKey();
		for(Map paramData: paramList) {			
			
			dataList = (List<Map>) paramData.get("data");
			logger.debug("paramData.get('data') : " + dataList);
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";
			
			for(Map param:  dataList) {
				String insertDivCode = (String) param.get("DIV_CODE");
				param.put("KEY_VALUE", keyValue);
				param.put("CLASS", oprFlag);
				Map compCodeMap = new HashMap();
				compCodeMap.put("S_COMP_CODE", user.getCompCode());
				if(oprFlag == "N"){					
					List<Map> divList = (List<Map>) super.commonDao.list("bpr101skrvService.getDivList", compCodeMap);
					for(Map divCode : divList) {
						param.put("DIV_CODE", divCode.get("DIV_CODE"));
						param.put("data", super.commonDao.insert("bpr101skrvService.insertLogDetail", param));
						param.put("DIV_CODE", insertDivCode);
					}
				}else{
					param.put("data", super.commonDao.insert("bpr101skrvService.insertLogDetail", param));
				}			
			}
		}
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
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		dataMaster.put("KEY_VALUE", keyValue);		
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();			
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("bpr101skrvService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{	
				String insertDivCode = (String) param.get("DIV_CODE");
				if(ObjUtils.isEmpty(param.get("ITEM_CODE"))){
					List<Map> itemCode = (List<Map>) super.commonDao.list("bpr101skrvService.getAutoItemCode", compCodeMap);
					param.put("ITEM_CODE", itemCode.get(0).get("ITEM_CODE"));
				}
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("bpr101skrvService.bpr100tInsertDetail", param);
					 
					 if(ObjUtils.parseInt(param.get("SALE_BASIS_P")) != 0 && !"".equals(param.get("SALE_BASIS_P"))){
						 super.commonDao.update("bpr101skrvService.bpr400tInsertDetail", param);	//판매단가 저장
					 }					 
					 List<Map> divList = (List<Map>) super.commonDao.list("bpr101skrvService.getDivList", compCodeMap);
					 for(Map divCode : divList) {
						 param.put("DIV_CODE", divCode.get("DIV_CODE"));
						 super.commonDao.update("bpr101skrvService.bpr200tInsertDetail", param);
						 param.put("DIV_CODE", insertDivCode);
					 }
//					 String divCodeList[] = ((String) param.get("DIV_CODE")).split(",");
//					 for(int i = 0; i<divCodeList.length; i++){
//						 param.put("DIV_CODE", divCodeList[i]);
//						 super.commonDao.update("bpr101skrvService.bpr200tInsertDetail", param);
//					 }
				 }					 
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("bpr101skrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {				 
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
//				 Map chkItemMap = (Map) super.commonDao.select("bpr101skrvService.checkItemCode", param);
//				 if(ObjUtils.parseInt(chkItemMap.get("CNT")) > 0)	{
//					 super.commonDao.insert("bpr101skrvService.updateDetail", param);
//				 }else {
//					 super.commonDao.update("bpr101skrvService.insertDetail", param);
//				 }
				 String divCodeList[] = ((String) param.get("DIV_CODE")).split(",");
				 for(int i = 0; i<divCodeList.length; i++){
					 param.put("DIV_CODE", divCodeList[i]);
					 super.commonDao.update("bpr101skrvService.bpr200tUpdateDetail", param);//detail 저장
				 }
				 //어차피 판매단가는 별도 저장됨..
//				 if(ObjUtils.parseInt(param.get("SALE_BASIS_P")) != 0 && !"".equals(param.get("SALE_BASIS_P"))){
//					 Map chkItemPriceMap = (Map) super.commonDao.select("bpr101skrvService.checkItemPrice", param);
//					 if(ObjUtils.parseInt(chkItemPriceMap.get("CNT")) > 0)	{	//등록된 item판매단가가있을시 update else insert 
//						 super.commonDao.update("bpr101skrvService.bpr400tUpdateDetail", param);
//					 }else {
//						 super.commonDao.update("bpr101skrvService.bpr400tInsertDetail", param);
//				 	 }
//				 }
								
				 super.commonDao.update("bpr101skrvService.bpr100tUpdateDetail", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "sales", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("bpr101skrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 List chkChildList = (List) super.commonDao.list("bpr101skrvService.checkChildCode", param);
				 if(chkChildList.size() > 0)	{
					 throw new UniDirectValidateException(this.getMessage("547", user)+"[품목코드:"+ObjUtils.getSafeString(param.get("ITEM_CODE"))+"]");
				 }else {
					 try {
						 super.commonDao.delete("bpr101skrvService.bpr200tDeleteDetail", param);
						 param.put("DIV_CODE", "");
						 Map chkItemMap = (Map) super.commonDao.select("bpr101skrvService.checkItemCode", param);
						 if(ObjUtils.parseInt(chkItemMap.get("CNT")) == 0)	{
							 super.commonDao.delete("bpr101skrvService.bpr100tDeleteDetail", param);
						 }
					 }catch(Exception e)	{
			    			throw new  UniDirectValidateException(this.getMessage("547",user));
			    	}	
				 }
			 }
		 }
		 return 0;
	}
	
	/**
	 * 판매단가 변경 버튼 누를시
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public String  updateSaleBasisP(Map spParam, LoginVO user) throws Exception {
		String keyValue = getLogKey();
		try{
			super.commonDao.update("bpr101skrvService.updateSaleBasisP1", spParam);
			Map chkSaleBasisPDuplicateMap = (Map) super.commonDao.select("bpr101skrvService.chkSaleBasisPDuplicate", spParam);
			if(ObjUtils.parseInt(chkSaleBasisPDuplicateMap.get("CNT")) > 0)	{	//등록된 item판매단가가있을시 update else insert
				super.commonDao.delete("bpr101skrvService.deleteSaleBasisPDuplicate", spParam);
			}			 
			super.commonDao.update("bpr101skrvService.updateSaleBasisP2", spParam);
			super.commonDao.update("bpr101skrvService.updateSaleBasisP3", spParam);			
			spParam.put("KEY_VALUE", keyValue);
			spParam.put("CLASS", "U");		
			spParam.put("data", super.commonDao.insert("bpr101skrvService.insertLogDetail", spParam));
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return keyValue;
		
	}
	
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> subSaveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//인터페이스 품목 UPDATE처리 위한 LOG생성..
		List<Map> dataList = new ArrayList<Map>();
		String keyValue = getLogKey();
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			logger.debug("paramData.get('data') : " + dataList);
			String oprFlag = "N";
			if(paramData.get("method").equals("insertSubDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateSubDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteSubDetail"))	oprFlag="D";
			
			for(Map param:  dataList) {
				if(oprFlag == "N"){
					param.put("KEY_VALUE", keyValue);
					param.put("CLASS", "P");				
					param.put("data", super.commonDao.insert("bpr101skrvService.insertLogDetail", param));
				}										
			}
		}
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
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteSubDetail(deleteList, user);
			if(insertList != null) this.insertSubDetail(insertList, user);
			if(updateList != null) this.updateSubDetail(updateList, user);				
		}
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		dataMaster.put("KEY_VALUE", keyValue);		
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer  insertSubDetail(List<Map> paramList, LoginVO user) throws Exception {		
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("bpr101skrvService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));

					 super.commonDao.update("bpr101skrvService.insertSubDetail", param);
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
		List<Map> chkList = (List<Map>) super.commonDao.list("bpr101skrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				
					 super.commonDao.insert("bpr101skrvService.updateSubDetail", param);
			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "sales", needsModificatinAuth = true)
	public Integer deleteSubDetail(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("bpr101skrvService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 
					 try {
						 super.commonDao.delete("bpr101skrvService.deleteSubDetail", param);
						 
					 }catch(Exception e)	{
			    			throw new  UniDirectValidateException(this.getMessage("547",user));
			    	}	
				 }
			 }
		 return 0;
	}
	
	/*품목 자동완성 기능 조회*/
	@ExtDirectMethod( group = "txt")
	public Object searchMenu(Map param, LoginVO user) throws Exception {
		List<Map<String,Object>> list = super.commonDao.list("bpr101skrvService.searchMenu", param);
		Map<String, Object> rv = new HashMap<String, Object>();
		rv.put("records", list);		
		return rv;
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
		super.commonDao.queryForObject("bpr101skrvService.goInterFace", spParam);
	}
	

}
