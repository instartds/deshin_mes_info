package foren.unilite.modules.z_mit;

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


@Service("s_bpr560ukrv_mitService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Bpr560ukrv_mitServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.FORM_LOAD)
	public Object selectMaster(Map param) throws Exception {
		return super.commonDao.select("s_bpr560ukrv_mitService.selectMaster", param);
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_bpr560ukrv_mitService.selectList", param);
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("s_bpr560ukrv_mitService.selectList2", param);
	}

	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		return super.commonDao.list("s_bpr560ukrv_mitService.selectList3", param);
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "base")
	 @Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	 public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
	 if(paramList != null)	{

			Map paramMap = new HashMap();
			paramMap.put("S_COMP_CODE", user.getCompCode());
			
			Map checkAllDiv = (Map) super.commonDao.select("s_bpr560ukrv_mitService.checkAllDiv", paramMap);
		 
			String allDivYn = "N";
			
			if(ObjUtils.isNotEmpty(checkAllDiv)){
				allDivYn = ObjUtils.getSafeString(checkAllDiv.get("SUB_CODE"));
			}
			
			List<Map> allDivList = null;
			allDivList =  super.commonDao.list("s_bpr560ukrv_mitService.selectDivList", paramMap);
			
			List<Map> deleteList = null;
			List<Map> deleteList2 = null;			// GIRD2
			List<Map> deleteList3 = null;			// GRID3

			List<Map> insertList = null;
			List<Map> insertList2 = null;
			List<Map> insertList3 = null;


			List<Map> updateList = null;
			List<Map> updateList2 = null;
			List<Map> updateList3 = null;


			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteDetailGRID2")) {
					deleteList2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("deleteDetailGRID3")) {
					deleteList3 = (List<Map>)dataListMap.get("data");
				}

				else if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail2")) {
					insertList2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertDetail3")) {
					insertList3 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail2")) {
					updateList2 = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetailGRID3")) {
					updateList3 = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteDetail(deleteList, user,allDivYn);
			if(deleteList2 != null) this.deleteDetailGRID2(deleteList2, user,allDivYn);
			if(deleteList3 != null) this.deleteDetailGRID3(deleteList3, user,allDivYn);

			if(insertList != null) this.insertDetail(insertList, user,allDivYn,allDivList);
			if(insertList2 != null) this.insertDetail2(insertList2, user,allDivYn,allDivList);
			if(insertList3!= null) this.insertDetail3(insertList3, user,allDivYn,allDivList);

			if(updateList != null) this.updateDetail(updateList, user,allDivYn);
			if(updateList2 != null) this.updateDetail2(updateList2, user,allDivYn);
			if(updateList3 != null) this.updateDetailGRID3(updateList3, user,allDivYn);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public void insertDetail(List<Map> paramList, LoginVO user, String allDivYn, List<Map> allDivList) throws Exception {
		int duplicationChk = 0;
		String chkMsg = "";
		try {
			Map compCodeMap = new HashMap();
			for(Map param : paramList)	{
				duplicationChk = (int) super.commonDao.queryForObject("s_bpr560ukrv_mitService.prodItemCodeDuplicationChk", param);
				if(duplicationChk > 0){
					chkMsg =  "\n" + "품목코드: " +  (String) param.get("PROD_ITEM_CODE") + "\n"  + "품목명: " +  (String) param.get("ITEM_NAME");
					throw new  Exception();
			     }

//				if b910  Y 면  해당 모품목에 자품목에 대체품목인 전사업장 delete 후 
//				for(전사업장 
//						insert 
				if(allDivYn.equals("Y")){
					 super.commonDao.delete("s_bpr560ukrv_mitService.deleteAllDiv", param);
					
					if(allDivList != null){
						for(Map addParams : allDivList){
							param.put("DIV_CODE", addParams.get("DIV_CODE"));
							super.commonDao.update("s_bpr560ukrv_mitService.insertDetail", param);
						}
					}
					
				}else{
					super.commonDao.update("s_bpr560ukrv_mitService.insertDetail", param);
					
				}
			}
		}catch(Exception e){
				throw new  UniDirectValidateException(this.getMessage("2627", user) + chkMsg);
		}

		return;
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public void insertDetail2(List<Map> paramList, LoginVO user, String allDivYn, List<Map> allDivList) throws Exception {
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("s_bpr560ukrv_mitService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));

//						if b910  Y 면  해당 모품목에 자품목에 대체품목인 전사업장 delete 후 
//						for(전사업장 
//								insert 
					 if(allDivYn.equals("Y")){
						 super.commonDao.delete("s_bpr560ukrv_mitService.deleteAllDiv", param);
						
						if(allDivList != null){
							for(Map addParams : allDivList){
								param.put("DIV_CODE", addParams.get("DIV_CODE"));
								 super.commonDao.update("s_bpr560ukrv_mitService.insertDetail2", param);
							}
						}
						
					}else{
						 super.commonDao.update("s_bpr560ukrv_mitService.insertDetail2", param);
						
					}
				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}

		return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT GIRD3
	public void  insertDetail3(List<Map> paramList, LoginVO user, String allDivYn, List<Map> allDivList) throws Exception {
		try {
			Map compCodeMap = new HashMap();
			compCodeMap.put("S_COMP_CODE", user.getCompCode());
			List<Map> chkList = (List<Map>) super.commonDao.list("s_bpr560ukrv_mitService.checkCompCode", compCodeMap);
			for(Map param : paramList )	{
				for(Map checkCompCode : chkList) {
					 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));

//						if b910  Y 면  해당 모품목에 자품목에 대체품목인 전사업장 delete 후 
//						for(전사업장 
//								insert 
					 if(allDivYn.equals("Y")){
						 super.commonDao.delete("s_bpr560ukrv_mitService.deleteAllDiv2", param);
						
						if(allDivList != null){
							for(Map addParams : allDivList){
								param.put("DIV_CODE", addParams.get("DIV_CODE"));
								super.commonDao.update("s_bpr560ukrv_mitService.insertDetail3", param);
							}
						}
						
					}else{
						 super.commonDao.update("s_bpr560ukrv_mitService.insertDetail3", param);
					}
				}
			}
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("2627", user));
		}

		return;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public void updateDetail(List<Map> paramList, LoginVO user, String allDivYn) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("s_bpr560ukrv_mitService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 
//					if b910  Y 면  해당 데이터로 div_code 조건 빼고 update
				 if(allDivYn.equals("Y")){
					 super.commonDao.delete("s_bpr560ukrv_mitService.updateAllDiv0", param);
					
				}else{
					 super.commonDao.update("s_bpr560ukrv_mitService.updateDetail", param);
				}
				 
			 }
		 }
		 return;
	}
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE
	public void updateDetail2(List<Map> paramList, LoginVO user, String allDivYn) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("s_bpr560ukrv_mitService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
				 
//					if b910  Y 면  해당 데이터로 div_code 조건 빼고 update
				 if(allDivYn.equals("Y")){
					 super.commonDao.delete("s_bpr560ukrv_mitService.updateAllDiv", param);
					
				}else{
					 super.commonDao.update("s_bpr560ukrv_mitService.updateDetail2", param);
				}
				 
			 }
		 }
		 return;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// UPDATE Gird3
	public void updateDetailGRID3(List<Map> paramList, LoginVO user, String allDivYn) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List<Map>) super.commonDao.list("s_bpr560ukrv_mitService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));

//					if b910  Y 면  해당 데이터로 div_code 조건 빼고 update
				 if(allDivYn.equals("Y")){
					 super.commonDao.delete("s_bpr560ukrv_mitService.updateAllDiv2", param);
					
				}else{
					 super.commonDao.update("s_bpr560ukrv_mitService.updateDetailGRID3", param);
				}
			 }
		 }
		 return;
	}


	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )		// DELETE
	public void deleteDetail(List<Map> paramList,  LoginVO user, String allDivYn) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("s_bpr560ukrv_mitService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));
//					if b910  Y 면  해당 데이터로 div_code 조건 빼고 delete
				 if(allDivYn.equals("Y")){
					 super.commonDao.delete("s_bpr560ukrv_mitService.deleteAllDiv", param);
					
				}else{
					 super.commonDao.update("s_bpr560ukrv_mitService.deleteDetail", param);
				}
				 
			 }
		 }
		 return;
	}

	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )		// DELETE GRID2
	public void deleteDetailGRID2(List<Map> paramList,  LoginVO user, String allDivYn) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("s_bpr560ukrv_mitService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));

//					if b910  Y 면  해당 데이터로 div_code 조건 빼고 delete
				 if(allDivYn.equals("Y")){
					 super.commonDao.delete("s_bpr560ukrv_mitService.deleteAllDiv", param);
					
				}else{
					 super.commonDao.update("s_bpr560ukrv_mitService.deleteDetailGRID2", param);
				}
			 }
		 }
		 return;
	}

	@ExtDirectMethod( value = ExtDirectMethodType.STORE_MODIFY, group = "base" )		// DELETE GRID3
	public void deleteDetailGRID3(List<Map> paramList,  LoginVO user, String allDivYn) throws Exception {
		Map compCodeMap = new HashMap();
		compCodeMap.put("S_COMP_CODE", user.getCompCode());
		List<Map> chkList = (List) super.commonDao.list("s_bpr560ukrv_mitService.checkCompCode", compCodeMap);
		 for(Map param :paramList )	{
			 for(Map checkCompCode : chkList) {
				 param.put("COMP_CODE", checkCompCode.get("COMP_CODE"));

//					if b910  Y 면  해당 데이터로 div_code 조건 빼고 delete
				 if(allDivYn.equals("Y")){
					 super.commonDao.delete("s_bpr560ukrv_mitService.deleteAllDiv2", param);
					
				}else{
					 super.commonDao.update("s_bpr560ukrv_mitService.deleteDetailGRID3", param);
				}
			 }
		 }
		 return;
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "base")		// INSERT
	public void voidmakeProdItems(Map param, LoginVO user) throws Exception {

		Map paramMap = new HashMap();
		paramMap.put("S_COMP_CODE", user.getCompCode());
		
		Map checkAllDiv = (Map) super.commonDao.select("s_bpr560ukrv_mitService.checkAllDiv", paramMap);
	 
		String allDivYn = "N";
		
		if(ObjUtils.isNotEmpty(checkAllDiv)){
			allDivYn = ObjUtils.getSafeString(checkAllDiv.get("SUB_CODE"));
		}
		
		List<Map> allDivList = null;
		allDivList =  super.commonDao.list("s_bpr560ukrv_mitService.selectDivList", paramMap);
		
//		if b910 Y 면   전사업장 insert 
		if(allDivYn.equals("Y")){
			if(allDivList != null){
				for(Map addParams : allDivList){
					param.put("DIV_CODE", addParams.get("DIV_CODE"));
					super.commonDao.update("s_bpr560ukrv_mitService.makeProdItems", param);
				}
			}
			
		}else{
			super.commonDao.update("s_bpr560ukrv_mitService.makeProdItems", param);
			
		}
		 return;
	}

	/**
	 * BOM정보 엑셀업로드(대체품)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("s_bpr560ukrv_mitService.getData", param);

		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData ) {
				param.put("ROWNUM"		, data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE"	, data.get("COMP_CODE"));
				param.put("ITEM_CODE"	, data.get("EXCHG_ITEM_CODE"));

				//업로드 된 데이터의 품목코드 미등록여부 확인
				String itemExistYn = (String) super.commonDao.select("s_bpr560ukrv_mitService.checkItem", param);
				if (itemExistYn.equals("Y")) {
					param.put("MSG", "품목코드 [" + data.get("EXCHG_ITEM_CODE") +"]를 먼저 등록한 후 업로드 해 주세요.");
					super.commonDao.update("s_bpr560ukrv_mitService.insertErrorMsg", param);
				}
			}
		}
	}

	@ExtDirectMethod(group = "bpr", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet(Map param) throws Exception {
		return super.commonDao.list("s_bpr560ukrv_mitService.selectExcelUploadSheet", param);
	}

	@ExtDirectMethod(group = "bpr", value = ExtDirectMethodType.STORE_MODIFY)
	public Object changeItemData(Map param, LoginVO user) throws Exception {
		super.commonDao.update("s_bpr560ukrv_mitService.changeItemData", param);
		String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
		if(!ObjUtils.isEmpty(errorDesc)) {
			throw new  UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		return param;
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "bpr")
	public Object insertS_BPR510T_MIT(Map param, LoginVO user) throws Exception {
		/* 데이터 insert */
		try {
			super.commonDao.insert("s_bpr560ukrv_mitService.insertS_BPR510T_MIT", param);
		}catch(Exception e){
			throw new UniDirectValidateException(this.getMessage("8114", user));
		}
		return true;
	}
}