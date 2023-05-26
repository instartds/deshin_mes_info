package foren.unilite.modules.z_mit;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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


@Service("s_pmr100ukrv_mitService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class S_pmr100ukrv_mitServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());	

	/**
	 * 자재불량유형 코드 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectBadcodes(String comp_code) throws Exception {
		return (List)super.commonDao.list("s_pmr100ukrv_mitServiceImpl.selectBadcodes" ,comp_code);
	}
	
	
	
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_READ)		// 마감여부체크 관련
	public Object checkWorkEnd(Map param) throws Exception {
		return super.commonDao.select("s_pmr100ukrv_mitServiceImpl.checkWorkEnd", param);
	}
	/**
	 * 생산실적 메인그리드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map> selectList(Map param) throws Exception{
		return super.commonDao.list("s_pmr100ukrv_mitServiceImpl.selectList", param);
	}
	
	/**
	 * 특기사항등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectListTab2(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_mitServiceImpl.selectListTab2", param);
	}
	
	/**
	 * 생산불량내역
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_READ)		
	public List<Map<String, Object>> selectDetailList5(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_mitServiceImpl.selectDetailList5", param);
	}
	/**
	 * 생산현황탭 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_mit", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectDetailList4(Map param) throws Exception {
		return super.commonDao.list("s_pmr100ukrv_mitServiceImpl.selectDetailList4", param);
	}

	/**
	*	메인 생산실적등록
	*
	* @param param
	* @return
	* @throws Exception
	*/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);

		List<Map> dataList = new ArrayList<Map>();
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail")) oprFlag="N";
			if(paramData.get("method").equals("updateDetail")) oprFlag="N";
			if(paramData.get("method").equals("deleteDetail")) oprFlag="D";

			for(Map param:	dataList) {

				Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
				Map<String, Object> spParam = new HashMap<String, Object>();
				SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
				Date dateGet = new Date ();
				String dateGetString = dateFormat.format(dateGet);

				String z_mitNum = (String) dataMaster.get("PRODT_NUM");
				spParam.put("COMP_CODE", user.getCompCode());
				spParam.put("DIV_CODE", param.get("DIV_CODE"));
				spParam.put("TABLE_ID","PMR100T");
				spParam.put("PREFIX", "P");
				spParam.put("BASIS_DATE", dateGetString);
				spParam.put("AUTO_TYPE", "1");

				param.put("PRODT_TYPE",	"1");		// (1: 공정별, 2: 작지별, 3: ......)
				param.put("STATUS",	oprFlag);
				param.put("USER_ID",	user.getUserID());

				if(param.get("STATUS").equals("N")) {
					//자동채번
					super.commonDao.queryForObject("s_pmr100ukrv_mitServiceImpl.spAutoNum", spParam);
					z_mitNum = ObjUtils.getSafeString(spParam.get("KEY_NUMBER"));
					param.put("PRODT_NUM",	z_mitNum);
					super.commonDao.update("s_pmr100ukrv_mitServiceImpl.insertDetail", param);

					//금형테이블에 사용SHOT update관련
					if(ObjUtils.isNotEmpty(param.get("MOLD_CODE")) && ObjUtils.parseInt(param.get("CAVIT_BASE_Q")) > 0 ){

						param.put("PASS_Q",	ObjUtils.parseDouble(param.get("PASS_Q")));
						param.put("CAVIT_BASE_Q",	ObjUtils.parseDouble(param.get("CAVIT_BASE_Q")));
						super.commonDao.update("s_pmr100ukrv_mitServiceImpl.updateMoldPlus", param);

					}


				} else if(param.get("STATUS").equals("N") && param.get("FLAG").equals("U")) {
					super.commonDao.update("s_pmr100ukrv_mitServiceImpl.updateDetail", param);
				}

				param.put("COMP_CODE", user.getCompCode());
				param.put("DIV_CODE", param.get("DIV_CODE"));
				param.put("PRODT_NUM", param.get("PRODT_NUM"));
				param.put("WKORD_NUM", param.get("WKORD_NUM"));
				param.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
//					param.put("STATUS", param.get("FLAG"));
				param.put("USER_ID", user.getUserID());
		/*		if(param.get("LINE_END_YN").equals("Y")) {
					param.put("GOOD_Q", param.get("GOOD_WORK_Q"));
					param.put("GOOD_WH_CODE", param.get("GOOD_WH_CODE"));
					param.put("GOOD_PRSN", param.get("GOOD_PRSN"));
					param.put("GOOD_WH_CELL_CODE", param.get("GOOD_WH_CELL_CODE"));
					param.put("BAD_Q", param.get("BAD_WORK_Q"));
					param.put("BAD_WH_CODE", param.get("BAD_WH_CODE"));
					param.put("BAD_PRSN", param.get("BAD_PRSN"));
					param.put("BAD_WH_CELL_CODE", param.get("BAD_WH_CELL_CODE"));
				} else {
					param.put("GOOD_WH_CODE", "");
					param.put("GOOD_WH_CELL_CODE", "");
					param.put("GOOD_PRSN", "");
					param.put("GOOD_Q", zero);
					param.put("BAD_WH_CODE", "");
					param.put("BAD_WH_CELL_CODE", "");
					param.put("BAD_PRSN", "");
					param.put("BAD_Q", zero);
				}*/
				param.put("GOOD_Q", ObjUtils.parseDouble(param.get("GOOD_WORK_Q")));
				param.put("BAD_Q", ObjUtils.parseDouble(param.get("BAD_WORK_Q")));
				
				Map<String, Object> selectWhCode = null;
				
				selectWhCode = (Map<String, Object>) super.commonDao.select("s_pmr100ukrv_mitServiceImpl.selectWhCode", param);
			
				param.put("GOOD_WH_CODE", selectWhCode.get("GOOD_WH_CODE"));
				param.put("GOOD_WH_CELL_CODE", selectWhCode.get("GOOD_WH_CELL_CODE"));
				param.put("GOOD_PRSN", selectWhCode.get("GOOD_PRSN"));
				param.put("BAD_WH_CODE", selectWhCode.get("BAD_WH_CODE"));
				param.put("BAD_WH_CELL_CODE", selectWhCode.get("BAD_WH_CELL_CODE"));
				param.put("BAD_PRSN",selectWhCode.get("BAD_PRSN"));
				
				
				super.commonDao.update("s_pmr100ukrv_mitServiceImpl.spReceiving", param);
				String errorDesc = ObjUtils.getSafeString(param.get("ERROR_DESC"));
				if(!ObjUtils.isEmpty(errorDesc)) {
//						String[] messsage = errorDesc.split(";");
					throw new	UniDirectValidateException(this.getMessage(errorDesc, user));
				}
/*					//공정별 등록 그리드는 삭제로직 없음
					if(param.get("STATUS").equals("D")) {
						super.commonDao.update("s_pmr100ukrv_mitServiceImpl.deleteDetail3", param);
					}*/
				dataMaster.put("CONTROL_STATUS", param.get("CONTROL_STATUS"));
				dataMaster.put("PRODT_NUM", z_mitNum);
			}
		}

		paramList.add(0, paramMaster);
		return	paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public Integer insertDetail(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public Integer updateDetail(List<Map> paramList, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "z_mit", needsModificatinAuth = true)
	public Integer deleteDetail(List<Map> paramList,	LoginVO user) throws Exception {
		return 0;
	}
	
	
	
	/**
	* 생산불량내역등록
	*
	* @param param
	* @return
	* @throws Exception
	*/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll5(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {

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

		return	paramList;
 }

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")	// INSERT
	public Integer	insertDetail5(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("s_pmr100ukrv_mitServiceImpl.insertDetail5", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")		// UPDATE
	public Integer updateDetail5(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_pmr100ukrv_mitServiceImpl.updateDetail5", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "z_mit", needsModificatinAuth = true)		// DELETE
	public Integer deleteDetail5(List<Map> paramList,	LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_pmr100ukrv_mitServiceImpl.deleteDetail5", param);
		}
		return 0;
	}

	/**
	* 특기사항등록
	* @param param
	* @return
	* @throws Exception
	*/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAllTab2(List<Map> paramList,	Map paramMaster, LoginVO user) throws Exception {

		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteTab2")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertTab2")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateTab2")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteTab2(deleteList, user);
			if(insertList != null) this.insertTab2(insertList, user);
			if(updateList != null) this.updateTab2(updateList, user);
		}
		paramList.add(0, paramMaster);

		return	paramList;
 }

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")	// INSERT
	public Integer	insertTab2(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.update("s_pmr100ukrv_mitServiceImpl.insertTab2", param);
		}
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")		// UPDATE
	public Integer updateTab2(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_pmr100ukrv_mitServiceImpl.updateTab2", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "z_mit", needsModificatinAuth = true)		// DELETE
	public Integer deleteTab2(List<Map> paramList,	LoginVO user) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("s_pmr100ukrv_mitServiceImpl.deleteTab2", param);
		}
		return 0;
	}
	
	/**
	 * 생산현황탭 
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
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
					super.commonDao.update("s_pmr100ukrv_mitServiceImpl.updateMoldMinus", param);

				}

				super.commonDao.update("s_pmr100ukrv_mitServiceImpl.deleteDetail", param);

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

				super.commonDao.update("s_pmr100ukrv_mitServiceImpl.spReceiving", param);
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

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")			// INSERT
	public Integer insertDetail4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")			// UPDATE
	public Integer updateDetail4(List<Map> paramList, LoginVO user) throws Exception {
		return 0;
	}

	@ExtDirectMethod(group = "z_mit", needsModificatinAuth = true)						// DELETE
	public Integer deleteDetail4(List<Map> paramList,	LoginVO user) throws Exception {
		return 0;
	}





	/**
	 * 진척율 저장: 20200317 추가
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")
	public Integer updatePmp150(Map param) throws Exception {
		super.commonDao.update("s_pmr100ukrv_mitServiceImpl.updatePmp150", param);
		return 0;
	}



	/**
	 * 진척이력 조회: 20200317 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_mit")
	public List<Map> selectWorkProgressList(Map param) throws Exception{
		return super.commonDao.list("s_pmr100ukrv_mitServiceImpl.selectWorkProgressList", param);
	}

	/**
	 * 진척이력 저장: 20200317 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_mit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> savetWorkProgress (List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteWorkProgress")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertWorkProgress")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateWorkProgress")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
//			if(deleteList != null) this.deleteWorkProgress(deleteList, user);
//			if(insertList != null) this.insertWorkProgress(insertList, user);
			if(updateList != null) this.updateWorkProgress(updateList, user);
		}
		paramList.add(0, paramMaster);
		return	paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")	// UPDATE
	public Integer updateWorkProgress(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("s_pmr100ukrv_mitServiceImpl.updateWorkProgress", param);
		}
		return 0;
	}
/*
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "z_mit")	// INSERT
	public Integer	insertWorkProgress(List<Map> paramList, LoginVO user) throws Exception {
		for(Map param : paramList) {
			super.commonDao.update("s_pmr100ukrv_mitServiceImpl.insertWorkProgress", param);
		}
		return 0;
	}

	@ExtDirectMethod(group = "z_mit", needsModificatinAuth = true)				// DELETE
	public Integer deleteWorkProgress(List<Map> paramList,	LoginVO user) throws Exception {
		for(Map param :paramList) {
			super.commonDao.update("s_pmr100ukrv_mitServiceImpl.deleteWorkProgress", param);
		}
		return 0;
	}*/
}