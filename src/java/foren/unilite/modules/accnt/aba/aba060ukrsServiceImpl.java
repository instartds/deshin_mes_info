package foren.unilite.modules.accnt.aba;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.service.impl.TlabMenuService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.accnt.aba.Aba060ukrvModel;
import foren.unilite.modules.accnt.AccntCommonServiceImpl;
import foren.unilite.modules.base.bor.Bor100ukrvModel;
import foren.unilite.modules.base.bsa.Bsa100ukrvServiceImpl;


@Service("aba060ukrsService")
public class aba060ukrsServiceImpl  extends TlabAbstractServiceImpl {
	
	@Resource(name = "tlabMenuService")
	 TlabMenuService tlabMenuService;
	@Resource(name = "tlabCodeService")
	 TlabCodeService tlabCodeService;
	@Resource(name = "bsa100ukrvService")
	Bsa100ukrvServiceImpl bsa100ukrvService;
	/* 회계업무설정 초기값 조회(aba100t)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.FORM_LOAD)
	public Object fnGetBaseData(Map param) throws Exception {
		return super.commonDao.select("aba060ukrsService.fnGetBaseData", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult saveBaseData(Aba060ukrvModel param, LoginVO user,  BindingResult result) throws Exception {
		param.setS_COMP_CODE(user.getCompCode());
		param.setS_USER_ID(user.getUserID());
		super.commonDao.update("aba060ukrsService.saveBaseData", param);
		
		//공통코드 A151 자산코드 자동채변 여부 값 update
		if(param.getASST_AUTOCD() != null )	{
			if("1".equals(param.getASST_AUTOCD()) || "2".equals(param.getASST_AUTOCD()) )	{
				CodeInfo  codeInfo = tlabCodeService.getCodeInfo(user.getCompCode());
				List<CodeDetailVO> autoCdYn = codeInfo.getCodeList("A151", "", false);
				if(autoCdYn != null)	{
					for(CodeDetailVO code: autoCdYn)	{
						if(!"$".equals(code.getCodeNo()))	{
							Map param1 = new HashMap();
							param1.put("S_COMP_CODE",  user.getCompCode());
							param1.put("MAIN_CODE", code.getGroupCD());
							param1.put("SUB_CODE", code.getCodeNo());
							param1.put("CODE_NAME", code.getCodeName());
							param1.put("S_USER_ID", user.getUserID());
							
							if("1".equals(param.getASST_AUTOCD()))	{
								param1.put("REF_CODE1", "Y");
							} else {
								param1.put("REF_CODE1", "N");
							}
							bsa100ukrvService.updateCode(param1);
						}
					}
				}
			}
		}
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
			
		return extResult;
	}

	/* 부가세 유형 국내/해외 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  getExportYnKind(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.getExportYnKind", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  getTradeDivKind(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.getTradeDivKind", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  checkCount(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.checkCount", param);
	}
	
	/* 조회 데이터 포멧설정 - 조회 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectForm(Map param) throws Exception {
		return super.commonDao.select("aba060ukrsService.selectForm", param);
	}
	
	/* 조회 데이터 포멧설정 - 저장 */
	@ExtDirectMethod(value = ExtDirectMethodType.FORM_POST, group = "accnt")
	public ExtDirectFormPostResult syncForm(Aba060ukrvModel dataMaster,  LoginVO user,  BindingResult result) throws Exception {	
	
		dataMaster.setS_COMP_CODE(user.getCompCode());
		dataMaster.setS_USER_ID(user.getUserID());
		super.commonDao.update("aba060ukrsService.updateForm", dataMaster);
		ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(result);
		tlabMenuService.reload();
		return extResult;
		
	}
	
	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.selectList1", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
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
			if(deleteList != null) this.deleteDetail1(deleteList, user);
			if(insertList != null) this.insertDetail1(insertList, user);
			if(updateList != null) this.updateDetail1(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
	public Integer  insertDetail1(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
//				for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("aba060ukrsService.insertDetail1", param);
//				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail1(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.updateDetail1", param);
//			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail1(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.deleteDetail1", param);
//			 }
		 }
		 return 0;
	}
	
	
	
	
	
