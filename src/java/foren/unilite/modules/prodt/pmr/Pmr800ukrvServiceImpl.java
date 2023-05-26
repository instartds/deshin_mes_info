package foren.unilite.modules.prodt.pmr;

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
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;

@Service("pmr800ukrvService")
public class Pmr800ukrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
	
		return  super.commonDao.list("pmr800ukrvServiceImpl.selectList1", param);
	}
	

	/**
	 * 공정리스트
	 * @param param
	 * @param S_COMP_CODE
	 * @param DIV_CODE
	 * @param WORK_SHOP_CODE
	 * @return
	 * @throws Exception
	 */
	
	@Transactional(readOnly = true)
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> progWorkCombo(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("pmr800ukrvServiceImpl.progWorkCombo", param);
		
	}
	
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	 public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 
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
	 
	 @ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
		public Integer  insertDetail(List<Map> paramList, LoginVO user) throws Exception {		
			try {
				Map compCodeMap = new HashMap();
				compCodeMap.put("S_COMP_CODE", user.getCompCode());
				List<Map> chkList = (List<Map>) super.commonDao.list("pmr800ukrvServiceImpl.checkCompCode", compCodeMap);
				for(Map param : paramList )	{			 
					for(Map checkCompCode : chkList) {
						 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
						 super.commonDao.update("pmr800ukrvServiceImpl.insertDetail", param);
					}
				}	
			}catch(Exception e){
				throw new  UniDirectValidateException(this.getMessage("2627", user));
			}
			
			return 0;
		}	
		
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
		public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("pmr800ukrvServiceImpl.checkCompCode", compCodeMap);
			 for(Map param :paramList )	{	
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("pmr800ukrvServiceImpl.updateDetail", param);
				 }
			 }
			 return 0;
		} 
		
		
		@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
		public Integer deleteDetail(List<Map> paramList,  LoginVO user) throws Exception {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List) super.commonDao.list("pmr800ukrvServiceImpl.checkCompCode", compCodeMap);
			 for(Map param :paramList )	{	
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.list("pmr800ukrvServiceImpl.deleteSelect", param);
					 super.commonDao.update("pmr800ukrvServiceImpl.deleteDetail", param);
				 }
			 }
			 return 0;
	} 
	
		
		
		
		
		
		
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
	
		return  super.commonDao.list("pmr800ukrvServiceImpl.selectList2", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class}) 
	 public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		 
		 if(paramList != null)	{
				List<Map> insertList = null;
				List<Map> updateList = null;
				List<Map> deleteList = null;
				for(Map dataListMap: paramList) {
					if(dataListMap.get("method").equals("deleteDetail2")) {
						deleteList = (List<Map>)dataListMap.get("data");
					}else if(dataListMap.get("method").equals("insertDetail2")) {		
						insertList = (List<Map>)dataListMap.get("data");
					} else if(dataListMap.get("method").equals("updateDetail2")) {
						updateList = (List<Map>)dataListMap.get("data");	
					} 
				}			
				if(deleteList != null) this.deleteDetail2(deleteList, user);
				if(insertList != null) this.insertDetail2(insertList, user);
				if(updateList != null) this.updateDetail2(updateList, user);				
			}
		 	paramList.add(0, paramMaster);
				
		 	return  paramList;
	}
	 
	 	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
		public Integer  insertDetail2(List<Map> paramList, LoginVO user) throws Exception {		
			try {
				Map compCodeMap = new HashMap();
				compCodeMap.put("S_COMP_CODE", user.getCompCode());
				List<Map> chkList = (List<Map>) super.commonDao.list("pmr800ukrvServiceImpl.checkCompCode", compCodeMap);
				for(Map param : paramList )	{			 
					for(Map checkCompCode : chkList) {
						 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
						 super.commonDao.update("pmr800ukrvServiceImpl.insertDetail2", param);
					}
				}	
			}catch(Exception e){
				throw new  UniDirectValidateException(this.getMessage("2627", user));
			}
			
			return 0;
		}	
		
		@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
		public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("pmr800ukrvServiceImpl.checkCompCode", compCodeMap);
			 for(Map param :paramList )	{	
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("pmr800ukrvServiceImpl.updateDetail2", param);
				 }
			 }
			 return 0;
		} 
		
		
		@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
		public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List) super.commonDao.list("pmr800ukrvServiceImpl.checkCompCode", compCodeMap);
			 for(Map param :paramList )	{	
				 for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.list("pmr800ukrvServiceImpl.deleteSelect2", param);
					 super.commonDao.update("pmr800ukrvServiceImpl.deleteDetail2", param);
				 }
			 }
			 return 0;
		} 
}
