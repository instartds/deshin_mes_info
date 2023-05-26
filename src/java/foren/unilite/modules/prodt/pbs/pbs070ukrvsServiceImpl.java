package foren.unilite.modules.prodt.pbs;

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
import foren.unilite.modules.com.ext.CalendarModel;

@Service("pbs070ukrvsService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class pbs070ukrvsServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		return  super.commonDao.list("pbs070ukrvsService.selectList1", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  checkYear(Map param) throws Exception {
		return  super.commonDao.list("pbs070ukrvsService.checkYear", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  checkDate(Map param) throws Exception {
		return  super.commonDao.list("pbs070ukrvsService.checkDate", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
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
			if(deleteList != null) this.deleteDetail1(deleteList, user);
			if(insertList != null) this.insertDetail1(insertList, user);
			if(updateList != null) this.updateDetail1(updateList, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertDetail1(List<Map> paramList, LoginVO user) throws Exception {
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("pbs070ukrvsService.checkCompCode", compCodeMap);
			for(Map param : paramList ) {
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("pbs070ukrvsService.insertDetail1", param);
				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail1(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("pbs070ukrvsService.checkCompCode", compCodeMap);
		for(Map param :paramList ) {
			for(Map checkCompCode : chkList) {
				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("pbs070ukrvsService.updateDetail1", param);
			}
		}
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail1(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("pbs070ukrvsService.checkCompCode", compCodeMap);
		for(Map param :paramList ) {	
			for(Map checkCompCode : chkList) {
				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("pbs070ukrvsService.deleteDetail1", param);
			}
		}
		return 0;
	}



	/**
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return  super.commonDao.list("pbs070ukrvsService.selectList2", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList1 = null;
			List<Map> deleteList2 = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail1")) {
					deleteList1 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteDetail2")) {
					deleteList2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList1 != null) this.deleteDetail2_1(deleteList1, user);
			if(deleteList2 != null) this.deleteDetail2_2(deleteList2, user);
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
			List<Map> chkList = (List<Map>) super.commonDao.list("pbs070ukrvsService.checkCompCode", compCodeMap);
			for(Map param : paramList ) {
				for(Map checkCompCode : chkList) {
					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					super.commonDao.update("pbs070ukrvsService.insertDetail2", param);
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
		List<Map> chkList = (List<Map>) super.commonDao.list("pbs070ukrvsService.checkCompCode", compCodeMap);
		 for(Map param :paramList ) {
			 for(Map checkCompCode : chkList) {
				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("pbs070ukrvsService.updateDetail2", param);
			}
		}
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail2_1(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("pbs070ukrvsService.checkCompCode", compCodeMap);
		for(Map param :paramList ) {
			for(Map checkCompCode : chkList) {
				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("pbs070ukrvsService.deleteDetail2_1", param);
			}
		}
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail2_2(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("pbs070ukrvsService.checkCompCode", compCodeMap);
		for(Map param :paramList ) {
			for(Map checkCompCode : chkList) {
				param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				super.commonDao.update("pbs070ukrvsService.deleteDetail2_2", param);
			}
		}
		return 0;
	}



	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<CalendarModel> readCalendars() {
		return (List<CalendarModel>) super.commonDao.list("pbs070ukrvsService.getCalendarList");
	}

	@ExtDirectMethod( value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> getEventList(Map param, LoginVO user) throws Exception {
		List<Map<String, Object>> dataList = (List) super.commonDao.list("pbs070ukrvsService.getEventList", param);
		for(Map<String, Object> data : dataList ) {
			data.put("allDay", Boolean.TRUE);
		}
		//logger.debug(dataList.toString());
		return dataList;
	}

	/**
	 * 카렌더정보수정 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Object  updateDetail3(Map param, LoginVO user) throws Exception {
		Map errorMap = new HashMap();
		errorMap = (Map)super.commonDao.select("pbs070ukrvsService.updateDetail3", param);
		String errorStr = "";
		if(!ObjUtils.isEmpty(errorMap)){
			errorStr = (String) errorMap.get("V_STRDESC");
		}
		if(!ObjUtils.isEmpty(errorStr)){
			throw new  UniDirectValidateException(errorStr);
		}else{
			return true;
		}
	}



	/**
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList4(Map param) throws Exception {
		return  super.commonDao.list("pbs070ukrvsService.selectList4", param);
	}



	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList5(Map param) throws Exception {
		return  super.commonDao.list("pbs070ukrvsService.selectList5", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList5_2(Map param) throws Exception {
		return  super.commonDao.list("pbs070ukrvsService.selectList5_2", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList5_3(Map param) throws Exception {
		return  super.commonDao.list("pbs070ukrvsService.selectList5_3", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList5SameSelect(Map param) throws Exception {
		return  super.commonDao.list("pbs070ukrvsService.selectList5SameSelect", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll5(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail5")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail5")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail5")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteDetail5(deleteList, user);
			if(insertList != null) this.insertDetail5(insertList, user);
			if(updateList != null) this.updateDetail5(updateList, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertDetail5(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("pbs070ukrvsService.insertDetail5", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail5(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("pbs070ukrvsService.updateDetail5", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail5(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("pbs070ukrvsService.deleteDetail5", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll5_2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
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
			if(deleteList != null) this.deleteDetail5_2(deleteList, user);
			if(insertList != null) this.insertDetail5_2(insertList, user);
			if(updateList != null) this.updateDetail5_2(updateList, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")	// INSERT
	public Integer  insertDetail5_2(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("pbs070ukrvsService.insertDetail5_2", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")	  // UPDATE
	public Integer updateDetail5_2(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {   
			super.commonDao.update("pbs070ukrvsService.updateDetail5_2", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)	// DELETE
	public Integer deleteDetail5_2(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("pbs070ukrvsService.deleteDetail5_2", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll5_3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
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
			if(deleteList != null) this.deleteDetail5_3(deleteList, user);
			if(insertList != null) this.insertDetail5_3(insertList, user);
			if(updateList != null) this.updateDetail5_3(updateList, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")	// INSERT
	public Integer  insertDetail5_3(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("pbs070ukrvsService.insertDetail5_3", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")	// UPDATE
	public Integer updateDetail5_3(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("pbs070ukrvsService.updateDetail5_3", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)	// DELETE
	public Integer deleteDetail5_3(List<Map> paramList,  LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("pbs070ukrvsService.deleteDetail5_3", param);
		}
		return 0;
	}



	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList6(Map param) throws Exception {
		return  super.commonDao.list("pbs070ukrvsService.selectList6", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectItemCopyList(Map param) throws Exception {
		return  super.commonDao.list("pbs070ukrvsService.selectItemCopyList", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectWorkShopCopyWindowList(Map param) throws Exception {
		return  super.commonDao.list("pbs070ukrvsService.selectWorkShopCopyWindowList", param);
	}

	/**
	 * 작업장 공정코드 복사: 20200603 추가
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> copyAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> insertList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("copyWorkShopProgCode")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}
			if(insertList != null) this.copyWorkShopProgCode(insertList, paramMaster, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")
	public Integer copyWorkShopProgCode( List<Map> paramList, Map paramMaster,  LoginVO user) throws Exception {
		try {
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			for(Map param: paramList) {
				param.put("WORK_SHOP_CODE", dataMaster.get("WORK_SHOP_CODE"));
				super.commonDao.insert("pbs070ukrvsService.copyWorkShopProgCode", param);
			}
		} catch(Exception e){
			throw new  UniDirectValidateException("복사 중 오류가 발생했습니다.");
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList6_2(Map param) throws Exception {
		return  super.commonDao.list("pbs070ukrvsService.selectList6_2", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll6_2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail6_2")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail6_2")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail6_2")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteDetail6_2(deleteList, user);
			if(insertList != null) this.insertDetail6_2(insertList, user);
			if(updateList != null) this.updateDetail6_2(updateList, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public Integer  insertDetail6_2(List<Map> paramList, LoginVO user) throws Exception {
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("pbs070ukrvsService.checkCompCode", compCodeMap);
			for(Map param : paramList ) {
				for(Map checkCompCode : chkList) {
					List<Map> itemCodeList = (List<Map>) param.get("ITEM_CODE");
					for(int k=0; k<itemCodeList.size(); k++){
						param.put("ITEM_CODE", itemCodeList.get(k));
						param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
						super.commonDao.update("pbs070ukrvsService.insertDetail6_2", param);
					}
				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		return 0;
	}	

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public Integer updateDetail6_2(List<Map> paramList, LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("pbs070ukrvsService.checkCompCode", compCodeMap);
		 for(Map param :paramList ) {
			for(Map checkCompCode : chkList) {
				String[] itemCode = ObjUtils.getSafeString(param.get("ITEM_CODE")).split(",");
				List<String> itemCodeList =  new ArrayList<>();
				for(String temp : itemCode){
					itemCodeList.add(temp);
				}
				for(int k=0; k<itemCodeList.size(); k++){
					param.put("ITEM_CODE", itemCodeList.get(k));
					param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					super.commonDao.update("pbs070ukrvsService.updateDetail6_2", param);
				}
			}
		 }
		 return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail6_2(List<Map> paramList,  LoginVO user) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("pbs070ukrvsService.checkCompCode", compCodeMap);
		 for(Map param :paramList ) {
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("pbs070ukrvsService.deleteDetail6_2", param);
			 }
		 }
		 return 0;
	}
}