	/**
	 * 매입매출전표
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList2(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.selectList2", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
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
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
	public Integer  insertDetail2(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
//				for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("aba060ukrsService.insertDetail2", param);
//				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.updateDetail2", param);
//			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail2(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.deleteDetail2", param);
//			 }
		 }
		 return 0;
	}

	
	
	
	/**
	 * 급여/상여
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList3(Map param) throws Exception {
		return  super.commonDao.list("aba060ukrsService.selectList3", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail3")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail3")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail3")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail3(deleteList, user);
			if(insertList != null) this.insertDetail3(insertList, user);
			if(updateList != null) this.updateDetail3(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
	public Integer  insertDetail3(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
//				for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("aba060ukrsService.insertDetail3", param);
//				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail3(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.updateDetail3", param);
//			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail3(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.deleteDetail3", param);
//			 }
		 }
		 return 0;
	}
	
	/**
	 * 기타소득
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList4(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.selectList4", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail4")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail4")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail4")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail4(deleteList, user);
			if(insertList != null) this.insertDetail4(insertList, user);
			if(updateList != null) this.updateDetail4(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
	public Integer  insertDetail4(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
//				for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("aba060ukrsService.insertDetail4", param);
//				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail4(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.updateDetail4", param);
//			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail4(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.deleteDetail4", param);
//			 }
		 }
		 return 0;
	}
	
	
	
	/**
	 * 매출
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList5(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.selectList5", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll5(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
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
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
	public Integer  insertDetail5(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			//List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
				//for(Map checkCompCode : chkList) {
					// param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("aba060ukrsService.insertDetail5", param);
				//}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail5(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		//List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 //for(Map checkCompCode : chkList) {
				 //param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.updateDetail5", param);
			 //}
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail5(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		//List<Map> chkList = (List) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
			 //for(Map checkCompCode : chkList) {
			//	 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.deleteDetail5", param);
			// }
		 }
		 return 0;
	}
	
	
	
	/**
	 * 수금
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList6(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.selectList6", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll6(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail6")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail6")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail6")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail6(deleteList, user);
			if(insertList != null) this.insertDetail6(insertList, user);
			if(updateList != null) this.updateDetail6(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
	public Integer  insertDetail6(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
//				for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("aba060ukrsService.insertDetail6", param);
//				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail6(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.updateDetail6", param);
//			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail6(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.deleteDetail6", param);
//			 }
		 }
		 return 0;
	}
	
	
	/**
	 * 매입
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList7(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.selectList7", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll7(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail7")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail7")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail7")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail7(deleteList, user);
			if(insertList != null) this.insertDetail7(insertList, user);
			if(updateList != null) this.updateDetail7(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
	public Integer  insertDetail7(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
//				for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("aba060ukrsService.insertDetail7", param);
//				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail7(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.updateDetail7", param);
//			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail7(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.deleteDetail7", param);
//			 }
		 }
		 return 0;
	}
	
	
	/**
	 * 무역경비
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList8(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.selectList8", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll8(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail8")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail8")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail8")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail8(deleteList, user);
			if(insertList != null) this.insertDetail8(insertList, user);
			if(updateList != null) this.updateDetail8(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
	public Integer  insertDetail8(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
//				for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("aba060ukrsService.insertDetail8", param);
//				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail8(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.updateDetail8", param);
//			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail8(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.deleteDetail8", param);
//			 }
		 }
		 return 0;
	}
	
	/**
	 * 고정자산취득
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList9(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.selectList9", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll9(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail9")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail9")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail9")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail9(deleteList, user);
			if(insertList != null) this.insertDetail9(insertList, user);
			if(updateList != null) this.updateDetail9(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
	public Integer  insertDetail9(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
//				for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("aba060ukrsService.insertDetail9", param);
//				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail9(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.updateDetail9", param);
//			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail9(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.deleteDetail9", param);
//			 }
		 }
		 return 0;
	}
	
	/**
	 * 감가상각
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList10(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.selectList10", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll10(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail10")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail10")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail10")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail10(deleteList, user);
			if(insertList != null) this.insertDetail10(insertList, user);
			if(updateList != null) this.updateDetail10(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
	public Integer  insertDetail10(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
//				for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("aba060ukrsService.insertDetail10", param);
//				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail10(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.updateDetail10", param);
//			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail10(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.deleteDetail10", param);
//			 }
		 }
		 return 0;
	}
	
	/**
	 * 미착대체
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList11(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.selectList11", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll11(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail11")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail11")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail11")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail11(deleteList, user);
			if(insertList != null) this.insertDetail11(insertList, user);
			if(updateList != null) this.updateDetail11(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
	public Integer  insertDetail11(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
//				for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("aba060ukrsService.insertDetail11", param);
//				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail11(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.updateDetail11", param);
//			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail11(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.deleteDetail11", param);
//			 }
		 }
		 return 0;
	}	
	
	/**
	 * 외화환산자동기표방법등록 (aba060ukrs13.jsp)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList12(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.selectList12", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll12(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail12")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail12")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail12")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail12(deleteList, user);
			if(insertList != null) this.insertDetail12(insertList, user);
			if(updateList != null) this.updateDetail12(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
	public Integer  insertDetail12(List<Map> paramList, LoginVO user) throws Exception {		
		try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
//				for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("aba060ukrsService.insertDetail12", param);
//				}
			}	
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail12(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.updateDetail12", param);
//			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail12(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.deleteDetail12", param);
//			 }
		 }
		 return 0;
	}
	
	/**
	 * 미착
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList16(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.selectList16", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll16(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail16")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail16")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail16")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail16(deleteList, user);
			if(insertList != null) this.insertDetail16(insertList, user);
			if(updateList != null) this.updateDetail16(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
	public Integer  insertDetail16(List<Map> paramList, LoginVO user) throws Exception {		
		//try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
//				for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("aba060ukrsService.insertDetail16", param);
//				}
			}	
		//}catch(Exception e){
		//	throw new  UniDirectValidateException(this.getMessage("2627", user));
		//}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail16(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.updateDetail16", param);
//			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail16(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.deleteDetail16", param);
//			 }
		 }
		 return 0;
	}
	
	/**
	 * 외화환산평가
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  selectList17(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.selectList17", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll17(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail17")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail17")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail17")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail17(deleteList, user);
			if(insertList != null) this.insertDetail17(insertList, user);
			if(updateList != null) this.updateDetail17(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		
	public Integer  insertDetail17(List<Map> paramList, LoginVO user) throws Exception {		
		for(Map param : paramList )	{			 
			Map<String, Object> map = (Map<String, Object>) super.commonDao.select("aba060ukrsService.selectCount17", param);
			if(map != null && ObjUtils.parseInt(map.get("CNT")) > 0)	{
				String message ="  외화평가구분 : "+ ObjUtils.getSafeString(param.get("GUBUN")) + "\n" +
						"  계정코드 : "+ObjUtils.getSafeString(param.get("ACCNT")) ;
				throw new  UniDirectValidateException("이미 등록된 내용이 있습니다.||" +message);
			}
		}
		for(Map param : paramList )	{			 
				super.commonDao.update("aba060ukrsService.insertDetail17", param);
		}	
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail17(List<Map> paramList, LoginVO user) throws Exception {
		 for(Map param :paramList )	{	
			 super.commonDao.update("aba060ukrsService.updateDetail17", param);
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail17(List<Map> paramList,  LoginVO user) throws Exception {
		 for(Map param :paramList )	{	
				 super.commonDao.update("aba060ukrsService.deleteDetail17", param);
		 }
		 return 0;
	}
	
	/**
	 * 지출결의
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectList18(Map param) throws Exception {
	
		return  super.commonDao.list("aba060ukrsService.selectList18", param);
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll18(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {	
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail18")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail18")) {		
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateDetail18")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail18(deleteList, user);
			if(insertList != null) this.insertDetail18(insertList, user);
			if(updateList != null) this.updateDetail18(updateList, user);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}
	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// INSERT
	public Integer  insertDetail18(List<Map> paramList, LoginVO user) throws Exception {		
		//try {
//			Map compCodeMap = new HashMap();
//			compCodeMap.put("S_COMP_CODE", user.getCompCode());
//			List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{			 
//				for(Map checkCompCode : chkList) {
//					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
					 super.commonDao.update("aba060ukrsService.insertDetail18", param);
//				}
			}	
		//}catch(Exception e){
		//	throw new  UniDirectValidateException(this.getMessage("2627", user));
		//}
		
		return 0;
	}	
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")		// UPDATE
	public Integer updateDetail18(List<Map> paramList, LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List<Map>) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.updateDetail18", param);
//			 }
		 }
		 return 0;
	} 
	
	
	@ExtDirectMethod(group = "accnt", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail18(List<Map> paramList,  LoginVO user) throws Exception {
//		Map compCodeMap = new HashMap();
//		compCodeMap.put("S_COMP_CODE", user.getCompCode());
//		List<Map> chkList = (List) super.commonDao.list("aba060ukrsService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{	
//			 for(Map checkCompCode : chkList) {
//				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 super.commonDao.update("aba060ukrsService.deleteDetail18", param);
//			 }
		 }
		 return 0;
	}

}
