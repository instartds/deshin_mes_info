package foren.unilite.modules.z_yp;

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


@Service("s_spp100ukrv_ypService")
@SuppressWarnings({"rawtypes", "unchecked"})

public class S_spp100ukrv_ypServiceImpl  extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	
	/** 페이지 오픈 시, 영업담당 정보 가져오는 로직 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public Object getSalePrsn(Map param, LoginVO user) throws Exception {
		return super.commonDao.select("s_spp100ukrv_ypServiceImpl.getSalePrsn", param);
	}	
	
	/**
	 * 견적현황 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */ 
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> selectList(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_spp100ukrv_ypServiceImpl.selectList", param);
	}
	
	/**
	 * 검색POPUP
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */ 
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		
		return  super.commonDao.list("s_spp100ukrv_ypServiceImpl.selectList2", param);
	}
	
	
	
	/**
	 * 주문상품명 입력 시, 매핑된 품목정보 확인
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */ 
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map> getItemInfo(Map param, LoginVO user) throws Exception {
		return super.commonDao.list("s_spp100ukrv_ypServiceImpl.getItemInfo", param);
	}
	
	
	
	/**
	 * 견적 마스터 정보 저장
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveMaster(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
//			List<Map> deleteList = null;
		
			for(Map dataListMap: paramList) {
				/* 전체삭제버튼 구현 시, 주석 해제
				if(dataListMap.get("method").equals("deleteMaster")) {
					deleteList = (List<Map>)dataListMap.get("data");
				
				} else */if(dataListMap.get("method").equals("insertMaster")) {		
					insertList = (List<Map>)dataListMap.get("data");}
				
				else if(dataListMap.get("method").equals("updateMaster")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
//			if(deleteList != null) this.deleteMaster(deleteList, user, dataMaster);
			if(insertList != null) this.insertMaster(insertList, user, dataMaster);
			if(updateList != null) this.updateMaster(updateList, user, dataMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	
	/**
	 * 견적 마스터 정보 등록 (insert)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public List<Map> insertMaster(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		String errMsg = "";		
		try {
			for(Map param :paramList )	{
				param.put("DIV_CODE"	, paramMaster.get("DIV_CODE"));
				param.put("CUSTOM_CODE"	, paramMaster.get("CUSTOM_CODE"));
				param.put("CUSTOM_NAME"	, paramMaster.get("CUSTOM_NAME"));
				param.put("ESTI_DATE"	, paramMaster.get("ESTI_DATE"));
				param.put("ESTI_TITLE"	, paramMaster.get("ESTI_TITLE"));
				param.put("ESTI_PRSN"	, paramMaster.get("ESTI_PRSN"));
				param.put("FR_DATE"		, paramMaster.get("FR_DATE"));
				param.put("TO_DATE"		, paramMaster.get("TO_DATE"));
				param.put("STATUS"		, paramMaster.get("STATUS"));
				param.put("REMARK"		, paramMaster.get("REMARK"));
				param.put("CONFIRM_DATE", paramMaster.get("CONFIRM_DATE"));
				param.put("MONEY_UNIT"	, paramMaster.get("MONEY_UNIT"));
				if ("Y".equals(paramMaster.get("AUTO_NO_YN"))) {
					Map<String, Object> autoNum	= (Map<String, Object>)super.commonDao.select("s_spp100ukrv_ypServiceImpl.autoNum", param);
					String OrderNum				= ObjUtils.getSafeString(autoNum.get("ORDER_NUM"));
					param.put("ESTI_NUM"		, OrderNum);
					paramMaster.put("ESTI_NUM"	, OrderNum);
				}
				super.commonDao.insert("s_spp100ukrv_ypServiceImpl.insertMaster", param);
			}
			 
		} catch(Exception e){
			throw new  UniDirectValidateException("저장 중 오류가 발생했습니다. \n" + errMsg);
		}
		paramList.add(0, paramMaster);
		
		return paramList;
	}
	
	/**
	 * 견적 마스터 정보 수정 (update)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateMaster(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList )	{	
			 super.commonDao.update("s_spp100ukrv_ypServiceImpl.updateMaster", param);
		 }
		 return 0;
	} 

	
	/**
	 * 견적 마스터 정보 삭제 (delete) - detailStore에서 진행(detail 정보가 없으면 master 삭제)
	 */
/*	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteMaster(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {		
			try {
				super.commonDao.delete("s_spp100ukrv_ypServiceImpl.deleteMaster", param);
				 
			}catch(Exception e)	{
					throw new  UniDirectValidateException(this.getMessage("547",user));
			}	
		return 0;
	}*/
	
	
	
	
	
	/**
	 * 견적 디테일 정보 저장
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
		
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList")) {
					deleteList = (List<Map>)dataListMap.get("data");
				
				} else if(dataListMap.get("method").equals("insertList")) {		
					insertList = (List<Map>)dataListMap.get("data");}
				
				else if(dataListMap.get("method").equals("updateList")) {
					updateList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteList(deleteList, user, dataMaster);
			if(insertList != null) this.insertList(insertList, user, dataMaster);
			if(updateList != null) this.updateList(updateList, user, dataMaster);				
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	
	/**
	 * 견적 디테일 정보 등록 (insert)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public List<Map> insertList(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		String errMsg = "";		
		try {
			for(Map param :paramList )	{
				param.put("DIV_CODE"	, paramMaster.get("DIV_CODE"));
				param.put("ESTI_NUM"	, paramMaster.get("ESTI_NUM"));
				param.put("CUSTOM_CODE"	, paramMaster.get("CUSTOM_CODE"));
				param.put("CUSTOM_NAME"	, paramMaster.get("CUSTOM_NAME"));
				param.put("ESTI_DATE"	, paramMaster.get("ESTI_DATE"));
				param.put("ESTI_TITLE"	, paramMaster.get("ESTI_TITLE"));
				param.put("ESTI_PRSN"	, paramMaster.get("ESTI_PRSN"));
				param.put("FR_DATE"		, paramMaster.get("FR_DATE"));
				param.put("TO_DATE"		, paramMaster.get("TO_DATE"));
				param.put("STATUS"		, paramMaster.get("STATUS"));
				param.put("REMARK"		, paramMaster.get("REMARK"));
				param.put("CONFIRM_DATE", paramMaster.get("CONFIRM_DATE"));
				param.put("MONEY_UNIT"	, paramMaster.get("MONEY_UNIT"));
				super.commonDao.insert("s_spp100ukrv_ypServiceImpl.insertList", param);
			}
			 
		} catch(Exception e){
			throw new  UniDirectValidateException("저장 중 오류가 발생했습니다. \n" + errMsg);
		}
		return paramList;
	}

	
	/**
	 * 견적 디테일 정보 수정 (update)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer updateList(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		 for(Map param :paramList )	{	
			 super.commonDao.update("s_spp100ukrv_ypServiceImpl.updateList", param);
		 }
		 return 0;
	} 

	
	/**
	 * 견적 디테일 정보 삭제 (delete)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	public Integer deleteList(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {		
		for(Map param :paramList )	{
			try {
				super.commonDao.delete("s_spp100ukrv_ypServiceImpl.deleteList", param);
				 
			}catch(Exception e)	{
					throw new  UniDirectValidateException(this.getMessage("547",user));
			}	
		}
		return 0;
	}

	
	
	
	
	
	
	/**
	 * 견적확정/진행 버튼 로직 (SP 호출)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
	public List<Map> callProcedure(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)   {
			List<Map> insertList = null;

			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("runProcedure")) {
					insertList = (List<Map>)dataListMap.get("data");
				}
			}		   
			if(insertList != null) this.runProcedure(insertList, paramMaster, user);
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "sales")
	private void runProcedure( List<Map> paramList, Map paramMaster, LoginVO user ) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>)paramMaster.get("data");

		//SP에서 작성한 변수에 맞추기
		//SP 호출시 넘길 MAP 정의
		Map<String, Object> spParam = new HashMap<String, Object>();
		//견적번호
		String estiNum		= (String)dataMaster.get("ESTI_NUM");
		//작업 구분 (C:견적확정, D:견적진행)
		String oprFlag		= (String)dataMaster.get("OPR_FLAG");
		//확정일자
		String confirmDate	= (String)dataMaster.get("CONFIRM_DATE");
		//단가적용기간
		String frDate		= (String)dataMaster.get("FR_DATE");
		String toDate		= (String)dataMaster.get("TO_DATE");
		//language type
		String langType		= (String)dataMaster.get("LANG_TYPE");
		//에러메세지 처리
		String errorDesc	= "";

		//OPR_FLAG 값에 따라 다른 SP 호출로직 구현
		spParam.put("COMP_CODE"		, user.getCompCode());
		spParam.put("ESTI_NUM"		, estiNum);
		spParam.put("OPR_FLAG"		, oprFlag);
		spParam.put("CONFIRM_DATE"	, confirmDate);
		spParam.put("FR_DATE"		, frDate);
		spParam.put("TO_DATE"		, toDate);
		spParam.put("LANG_TYPE"		, langType);
		spParam.put("LOGIN_ID"		, user.getUserID());
		spParam.put("ERROR_DESC"	, "");
		
		super.commonDao.queryForObject("s_spp100ukrv_ypServiceImpl.confirmEstimate", spParam);
		
		errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		if (!ObjUtils.isEmpty(errorDesc)) {
			throw new UniDirectValidateException(this.getMessage(errorDesc, user));
		}
		return;
	}


	
	
	
	
	
	
	/**
	 * 견적정보 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("s_spp100ukrv_ypServiceImpl.getData", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
//			for(Map data : getData )  { 
//				param.put("ROWNUM"		, data.get("_EXCEL_ROWNUM"));
//				param.put("COMP_CODE"	, data.get("COMP_CODE"));
//				param.put("ITEM_CODE"	, data.get("ITEM_CODE"));
//				param.put("CUSTOM_CODE"	, data.get("CUSTOM_CODE"));
//
//				//업로드 된 데이터의 품목코드 기등록여부 확인
//				String itemExistYn =  (String) super.commonDao.select("s_spp100ukrv_ypServiceImpl.checkItem", param);
//				if (itemExistYn.equals("N")) {					
//					param.put("MSG", "품목코드 [" + data.get("ITEM_CODE") +"]를 먼저 등록한 후 업로드 해 주세요.");
//					super.commonDao.update("s_spp100ukrv_ypServiceImpl.insertErrorMsg", param);
//				}
//				//업로드 된 데이터의 거래처 기등록여부 확인
//				String custExistYn =  (String) super.commonDao.select("s_spp100ukrv_ypServiceImpl.checkCust", param);
//				if (custExistYn.equals("N")) {					
//					param.put("MSG", "거래처코드 [" + data.get("CUSTOM_CODE") +"]를 먼저 등록한 후 업로드 해 주세요.");
//					super.commonDao.update("s_spp100ukrv_ypServiceImpl.insertErrorMsg", param);
//				}
//			}
		} 
	}
	
	@ExtDirectMethod(group = "sbs", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		return super.commonDao.list("s_spp100ukrv_ypServiceImpl.selectExcelUploadSheet1", param);
	}
	
	
	
	/**
	 * 품목코드 입력 시, 주문상품명 가져오는 로직
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_READ)
	public Object getCustomItemCode(Map param) throws Exception {
		return super.commonDao.select("s_spp100ukrv_ypServiceImpl.getCustomItemCode", param);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/** ITEM_CODE, ITEM_NAME 선택 시, 판매단가 가져오는 로직 (현재 사용 안 함 - 다른 로직으로 대체,20171211)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public String getSalesP(Map param, LoginVO user) throws Exception {
		return (String) super.commonDao.select("s_spp100ukrv_ypServiceImpl.getSalesP", param);
	}	

}
