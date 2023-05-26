package foren.unilite.modules.z_wm;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.prodt.pmp.Pmp160ukrvModel;


@Service("s_pmr100ukrv_wmService")
@SuppressWarnings({"rawtypes", "unchecked"})

public class S_Pmr100ukrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 마감여부체크 관련
	public Object checkWorkEnd(Map param) throws Exception {
		return super.commonDao.select("s_pmr100ukrv_wmServiceImpl.checkWorkEnd", param);
	}
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 작업지시조회
	public List<Map<String, Object>> selectDetailList(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectDetailList", param);
	}
	// END OF 작업실적등록

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 작업지시번호별등록 조회
	public List<Map<String, Object>> selectDetailList2(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectDetailList2", param);
	}
	// END OF 작업지시번호별등록 조회
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 공정별등록 조회1
	public List<Map<String, Object>> selectDetailList3(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectDetailList3", param);
	}
	// END OF 공정별등록 조회1

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 공정별등록 조회2
	public List<Map<String, Object>> selectDetailList4(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectDetailList4", param);
	}
	// END OF 공정별등록2

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 불량내역등록 조회
	public List<Map<String, Object>> selectDetailList5(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectDetailList5", param);
	}
	// END OF 불량내역등록

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 특이사항등록 조회
	public List<Map<String, Object>> selectDetailList6(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectDetailList6", param);
	}
	// END OF 특이사항등록

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 제조이력등록 조회
	public List<Map<String, Object>> selectDetailList7(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectDetailList7", param);
	}
	// END OF 제조이력등록(제조이력등록)

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 제조이력등록 조회
	public List<Map<String, Object>> selectDetailList8(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectDetailList8", param);
	}
	// END OF 제조이력등록(실적현황)

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)		// 자재불량내역조회
	public List<Map<String, Object>> selectDetailList10(Map param) throws Exception {
		List<Map<String, Object>> selectDetail10 = null;
		if(param.get("POPUP_CHK").equals("WKORD")){
			selectDetail10 = super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectDetailList10", param);//작업실적 등록 팝업에서 조회했을 경우
		}else{
			selectDetail10 = super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectDetailList10_2", param);//작업실적 수정 팝업에서 조회했을 경우
		}

		return selectDetail10;
	}
	
	/**
	 * 작업실적MES연동정보조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  selectIfSite(Map param) throws Exception {
		return  super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectIfSite", param);
	}
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectInterfaceFlag(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectInterfaceFlag", param);
	}		
	
	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectInterfaceInfo(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectInterfaceInfo", param);
	}	



	/**
	 * detail 저장(작지테이블 상태값 변경)
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_wm")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null) {
			List<Map> insertDetail = null;
			List<Map> updateDetail = null;
			List<Map> deleteDetail = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {
					insertDetail = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail")) {
					updateDetail = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail")) {
					deleteDetail = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateDetail != null) this.updateDetail(updateDetail, user, dataMaster);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	/**수정**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_pmr100ukrv_wmServiceImpl.updateDetail", param);
		}
		return 0;
	}


	/**
	* detail2 저장(작지번호별)
	*
	* @param param
	* @return
	* @throws Exception
	*/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		List<Map> dataList = new ArrayList<Map>();
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail2")) oprFlag="N";
			if(paramData.get("method").equals("updateDetail2")) oprFlag="U";
			if(paramData.get("method").equals("deleteDetail2")) oprFlag="D";

			for(Map param:	dataList) {
				Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
				Map<String, Object> spParam = new HashMap<String, Object>();
				SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
				Date dateGet = new Date ();
				String dateGetString = dateFormat.format(dateGet);

				String prodtNum = (String) dataMaster.get("PRODT_NUM");
				spParam.put("COMP_CODE", user.getCompCode());
				spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
				spParam.put("TABLE_ID","PMR100T");
				spParam.put("PREFIX", "P");
				spParam.put("BASIS_DATE", dateGetString);
				spParam.put("AUTO_TYPE", "1");

				param.put("PRODT_TYPE",	"2");	// (1: 공정별, 2: 작지별, 3: ......)
				param.put("STATUS",	oprFlag);
				param.put("USER_ID",	user.getUserID());

				if(param.get("STATUS").equals("N")) {
					//자동채번
					super.commonDao.queryForObject("s_pmr100ukrv_wmServiceImpl.spAutoNum", spParam);
					prodtNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
				
					param.put("PRODT_NUM",	prodtNum);
					super.commonDao.update("s_pmr100ukrv_wmServiceImpl.insertDetail2", param);

					super.commonDao.update("s_pmr100ukrv_wmServiceImpl.updateMoldShot", param);
				} else if(param.get("STATUS").equals("U")) {
					super.commonDao.update("s_pmr100ukrv_wmServiceImpl.updateDetail2", param);
				}else if(param.get("STATUS").equals("D")) {
					super.commonDao.update("s_pmr100ukrv_wmServiceImpl.deleteDetail2", param);
					
					super.commonDao.update("s_pmr100ukrv_wmServiceImpl.updateMoldShot", param);
				}
				
				param.put("COMP_CODE", user.getCompCode());
				param.put("DIV_CODE", param.get("DIV_CODE"));
				param.put("PRODT_NUM", param.get("PRODT_NUM"));
				param.put("WKORD_NUM", param.get("WKORD_NUM"));

				param.put("GOOD_WH_CODE", param.get("GOOD_WH_CODE"));
				param.put("GOOD_WH_CELL_CODE", param.get("GOOD_WH_CELL_CODE"));
				param.put("GOOD_PRSN", param.get("GOOD_PRSN"));
				param.put("GOOD_Q", ObjUtils.parseDouble(param.get("GOOD_PRODT_Q")));


				param.put("BAD_WH_CODE", param.get("BAD_WH_CODE"));
				param.put("BAD_WH_CELL_CODE", param.get("BAD_WH_CELL_CODE"));
				param.put("BAD_PRSN", param.get("BAD_PRSN"));
				param.put("BAD_Q", ObjUtils.parseDouble(param.get("BAD_PRODT_Q")));
				param.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));


				super.commonDao.update("s_pmr100ukrv_wmServiceImpl.spReceiving", param);
				String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
				if(!ObjUtils.isEmpty(errorDesc)) {
//						String[] messsage = errorDesc.split(";");
					throw new	UniDirectValidateException(this.getMessage(errorDesc, user));
				}

				dataMaster.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
 
			}
		}

		paramList.add(0, paramMaster);
		return	paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")			// INSERT
	public Integer insertDetail2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {

		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")			// UPDATE
	public Integer updateDetail2(List<Map> paramList, LoginVO user) throws Exception {

		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)						// DELETE
	public Integer deleteDetail2(List<Map> paramList,	LoginVO user) throws Exception {
		return 0;
	}



	/**
	 * detail3 저장(공정별)
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll3(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);
		
		

		List<Map> dataList = new ArrayList<Map>();
		for(Map paramData: paramList) {	
		      
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail3")) oprFlag="N";
			if(paramData.get("method").equals("updateDetail3")) oprFlag="N";
			if(paramData.get("method").equals("deleteDetail3")) oprFlag="D";

			for(Map param:	dataList) {

				Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
				Map<String, Object> spParam = new HashMap<String, Object>();
				SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
				Date dateGet = new Date ();
				String dateGetString = dateFormat.format(dateGet);

				String prodtNum = (String) dataMaster.get("PRODT_NUM");
				spParam.put("COMP_CODE", user.getCompCode());
				spParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
				spParam.put("TABLE_ID","PMR100T");
				spParam.put("PREFIX", "P");
				spParam.put("BASIS_DATE", dateGetString);
				spParam.put("AUTO_TYPE", "1");

				param.put("PRODT_TYPE",	"1");		// (1: 공정별, 2: 작지별, 3: ......)
				param.put("STATUS",	oprFlag);
				param.put("USER_ID",	user.getUserID());


				if(param.get("STATUS").equals("N")) {
					//자동채번
					super.commonDao.queryForObject("s_pmr100ukrv_wmServiceImpl.spAutoNum", spParam);
					prodtNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
					param.put("PRODT_NUM",	prodtNum);
					super.commonDao.update("s_pmr100ukrv_wmServiceImpl.insertDetail3", param);

					//금형테이블에 사용SHOT update관련
					if(ObjUtils.isNotEmpty(param.get("MOLD_CODE")) && ObjUtils.parseInt(param.get("CAVIT_BASE_Q")) > 0 ){

						param.put("PASS_Q",	ObjUtils.parseDouble(param.get("PASS_Q")));
						param.put("CAVIT_BASE_Q",	ObjUtils.parseDouble(param.get("CAVIT_BASE_Q")));
						super.commonDao.update("s_pmr100ukrv_wmServiceImpl.updateMoldPlus", param);

					}

				} else if(param.get("STATUS").equals("U")) {
					super.commonDao.update("s_pmr100ukrv_wmServiceImpl.updateDetail3", param);

				}

				param.put("COMP_CODE", user.getCompCode());
				param.put("DIV_CODE", param.get("DIV_CODE"));
				param.put("PRODT_NUM", param.get("PRODT_NUM"));
				param.put("WKORD_NUM", param.get("WKORD_NUM"));
				param.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
				param.put("USER_ID", user.getUserID());

				param.put("GOOD_Q", ObjUtils.parseDouble(param.get("GOOD_WORK_Q")));
				param.put("BAD_Q", ObjUtils.parseDouble(param.get("BAD_WORK_Q")));

				super.commonDao.update("s_pmr100ukrv_wmServiceImpl.spReceiving", param);
				String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
				if(!ObjUtils.isEmpty(errorDesc)) {
					throw new	UniDirectValidateException(this.getMessage(errorDesc, user));
				}

				dataMaster.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
				dataMaster.put("PRODT_NUM", prodtNum);
			}
		}

		paramList.add(0, paramMaster);
		return	paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")			// INSERT
	public Integer insertDetail3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")			// UPDATE
	public Integer updateDetail3(List<Map> paramList, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)						// DELETE
	public Integer deleteDetail3(List<Map> paramList,	LoginVO user) throws Exception {
		return 0;
	}



	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll4(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");


		List<Map> dataList = new ArrayList<Map>();
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail4")) oprFlag="N";
			if(paramData.get("method").equals("updateDetail4")) oprFlag="U";
			if(paramData.get("method").equals("deleteDetail4")) oprFlag="D";

			for(Map param:	dataList) {
			//금형테이블에 사용SHOT update관련
				if(ObjUtils.isNotEmpty(dataMaster.get("MOLD_CODE")) && ObjUtils.parseInt(dataMaster.get("CAVIT_BASE_Q")) > 0 ){

					param.put("PASS_Q",	ObjUtils.parseDouble(param.get("PASS_Q")));
					param.put("CAVIT_BASE_Q",	ObjUtils.parseDouble(dataMaster.get("CAVIT_BASE_Q")));
					param.put("MOLD_CODE", dataMaster.get("MOLD_CODE"));
					super.commonDao.update("s_pmr100ukrv_wmServiceImpl.updateMoldMinus", param);

				}

				super.commonDao.update("s_pmr100ukrv_wmServiceImpl.deleteDetail3", param);

				param.put("COMP_CODE"		, user.getCompCode());
				param.put("DIV_CODE"			, param.get("DIV_CODE"));
				param.put("PRODT_NUM"		, param.get("PRODT_NUM"));
				param.put("WKORD_NUM"		, param.get("WKORD_NUM"));
				param.put("CONTROL_STATUS"	, param.get("CONTROL_STATUS"));
				param.put("PRODT_TYPE"		, "1");
				param.put("STATUS"			, oprFlag);
				param.put("USER_ID"			, user.getUserID());
				param.put("GOOD_Q"			, ObjUtils.parseDouble(param.get("GOOD_WORK_Q")));
				param.put("BAD_Q"			, ObjUtils.parseDouble(param.get("BAD_WORK_Q")));

				super.commonDao.update("s_pmr100ukrv_wmServiceImpl.spReceiving", param);
				String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
				if(!ObjUtils.isEmpty(errorDesc)) {
					String[] messsage = errorDesc.split(";");
					throw new	UniDirectValidateException(this.getMessage(messsage[0], user));
				}
				dataMaster.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
			}
		}

		paramList.add(0, paramMaster);
		return	paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")			// INSERT
	public Integer insertDetail4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")			// UPDATE
	public Integer updateDetail4(List<Map> paramList, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)						// DELETE
	public Integer deleteDetail4(List<Map> paramList,	LoginVO user) throws Exception {
		return 0;
	}



	/**
	*	detail5 저장 (불량)
	*
	* @param param
	* @return
	* @throws Exception
	*/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll5(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
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

		return	paramList;
 }

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")	// INSERT
	public Integer	insertDetail5(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("s_pmr100ukrv_wmServiceImpl.insertDetail5", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// UPDATE
	public Integer updateDetail5(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_pmr100ukrv_wmServiceImpl.updateDetail5", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail5(List<Map> paramList,	LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_pmr100ukrv_wmServiceImpl.deleteDetail5", param);
		}
		return 0;
	}



	/**
	* detail6 저장 (특이)
	* @param param
	* @return
	* @throws Exception
	*/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll6(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null) {
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

		return	paramList;
 }

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")	// INSERT
	public Integer	insertDetail6(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("s_pmr100ukrv_wmServiceImpl.insertDetail6", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// UPDATE
	public Integer updateDetail6(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_pmr100ukrv_wmServiceImpl.updateDetail6", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail6(List<Map> paramList,	LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_pmr100ukrv_wmServiceImpl.deleteDetail6", param);
		}
		return 0;
	}



	/**
	* detail7 저장 (제조이력등록)
	* @param param
	* @return
	* @throws Exception
	*/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll7(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null) {
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
			//20190509 insertList는 로직상 존재하지 않으나 무조건 updateDetail7를 실행하여 updateDetail7에서 MERGE INTO
			if(insertList != null) this.updateDetail7(insertList, user);
			if(updateList != null) this.updateDetail7(updateList, user);
		}
		paramList.add(0, paramMaster);

		return	paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")	// INSERT
	public Integer	insertDetail7(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("s_pmr100ukrv_wmServiceImpl.insertDetail7", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")		// UPDATE
	public Integer updateDetail7(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_pmr100ukrv_wmServiceImpl.updateDetail7", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail7(List<Map> paramList,	LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_pmr100ukrv_wmServiceImpl.deleteDetail7", param);
		}
		return 0;
	}



	/**
	 * 시험검사성적서_메인리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> mainReport(Map param) throws Exception {
		return  super.commonDao.list("s_pmr100ukrv_wmServiceImpl.mainReport", param);
	}

	/**
	 * 시험검사성적서_서브리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> subReport(Map param) throws Exception {
		return  super.commonDao.list("s_pmr100ukrv_wmServiceImpl.subReport", param);
	}

	/**
	 * 시험검사성적서_서브리포트(화성)
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> subReport2(Map param) throws Exception {
		return  super.commonDao.list("s_pmr100ukrv_wmServiceImpl.subReport2", param);
	}

	/**
	 * 벌크품목조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> selectRefItem(Map param) throws Exception {
		return  super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectRefItem", param);
	}

	/**
	 * 시험검사성적서_메인리포트_라벨
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> mainReport_label(Map param) throws Exception {
		return  super.commonDao.list("s_pmr100ukrv_wmServiceImpl.mainReport_label", param);
	}



	/**
	 * 자재불량유형 코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectBadcodes(String comp_code) throws Exception {
		return (List)super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectBadcodes" ,comp_code);
	}

	public List selectBadcodeRemarks(String comp_code) throws Exception {
		return (List)super.commonDao.list("s_pmr100ukrv_wmServiceImpl.selectBadcodeRemarks" ,comp_code);
	}	



	/**
	 * 자재불량유형 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "prodt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll10(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		List<Map> dataList = new ArrayList<Map>();

		ArrayList badList = new ArrayList();
		ArrayList badRemarkList = new ArrayList();
		badList = (ArrayList) dataMaster.get("badQtyArray");
		badRemarkList = (ArrayList) dataMaster.get("badRemarkArray");

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			String badColName ;
			String badRemarkColName;
			String saveFlag =  "N";
			if(paramData.get("method").equals("insertDetail10")) oprFlag="N";
			if(paramData.get("method").equals("updateDetail10")) oprFlag="U";
			if(paramData.get("method").equals("deleteDetail10")) oprFlag="D";
			if(oprFlag.equals("U") || oprFlag.equals("N")){
				for(Map param:	dataList) {
					param.put("COMP_CODE"		, user.getCompCode());
					param.put("DIV_CODE"			, param.get("DIV_CODE"));
					param.put("PRODT_NUM"		, dataMaster.get("PRODT_NUM"));
					param.put("PRODT_DATE"		, dataMaster.get("PRODT_DATE"));
					param.put("WKORD_NUM"		, param.get("WKORD_NUM"));
					param.put("STATUS"			, oprFlag);
					param.put("USER_ID"			, user.getUserID());

					super.commonDao.update("s_pmr100ukrv_wmServiceImpl.deleteDetail10", param);
					for (int i=0; i<badList.size(); i++) {
					    badColName = "BAD_" +  badList.get(i);
					    Double badQ = 0.0;
					    if(ObjUtils.isNotEmpty(param.get(badColName))){
					    	badQ = ObjUtils.parseDouble(param.get(badColName));
					    }
				    	param.put("BAD_Q", badQ);
					    param.put("BAD_CODE", badList.get(i));
					    
					    for (int j=0; j<badRemarkList.size(); j++) {
					    	badRemarkColName = "REMARK_" +  badRemarkList.get(j);				    	
					    	if(badList.get(i).equals(badRemarkList.get(j))){	
					    		param.put("REMARK", param.get(badRemarkColName));
					    	}
					    }
					    
						if( badQ > 0){
					    	super.commonDao.update("s_pmr100ukrv_wmServiceImpl.updateDetail10", param);
					    }
					}
				}
			}/*else{
				for(Map param:	dataList) {
					param.put("COMP_CODE"		, user.getCompCode());
					param.put("DIV_CODE"			, param.get("DIV_CODE"));
					param.put("PRODT_NUM"		, dataMaster.get("PRODT_NUM"));
					param.put("PRODT_DATE"		, dataMaster.get("PRODT_DATE"));
					param.put("WKORD_NUM"		, param.get("WKORD_NUM"));
					param.put("STATUS"			, oprFlag);
					param.put("USER_ID"			, user.getUserID());

					for (int i=0; i<badList.size(); i++) {
					    badColName = "BAD_" +  badList.get(i);
					    param.put("BAD_Q", param.get(badColName));

					    param.put("BAD_CODE", badList.get(i));
					    if( (int) param.get(badColName) > 0){
					    	super.commonDao.update("s_pmr100ukrv_wmServiceImpl.deleteDetail10", param);
					    }
					}
				}
			}*/

		}

		paramList.add(0, paramMaster);
		return	paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")			// INSERT
	public Integer insertDetail10(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "prodt")			// UPDATE
	public Integer updateDetail10(List<Map> paramList, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "base", needsModificatinAuth = true)						// DELETE
	public Integer deleteDetail10(List<Map> paramList,	LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "prodt", value = ExtDirectMethodType.STORE_MODIFY)
	public void updateProductionResultRemark(Map param, LoginVO login) throws Exception {
			logger.debug("param:::"+param);
				 super.commonDao.update("s_pmr100ukrv_wmServiceImpl.updateProductionResultRemark", param);
	}



	/**
	 * 작업지시품목의 후공정 가져오는 쿼리
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport_label_afterProg(Map param) throws Exception {
		return  super.commonDao.list("s_pmr100ukrv_wmServiceImpl.mainReport_label_afterProg", param);
	}



	/**
	 * 20210118 추가: 작업지시번호 바코드 스캔 시, 작지 상태값 변경 - 진행/작업중/대기 -> 마감('8'), PMP100T.WKORD_STATUS = '8' / WORD_END_YN = 'Y'       /       마감('8') -> 진행('2'), PMP100T.WKORD_STATUS = '2' / WORD_END_YN = 'N'
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateWkordStatus(Map param, LoginVO user) throws Exception {
		super.commonDao.update("s_pmr100ukrv_wmServiceImpl.updateWkordStatus", param);
		return 0;
	}



	/**
	 * 작업지시_라벨
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport_Pmplabel(Map param) throws Exception {
		return  super.commonDao.list("s_pmr100ukrv_wmServiceImpl.mainReport_Pmplabel", param);
	}
}