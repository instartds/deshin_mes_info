package foren.unilite.modules.human.hbs;

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

import com.google.gson.Gson;

import foren.framework.model.LoginVO;
import foren.framework.utils.GStringUtils;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.code.CodeDetailVO;
import foren.unilite.com.code.CodeInfo;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.tags.ComboItemModel;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.com.combo.ComboServiceImpl;


@Service("hbs020ukrService")
public class Hbs020ukrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	
	@Resource(name="tlabCodeService")
	private TlabCodeService tlabCodeService;
	
	/**
	 * 급여관리 기준 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>>  selectList1(Map param) throws Exception {
		List<Map<String, Object>> rv = (List)super.commonDao.list("hbs020ukrServiceImpl.selectList1", param);
		Map<String, Object> rvh241 = (Map<String, Object>) super.commonDao.select("hbs020ukrServiceImpl.selectList1_h241", param);
		if(rv != null && rv.size() > 0 && rvh241 != null)	{
			rv.get(0).put("RETR_YEAR_ALLOWANCE", rvh241.get("RETR_YEAR_ALLOWANCE"));
		}
		return rv;
	}

	public int  updateList1(Map param) throws Exception {
		int rv = super.commonDao.update("hbs020ukrServiceImpl.updateList1", param);
		// 당해년도 퇴직자 연차수당 퇴직금계산에서 제외 (REF_CODE1 : 제외여부(1:Yes,2:No))
		if(ObjUtils.isNotEmpty(param.get("RETR_YEAR_ALLOWANCE")))	{
			param.put("RETR_YEAR_ALLOWANCE", "1");
		} else {
			param.put("RETR_YEAR_ALLOWANCE", "2");
		}
		super.commonDao.update("hbs020ukrServiceImpl.updateList1_H241",param);
		tlabCodeService.reload(true);
		return rv;
	}

	/**
	 * 근태지급 마감일 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>>  selectList1_1(Map param) throws Exception {
		List<Map<String, Object>> rv = (List)super.commonDao.list("hbs020ukrServiceImpl.selectList1_1", param);
		return rv;
	}

	/**
	 * 근태지급 SUB_LENGTH 조회(SUB_CODE 수정시 사용)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int getSUB_LENGTH(String comp_code) throws Exception {
		int sub_length = (int)super.commonDao.select("hbs020ukrServiceImpl.getSUB_LENGTH", comp_code);
		return sub_length;
	}

	/**
	 * 급여관리기준 등록 그리드1 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll1_1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateList1_1")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList != null) {
				this.updateList1_1(updateList);
			}
			tlabCodeService.reload(true);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * 급여관리기준 등록 그리드2 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll1_2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateList1_2")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList != null) this.updateList1_2(updateList);
			
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	/**
	 * 근태지급 마감일을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> updateList1_1(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("hbs020ukrServiceImpl.updateList1_1", param);
		}
		
		return paramList;
	}

	/**
	 * 퇴직 추계액 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>>  selectList1_2(Map param) throws Exception {
		List<Map<String, Object>> rv = (List)super.commonDao.list("hbs020ukrServiceImpl.selectList1_2", param);
		return rv;
	}

	/**
	 * 퇴직 추계액을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> updateList1_2(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("hbs020ukrServiceImpl.updateList1_2", param);
		}
		return paramList;
	}

	/**
	 * 급여지급방식별 월근무시간시간
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>>  selectList1_3(Map param, LoginVO loginVO) throws Exception {
		CodeInfo codeInfo = this.tlabCodeService.getCodeInfo(loginVO.getCompCode());
		List<CodeDetailVO> dutyCodeList = codeInfo.getCodeList("H033", "", false);	//자국화폐단위 정보	
		String[] dutyCodeArr = new String[dutyCodeList.size()];
		int i= 0;
		for(CodeDetailVO map : dutyCodeList)	{
			dutyCodeArr[i]	= map.getCodeNo();
			i++;
		}
		param.put("dutyCodeArr", dutyCodeArr);
		List<Map<String, Object>> rv = (List)super.commonDao.list("hbs020ukrServiceImpl.selectList1_3", param);
		return rv;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> saveAll1_3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> updateList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateList1_3")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList != null) {
				this.updateList1_3(updateList);
				tlabCodeService.reload(true);
			}
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> updateList1_3(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("hbs020ukrServiceImpl.updateList1_3", param);
		}
		return paramList;
	}
	
	/**
	 * 달력정보등록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>>  selectList5(Map param) throws Exception {
		List<Map<String, Object>> dataList = (List) super.commonDao.list("hbs020ukrServiceImpl.selectList5", param);

		for(Map<String, Object> data : dataList )	{
			data.put("allDay", Boolean.TRUE);
			//logger.debug("  #################    data.get(REMARK).toString()  :  " + data.get("REMARK").toString());
		}
		return dataList;
	}

	/**
	 * 달력정보 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public int  insertCalendar5(Map param) throws Exception {
		int rv = 1;
		if("1".equals(param.get("REG_KIND")))	{
			rv = super.commonDao.update("hbs020ukrServiceImpl.insertCalendar5", param);
		} else if("2".equals(param.get("REG_KIND")))	{
			rv = super.commonDao.update("hbs020ukrServiceImpl.insertCopyCalendar5", param);

		} else if("3".equals(param.get("REG_KIND")))	{
			rv = super.commonDao.update("hbs020ukrServiceImpl.insertAllCalendar5", param);
		}
		return rv;
	}
	
	/**
	 * 달력정보 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public void deleteCalendar5(Map param) throws Exception {
			super.commonDao.update("hbs020ukrServiceImpl.deleteCalendar5", param);
	}
	/**
	 * 휴일정보 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "human")
	public int  updateCalendar5(Map param) throws Exception {
		int rv = super.commonDao.update("hbs020ukrServiceImpl.updateCalendar5", param);
		return rv;
	}


	/**
	 * 근무시간 조회  1
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList7(Map param) throws Exception {
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList7", param);
	}

	/**
	 * 근무시간등록 그리드1 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll7(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList7")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList7")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList7")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList7(deleteList);
			if(insertList != null) this.insertList7(insertList);
			if(updateList != null) this.updateList7(updateList);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}
	/**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> insertList7(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.insert("hbs020ukrServiceImpl.insertList7", param);
		}
		return paramList;
	}

	/**
	 * 선택된 행을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> updateList7(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			logger.debug(">> " + param);
			super.commonDao.update("hbs020ukrServiceImpl.updateList7", param);
		}
		return paramList;
	}

	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> deleteList7(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("hbs020ukrServiceImpl.deleteList7", param);
		}
		return paramList;
	}

	/**
	 * 근무시간 조회  2
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList7_1(Map param) throws Exception {
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList7_1", param);
	}

	/**
	 * 근무시간등록 그리드2 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll7_1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList7_1")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList7_1")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList7_1")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList7_1(deleteList);
			if(insertList != null) this.insertList7_1(insertList);
			if(updateList != null) this.updateList7_1(updateList);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> insertList7_1(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.insert("hbs020ukrServiceImpl.insertList7_1", param);
		}
		return paramList;
	}

	/**
	 * 선택된 행을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> updateList7_1(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.update("hbs020ukrServiceImpl.updateList7_1", param);
		}
		return paramList;
	}

	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> deleteList7_1(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("hbs020ukrServiceImpl.deleteList7_1", param);
		}
		return paramList;
	}

	/**
	 * 금호봉 탭 컬럼 데이터 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List getColumnData(String comp_code) throws Exception {
		return (List)super.commonDao.list("hbs020ukrServiceImpl.getColumnData" ,comp_code);
	}

	/**
	 * 급호봉조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hat")
	public List<Map<String, Object>> selectList11(Map param) throws Exception {

		List wages_codeList = getColumnData(param.get("S_COMP_CODE").toString());
		param.put("WAGES_CODE", wages_codeList);



//		logger.debug("===================11=====================");
//		String payGrade01 = (String) param.get("PAY_GRADE_01");
//		String payGrade02 = (String) param.get("PAY_GRADE_02");
//		String payGradeYyyy = (String) param.get("PAY_GRADE_YYYY").toString();
//
//		logger.debug("payGrade01 : " + payGrade01);
//		logger.debug("payGrade02 : " + payGrade02);
//		logger.debug("payGradeYyyy : " + payGradeYyyy);

		//기준년도 "payGroupYyyy" 조회 조건 쿼리에 추가필요



//		if (payGroupYyyy.equals("0") ||  payGroupYyyy == null){
//
//			param.put("PAY_GROUP_YYYY", "");
//		}


		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList11", param);
	}

	/**
	 * 급호봉등록  저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll11(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList11")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList11")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList11")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList11(deleteList);
			if(insertList != null) this.insertList11(insertList);
			if(updateList != null) this.updateList11(updateList);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> insertList11(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			List<Map> stdCodeList = (List)super.commonDao.list("hbs020ukrServiceImpl.getColumnData", param);
			for(Map stdParam :stdCodeList ) {
				param.put("WAGES_CODE", stdParam.get("WAGES_CODE"));
				param.put("WAGES_I", param.get("STD" + stdParam.get("WAGES_CODE")));
				super.commonDao.insert("hbs020ukrServiceImpl.insertList11", param);
			}
		}
		return paramList;
	}

	/**
	 * 선택된 행을 수정함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> updateList11(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			List<Map> stdCodeList = (List)super.commonDao.list("hbs020ukrServiceImpl.getColumnData", param);
			for(Map stdParam :stdCodeList ) {
				param.put("WAGES_CODE", stdParam.get("WAGES_CODE"));
				param.put("WAGES_I", param.get("STD" + stdParam.get("WAGES_CODE")));
				super.commonDao.insert("hbs020ukrServiceImpl.updateList11", param);
			}
		}
		return paramList;
	}

//	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
//	public int insertList11(String paramStr) throws Exception {
//
//		Gson gson = new Gson();
//		Hbs020ukrModel[] hbs020ukrModelArray = gson.fromJson(paramStr, Hbs020ukrModel[].class);
//		int result = 0;
//
//		for (int i = 0; i < hbs020ukrModelArray.length; i ++) {
//			result = super.commonDao.insert("hbs020ukrServiceImpl.insertList11", hbs020ukrModelArray[i]);
//		}
//		return result;
//	}

	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> deleteList11(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.list("hbs020ukrServiceImpl.deleteList11", param);
		}
		return paramList;
	}

	/**
	 * 연봉등록 조회
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList12(Map param, LoginVO loginVO) throws Exception {
//		param.put("S_COMP_CODE", loginVO.getCompCode());
//		param.put("S_LANG_CODE", loginVO.getLanguage());
	    List wages_codeList = getColumnData2(param.get("S_COMP_CODE").toString());
        param.put("WAGES_CODELIST", wages_codeList);
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList12", param);
	}

	/**
     * 연봉등록 탭 컬럼 데이터 조회
     * @param param
     * @return
     * @throws Exception
     */
    public List getColumnData2(String comp_code) throws Exception {
        return (List)super.commonDao.list("hbs020ukrServiceImpl.getColumnData2" ,comp_code);
    }
	/**
	 * 연봉등록 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll12(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList12")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList12")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList12")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList12(deleteList);
			if(insertList != null) this.insertList12(insertList);
			if(updateList != null) this.updateList12(updateList);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * 연봉등록 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> insertList12(List<Map> paramList) throws Exception {
		for(Map param : paramList ) {
			super.commonDao.insert("hbs020ukrServiceImpl.insertList12", param);
			if ((boolean) param.get("CHOICE")) {
				super.commonDao.update("hbs020ukrServiceImpl.updateMasterList12", param);
			}
			List<Map> stdCodeList = (List)super.commonDao.list("hbs020ukrServiceImpl.getColumnData2", param);
            for(Map stdParam :stdCodeList ) {
                param.put("WAGES_CODE_VALUE", stdParam.get("WAGES_CODE"));
                param.put("AMOUNT_I", param.get(ObjUtils.getSafeString(stdParam.get("WAGES_CODE"))));
                super.commonDao.insert("hbs020ukrServiceImpl.insertList12_2", param);
            }


		}
		return paramList;
	}

	/**
	 * 연봉등록 일괄 생성
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public int insertBatchList12(Map param) throws Exception {
		return super.commonDao.insert("hbs020ukrServiceImpl.insertBatchList12", param);
	}

	/**
	 * 연봉등록 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> updateList12(List<Map> paramList) throws Exception {
		for(Map param : paramList ) {
//			List<Map> stdCodeList = (List)super.commonDao.list("hbs020ukrServiceImpl.getColumnData2", param);
//
//			int WAGES_STD_I = 0;
//            for(Map stdParam :stdCodeList ) {
//                param.put("WAGES_CODE_VALUE", stdParam.get("WAGES_CODE"));
//                param.put("AMOUNT_I", param.get(ObjUtils.getSafeString(stdParam.get("WAGES_CODE"))));
//                super.commonDao.insert("hbs020ukrServiceImpl.updateList12_2", param);			//HBS210T_DTL UPDATE
//                WAGES_STD_I = WAGES_STD_I + (int) param.get("AMOUNT_I"); //수당합산
//
//            }
//
//            param.put("WAGES_STD_I", WAGES_STD_I);	//기본월액
//
//            int ANNUAL_SALARY_I = 0;s
//            if (WAGES_STD_I != 0){
//            	ANNUAL_SALARY_I = WAGES_STD_I * 12;
//            }else {
//            	ANNUAL_SALARY_I = 0;
//            }
//            param.put("ANNUAL_SALARY_I", ANNUAL_SALARY_I); //연봉

			super.commonDao.update("hbs020ukrServiceImpl.updateList12", param);					//HBS210T UPDATE

			if ((boolean) param.get("CHOICE")) {
				super.commonDao.update("hbs020ukrServiceImpl.updateMasterList12", param);		//HUM100T UPDATE
			}
		}
		return paramList;
	}

	/**
	 * 연봉등록 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> deleteList12(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("hbs020ukrServiceImpl.deleteList12", param);
           // super.commonDao.delete("hbs020ukrServiceImpl.deleteList12_2", param);
		}
		return paramList;
	}

	/**
	 * 계산식 목록 조회
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList15(Map param, LoginVO loginVO) throws Exception {
		/*param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("S_LANG_CODE", loginVO.getLanguage());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList15", param);*/

		List<Map> rSt1 = (List<Map>) super.commonDao.list("hbs020ukrServiceImpl.selectList15_Step1", param);
		//vrtnselect
	   /*
	   '-----------------------------------07.05.28 메시지 처리
	    Set oDic = CreateObject(sDic)

	    aMsgCode(0) = H0016
	    aMsgCode(1) = H0017
	    aMsgCode(2) = H0002
	    aMsgCode(3) = H0123
	    aMsgCode(4) = H0127
	    aMsgCode(5) = H0128

	    Set dicMsg = oDic.fnMsgDic(oDreamERPDB, aMsgCode)
	   '-----------------------------------07.05.28 메시지 처리
	   */
		String dataFlag = "0";
		List temp = new ArrayList(), temp2 = new ArrayList(), temp3 = new ArrayList(), temp4 = new ArrayList(), temp5 = new ArrayList(), temp6 = new ArrayList(), temp7 = new ArrayList(), temp8 = new ArrayList();
		int iloop = -1, loop = -1, kloop = -1;
		String vResult, strDisplay="";
		String mkQuery = "";// 2018-01-10 thkim add
		List test = new ArrayList(), test2 = new ArrayList(), test3 = new ArrayList(), test4 = new ArrayList(), test5 = new ArrayList(), test6 = new ArrayList(), test7 = new ArrayList(), test8 = new ArrayList();
		List mkUpdateQuery = new ArrayList();
		List mkUpdateQueryTemp = new ArrayList();// 2018-01-10 thkim add
		boolean chk = false;
		if(rSt1.size() > 0 )	{
			for(Map rMap1 : rSt1 )	{
				if(ObjUtils.parseInt(rMap1.get("CALCU_SEQ")) == 1)	{
					if(chk)	{
			              iloop++;
		                  test.add(strDisplay);
		                  mkUpdateQuery.add(mkQuery); // 2018-01-10 thkim add
		                  vResult = strDisplay;
		                  strDisplay = "";
		                  mkQuery = "";// 2018-01-10 thkim add
					}
					chk = true;
				}
				Map<String, Object>  step2Param = new HashMap();
				step2Param.put("S_COMP_CODE", loginVO.getCompCode());
				step2Param.put("S_LANG_CODE", loginVO.getLanguage());


				String hType = ObjUtils.getSafeString(rMap1.get("TYPE"));
				Map rSt2 ;
				//일반 테이블
				if("2".equals(hType) || "3".equals(hType) || "11".equals(hType))	{
				    if("2".equals(hType))	{
				    	step2Param.put("SELECT_NAME", ObjUtils.getSafeString(rMap1.get("SELECT_NAME")));
				    	step2Param.put("TABLE_NAME", ObjUtils.getSafeString(rMap1.get("TABLE_NAME")));
				    	step2Param.put("WHERE_COLUMN", ObjUtils.getSafeString(rMap1.get("WHERE_COLUMN")));
				    	step2Param.put("SELECT_VALUE", ObjUtils.getSafeString(rMap1.get("SELECT_VALUE")));

				    	if("G".equals(ObjUtils.getSafeString(rMap1.get("UNIQUE_CODE")).substring(0, 1)))	{
			    			step2Param.put("H_CODE", "H0013");
			    		}else if("HBS300T".equals(ObjUtils.getSafeString(rMap1.get("UNIQUE_CODE")).substring(0, 7))) 	{
			    			step2Param.put("H_CODE", "H0014");
					    }else if("HBS200T".equals(ObjUtils.getSafeString(rMap1.get("UNIQUE_CODE")).substring(0, 7)))	{
			    			step2Param.put("H_CODE", "H0015");
						}else if("BFHBS300T".equals(ObjUtils.getSafeString(rMap1.get("UNIQUE_CODE")).substring(0, 9)))	{
							step2Param.put("H_CODE", "H0128");
						}else if("HBS211T".equals(ObjUtils.getSafeString(rMap1.get("UNIQUE_CODE")).substring(0, 7)))	{
			    			step2Param.put("H_CODE", "H0139");
						}else if("HBS420T_DTL".equals(ObjUtils.getSafeString(rMap1.get("UNIQUE_CODE")).substring(0, 11)))	{
			    			step2Param.put("H_CODE", "H0140");
						}else {
							step2Param.put("H_CODE", "");
						}

				    	rSt2  =  (Map)super.commonDao.select("hbs020ukrServiceImpl.selectList15_Step2_type1", step2Param);
				    //  ' 종합코드
				    }else {

				    	step2Param.put("SELECT_VALUE", ObjUtils.getSafeString(rMap1.get("SELECT_VALUE")));
				    	step2Param.put("WHERE_COLUMN", ObjUtils.getSafeString(rMap1.get("WHERE_COLUMN")));

				    	if("BF".equals(ObjUtils.getSafeString(rMap1.get("UNIQUE_CODE")).substring(0, 2)))	{
							step2Param.put("H_CODE", "H0128");
							rSt2  = (Map) super.commonDao.select("hbs020ukrServiceImpl.selectList15_Step2_type2", step2Param);
						}else {
							rSt2  = (Map) super.commonDao.select("hbs020ukrServiceImpl.selectList15_Step3", step2Param);
						}
				    }

				    if(rSt2 != null)	{
						if(!"11".equals(ObjUtils.getSafeString(rMap1.get("TYPE"))) )	{
							 strDisplay = strDisplay + ObjUtils.getSafeString(rSt2.get("CODE_NAME"));
							 mkQuery = mkQuery + ObjUtils.getSafeString(rSt2.get("CODE_NAME")) + "|";  // 2018-01-10 thkim add
						} else {

							strDisplay = strDisplay + ObjUtils.getSafeString(this.getMsg("H0002")) + ObjUtils.getSafeString(rSt2.get("CODE_NAME")) + ObjUtils.getSafeString(this.getMsg("H0123")); ; //&   & dicMsg(H0002) & vRtnDispaly(0) & dicMsg(H0123)
							mkQuery = mkQuery + ObjUtils.getSafeString(this.getMsg("H0002")) + ObjUtils.getSafeString(rSt2.get("CODE_NAME")) + ObjUtils.getSafeString(this.getMsg("H0123")) + "|"; // 2018-01-10 thkim add
						}
				    }
				}else if("9".equals(hType) )	{
					if("900".equals(ObjUtils.getSafeString("SELECT_VALUE")) )	{


	                    strDisplay = strDisplay + ObjUtils.getSafeString(this.getMsg("H0016"));
	                    mkQuery = mkQuery + ObjUtils.getSafeString(this.getMsg("H0016")) + "|";  // 2018-01-10 thkim add
					}else {
	                        strDisplay = strDisplay +  ObjUtils.getSafeString(this.getMsg("H0127"));
	                        mkQuery = mkQuery + ObjUtils.getSafeString(this.getMsg("H0127")) + "|";  // 2018-01-10 thkim add
					}
				}else if("8".equals(hType) )	{

	                strDisplay = strDisplay + ObjUtils.getSafeString(this.getMsg("H0017"));  //&   &  & dicMsg() &
	                mkQuery = mkQuery + ObjUtils.getSafeString(this.getMsg("H0017")) + "|";  // 2018-01-10 thkim add
				}else {
	                    strDisplay = strDisplay  + ObjUtils.getSafeString(rMap1.get("SELECT_VALUE")); //&   & vrtnselect(SELECT_VALUE)
	                    mkQuery = mkQuery  + ObjUtils.getSafeString(rMap1.get("SELECT_VALUE")) + "|";  // 2018-01-10 thkim add
				}



				if(kloop < rSt1.size())		{
		            if(ObjUtils.parseInt(rMap1.get("CALCU_SEQ")) == 1 )	{

		            	String strOtKind01 =  ObjUtils.getSafeString(rMap1.get("OT_KIND_01"));
		            	strOtKind01	= (strOtKind01.indexOf("/") > -1) ? GStringUtils.left(strOtKind01, strOtKind01.length()-1) : strOtKind01;
						String strOtKind02 =  ObjUtils.getSafeString(rMap1.get("OT_KIND_02"));
						strOtKind02 = (strOtKind02.indexOf("/") > -1) ? GStringUtils.left(strOtKind02, strOtKind02.length()-1) : strOtKind02;

						String strOtKindNm01="", strOtKindNm02="";
						String[]  otKind01 = null, otKind02=null;
						//지급 공제 코드
						Map otKind01Param = new HashMap();
						otKind01Param.put("S_COMP_CODE", loginVO.getCompCode());
						if(strOtKind01.indexOf("/") > -1)	{
							otKind01 = strOtKind01.split("/");
							otKind01Param.put("ARR_OT_KIND_01", otKind01);
						}else {
							otKind01Param.put("OT_KIND_01", strOtKind01);
						}
						List<ComboItemModel> otKindList = (List<ComboItemModel>) super.commonDao.list("hbs020ukrServiceImpl.selectList15_GetComboData2", otKind01Param);

						for(ComboItemModel otkind : otKindList)	{
							strOtKindNm01 +=ObjUtils.getSafeString(otkind.getText())+"/";
						}
						if(strOtKindNm01.length()>1) strOtKindNm01 = GStringUtils.left(strOtKindNm01, strOtKindNm01.length()-1);


						//분류명
						Map otKind02Param = new HashMap();
						otKind02Param.put("S_COMP_CODE", loginVO.getCompCode());
						if(strOtKind02.indexOf("/") > -1)	{
							otKind02 = strOtKind02.split("/");

							int i=0;
							for(String item : otKind02)	{

								if(otKind01[i] !=null)	{
									otKind02Param.put("SEARCH_FIELD", otKind01[i]);
									otKind02Param.put("OT_KIND_02", otKind02[i]);
								}
								List<ComboItemModel> otKindList2 = (List<ComboItemModel>) super.commonDao.list("hbs020ukrServiceImpl.selectList15_GetComboData3", otKind02Param);
								for(ComboItemModel otkind : otKindList2)	{
									strOtKindNm02 +=ObjUtils.getSafeString(otkind.getText())+"/";
								}
								i++;
							}
							if(strOtKindNm02.length()>1) strOtKindNm02 = GStringUtils.left(strOtKindNm02, strOtKindNm02.length()-1);
						}else {
							otKind02Param.put("SEARCH_FIELD", strOtKind01);
							otKind02Param.put("OT_KIND_02", strOtKind02);
							ComboItemModel otkind = (ComboItemModel) super.commonDao.select("hbs020ukrServiceImpl.selectList15_GetComboData3", otKind02Param);

							strOtKindNm02 =ObjUtils.getSafeString(otkind.getText());
						}



		                kloop = kloop + 1;
	                    test2.add(rMap1.get("STD_CODE"));
	                    test3.add(rMap1.get("OT_KIND_01"));
	                    test4.add(rMap1.get("OT_KIND_02"));
	                    test5.add(rMap1.get("OT_KIND_FULL"));
	                    test6.add(rMap1.get("SUPP_TYPE"));
	                    test7.add(strOtKindNm01);
	                    test8.add(strOtKindNm02);
		            }
		        }

			}
			iloop = iloop + 1;
            test.add(strDisplay);
            mkUpdateQuery.add(mkQuery);  // 2018-01-10 thkim add
		}else {
			dataFlag = "1";
		}
		StringBuffer sql2 = new StringBuffer("--UBizcaluKrvkr.BizCalcuKrKr SetBizCalcuKr[fnCalcu] Step4 \n");
		if(!"1".equals(dataFlag))	{
		      temp = test;
		      temp2 = test2;
		      temp3 = test3;
		      temp4 = test4;
		      temp5 = test5;
		      temp6 = test6;
		      temp7 = test7;
		      temp8 = test8;
		      mkUpdateQueryTemp = mkUpdateQuery;
		      for(int i =0 ; i <= iloop; i++){

		        if(temp.size()-1 == i )		{
		        		sql2.append(" SELECT '"+ temp6.get(i) +"' AS SUPP_TYPE    \n");
		        		sql2.append(" 		,'"+ temp3.get(i) +"' AS OT_KIND_01   \n");
		        		sql2.append(" 		,'"+ temp4.get(i) +"' AS OT_KIND_02   \n");
		        		sql2.append(" 		, '"+ temp5.get(i) +"' AS OT_KIND_FULL \n");
		        		sql2.append(" 		, '"+ temp2.get(i) +"' AS STD_CODE    \n");
		        		sql2.append(" 		, '0' AS C                                \n");
		        		sql2.append(" 		, '"+ temp.get(i) +" ' AS B               \n");
		        		sql2.append(" 		,'"+ temp7.get(i) +"' AS OT_KIND_01_NAME   \n");
		        		sql2.append(" 		,'"+ temp8.get(i) +"' AS OT_KIND_02_NAME   \n");
		        		sql2.append(" 		,'"+ mkUpdateQueryTemp.get(i) +"' AS UPDATE_TEXT   \n");
		        } else {
		        		sql2.append("       SELECT  '"+ temp6.get(i) +"' AS SUPP_TYPE   \n");
			        	sql2.append("             , '"+ temp3.get(i) +"' AS OT_KIND_01  \n");
		        		sql2.append("             , '"+ temp4.get(i) +"' AS OT_KIND_02  \n");
		        		sql2.append("             , '"+ temp5.get(i) +"' AS OT_KIND_FULL\n");
		        		sql2.append("             , '"+ temp2.get(i) +"' AS STD_CODE     \n");
		        		sql2.append("             , '0' AS C                                 \n");
		        		sql2.append("             , '"+ temp.get(i) +"' AS B             \n");
		        		sql2.append(" 			  ,'"+ temp7.get(i) +"' AS OT_KIND_01_NAME   \n");
		        		sql2.append(" 			  ,'"+ temp8.get(i) +"' AS OT_KIND_02_NAME   \n");
		        		sql2.append(" 		,'"+ mkUpdateQueryTemp.get(i) +"' AS UPDATE_TEXT   \n");
		        		sql2.append("       UNION ALL                                        \n");
		        }
		      }
		}else {
			sql2.append("         SELECT '0' AS SUPP_TYPE 	\n");
		    sql2.append("              , '0' AS OT_KIND_01	\n");
		    sql2.append("              , '0' AS OT_KIND_02	\n");
		    sql2.append("              , '0' AS OT_KIND_FULL\n");
		    sql2.append("              , '0' AS STD_CODE	\n");
		    sql2.append("              , '0' AS C         	\n");
		    sql2.append("              , '0' AS B    		\n");
		    sql2.append(" 			,'' AS OT_KIND_01_NAME   \n");
    		sql2.append(" 			,'' AS OT_KIND_02_NAME   \n");
    		sql2.append(" 		,'0' AS UPDATE_TEXT   \n");
		}


		Map<String, Object> step5Params = new HashMap();
		step5Params.put("S_COMP_CODE", loginVO.getCompCode());
		step5Params.put("SQL2", sql2.toString());

		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList15_Step5", step5Params);
	}
	private String getMsg(String code) throws Exception {
		Map<String, Object> msgParams = new HashMap();
		msgParams.put("MSG_NO", code);
		return (String) super.commonDao.select("hbs020ukrServiceImpl.selectList15_msg", msgParams);
	}
	/**
	 * 지급/공제코드 콤보 데이터를 조회함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<ComboItemModel> tab15_GetComboData(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("hbs020ukrServiceImpl.selectList15_GetComboData", param);
	}

	/**
	 * 계산식등록 > '급/상여구분' 콤보의 REF_CODE1 추출
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "hbs", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> findRefcode1(Map param) throws Exception {
		return super.commonDao.list("hbs020ukrServiceImpl.findRefcode1", param);
	}


	/**
	 * 계산식 분류 콤보데이터를 조회함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<ComboItemModel> tab15_GetComboData2(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("hbs020ukrServiceImpl.selectList15_GetComboData2", param);
	}

	/**
	 * 계산식 분류값  콤보데이터를 조회함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<ComboItemModel> tab15_GetComboData3(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("hbs020ukrServiceImpl.selectList15_GetComboData3", param);
	}

	/**
	 * 조회된 지급/공제코드 값에 따른 분류  콤보데이터를 조회함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map> tab15_GetComboData4(Map param) throws Exception {
		List<Map> rList = new ArrayList<Map>();
		Map otKind = (Map) super.commonDao.select("hbs020ukrServiceImpl.selectList15_GetComboData4", param);
		if(otKind != null) {
			String strOtKind01 =  ObjUtils.getSafeString(otKind.get("OT_KIND_01"));
	    	strOtKind01	= (strOtKind01.indexOf("/") > -1) ? GStringUtils.left(strOtKind01, strOtKind01.length()-1) : strOtKind01;

			String strOtKindNm01="";
			String[]  otKind01 = null;

			//지급 공제 코드
			Map otKind01Param = new HashMap();
			otKind01Param.put("S_COMP_CODE", param.get("S_COMP_CODE"));
			if(strOtKind01.indexOf("/") > -1)	{
				otKind01 = strOtKind01.split("/");
				otKind01Param.put("ARR_OT_KIND_01", otKind01);
			}else {
				otKind01 = new String[1];
				otKind01[0] = strOtKind01;
				//otKind01Param.put("OT_KIND_01", strOtKind01);
			}
			for(String str : otKind01)	{
				Map map = new HashMap();
				map.put("OT_KIND_01", str);
				rList.add(map);
			}
			/*
			List<ComboItemModel> otKindList = (List<ComboItemModel>) super.commonDao.list("hbs020ukrServiceImpl.selectList15_GetComboData2", otKind01Param);
			for(ComboItemModel model: otKindList)	{
				Map map = new HashMap();
				map.put(", value)
				rList =
			}*/
		}
		return rList;
	}


	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	public List<Map> saveAll15(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList15")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList15(deleteList);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * 새로운 공식을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public int insertList15(String paramStr) throws Exception {

		Gson gson = new Gson();
		Hbs020ukrModel[] hbs020ukrModelArray = gson.fromJson(paramStr, Hbs020ukrModel[].class);
		int result = 0;
		int chk = 0;

		for (int i = 0; i < hbs020ukrModelArray.length; i ++) {
			String select_syntax = hbs020ukrModelArray[i].getSELECT_SYNTAX();
			hbs020ukrModelArray[i].setSELECT_SYNTAX(select_syntax.replaceAll("|", ""));
			if(i == 0){
				chk = (int) super.commonDao.select("hbs020ukrServiceImpl.selectHbs000TPkChk", hbs020ukrModelArray[i]);
				logger.debug("[[chk]]" + chk);
				if(chk > 0){

					super.commonDao.delete("hbs020ukrServiceImpl.deleteHbs000t", hbs020ukrModelArray[i]);

				}
			}

			result = super.commonDao.insert("hbs020ukrServiceImpl.insertList15", hbs020ukrModelArray[i]);
		}

		return result;
	}

	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public void deleteList15(List<Map> paramList) throws Exception {
		for(Map<String, Object> param :paramList ) {
			super.commonDao.update("hbs020ukrServiceImpl.deleteList15", param);
		}
	}

	/**
	 * 계산식등록 - 계산식항목 조회
	 * @param param
	 * 		  gubun = H0018:근태, H0019:지급, H0020:기타
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> tab15_getCalcData(Map param, LoginVO loginVO) throws Exception {

		param.put("S_COMP_CODE", loginVO.getCompCode());
		param.put("S_LANG_CODE", loginVO.getLanguage());
		String gubun = param.get("GUBUN").toString();

		// GUBUN = H0018
		if (gubun.equals("H0018")) {
			return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList15_H0018", param);
		// GUBUN = H0019
		} else if (gubun.toString().equals("H0019")) {
			return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList15_H0019", param);
		// GUBUN = H0020
		} else {
			return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList15_H0020", param);
		}
	}

	/**
	 * 상여금 지급 기준등록 조회
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList18(Map param, LoginVO loginVO) throws Exception {
//		param.put("S_COMP_CODE", loginVO.getCompCode());
//		param.put("S_LANG_CODE", loginVO.getLanguage());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList18", param);
	}

	/**
	 * 상여금 지급 기준등록 상여구분 코드 리스트 가져오기
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getBonusTypeCode(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("hbs020ukrServiceImpl.getBonusTypeCode", param);
	}

	/**
	 * 상여지급기준 등록 그리드1 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll18(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList18")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList18")) {
					insertList = (List<Map>)dataListMap.get("data");
				} 
			}
			if(deleteList != null) this.deleteList18(deleteList);
			if(insertList != null) this.insertList18(insertList);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> insertList18(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.insert("hbs020ukrServiceImpl.insertList18", param);
		}
		return paramList;
	}

	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> deleteList18(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("hbs020ukrServiceImpl.deleteList18", param);
		}
		return paramList;
	}

	/**
	 * 상여구분자 변경기준등록 조회
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList18_1(Map param, LoginVO loginVO) throws Exception {
//		param.put("S_COMP_CODE", loginVO.getCompCode());
//		param.put("S_LANG_CODE", loginVO.getLanguage());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList18_1", param);
	}

	/**
	 * 상여지급기준 등록 그리드2 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll18_1(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList18_1")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList18_1")) {
					insertList = (List<Map>)dataListMap.get("data");
				} 
			}
			if(deleteList != null) this.deleteList18_1(deleteList);
			if(insertList != null) this.insertList18_1(insertList);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * 선택된 행을 추가함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> insertList18_1(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.insert("hbs020ukrServiceImpl.insertList18_1", param);
		}
		return paramList;
	}

	/**
	 * 선택된 행을 삭제함
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> deleteList18_1(List<Map> paramList) throws Exception {
		for(Map param :paramList ) {
			super.commonDao.delete("hbs020ukrServiceImpl.deleteList18_1", param);
		}
		return paramList;
	}

	/**
     *
     * 엑셀의 내용을 읽어옴
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_READ)
    public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
        return super.commonDao.list("hbs020ukrServiceImpl.selectExcelUploadSheet1", param);
    }

	public void excelValidate(String jobID, Map param) {
	    logger.debug("validate: {}", jobID);
	    logger.debug("param >> " + param);
		super.commonDao.update("hbs020ukrServiceImpl.excelValidate", param);
	}



	public String test() throws Exception {
		int imsi = 0;
//		try {
			imsi = super.commonDao.insert("hbs020ukrServiceImpl.test", "");
//		} catch(Exception e){
//    		e.printStackTrace();
//    		throw e;
//    	}

		return imsi + "";
	}

	/**
	 * 근태코드등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	// 조회
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList2(Map param, LoginVO loginVO)
			throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList2",
				param);
	}

	/**
	 * 근태코드등록 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete2")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insert2")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update2")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.delete2(deleteList, user);
			if(insertList != null) this.insert2(insertList, user);
			if(updateList != null) this.update2(updateList, user);
			tlabCodeService.reload(true);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	// 입력
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert2(List<Map> paramList, LoginVO loginVO) throws Exception{
		try {
			Map selectParam = new HashMap();
			selectParam.put("MAIN_CODE", paramList.get(0).get("MAIN_CODE"));
			selectParam.put("S_COMP_CODE", loginVO.getCompCode());
			System.out.println(paramList.toString());

			List sub_length = (List) super.commonDao.list(
					"hbs020ukrServiceImpl.sub_length", selectParam);
			String sl = (String) sub_length.get(0);

			for (Map param : paramList) {
				param.put("S_COMP_CODE", loginVO.getCompCode());
				param.put("LOGIN_TYPE", loginVO.getLanguage());
				param.put("USER_ID", loginVO.getUserID());
				param.put("SUB_LENGTH", sl);
				System.out.println(param.toString());
				super.commonDao.update("hbs020ukrServiceImpl.insert2", param);
			}
		}catch(Exception e){
			logger.error(e.toString());
			throw new  UniDirectValidateException(this.getMessage("2627", loginVO));
		}
		return paramList;
	}

	// 수정
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update2(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		Map selectParam = new HashMap();
		selectParam.put("MAIN_CODE", paramList.get(0).get("MAIN_CODE"));
		selectParam.put("S_COMP_CODE", loginVO.getCompCode());

		List sub_length = (List) super.commonDao.list(
				"hbs020ukrServiceImpl.sub_length", selectParam);
		String sl = (String) sub_length.get(0);

		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("LOGIN_TYPE", loginVO.getLanguage());
			param.put("USER_ID", loginVO.getUserID());
			param.put("SUB_LENGTH", sl);
			System.out.println(param.toString());
			super.commonDao.update("hbs020ukrServiceImpl.update2", param);

		}
		return paramList;
	}

	// 삭제
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete2(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			System.out.println(param.toString());
			super.commonDao.update("hbs020ukrServiceImpl.delete2", param);

		}
		return paramList;
	}

	/**
	 * 근태코드등록 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete3")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insert3")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update3")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.delete3(deleteList, user);
			if(insertList != null) this.insert3(insertList, user);
			if(updateList != null) this.update3(updateList, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	/**
	 * 근태기준등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	// 조회
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList3(Map param, LoginVO loginVO)
			throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList3",
				param);
	}

	// 입력
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert3(List<Map> paramList, LoginVO loginVO)throws Exception{
		try {
			for (Map param : paramList) {
				param.put("S_COMP_CODE", loginVO.getCompCode());
				param.put("LOGIN_TYPE", loginVO.getLanguage());
				param.put("USER_ID", loginVO.getUserID());
				System.out.println(param.toString());
				super.commonDao.update("hbs020ukrServiceImpl.insert3", param);
			}
		}catch(Exception e){
			logger.error(e.toString());
			throw new  UniDirectValidateException(this.getMessage("2627", loginVO));
		}
		return paramList;
	}

	// 수정
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update3(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("LOGIN_TYPE", loginVO.getLanguage());
			param.put("USER_ID", loginVO.getUserID());

			System.out.println(param.toString());
			super.commonDao.update("hbs020ukrServiceImpl.update3", param);

		}
		return paramList;
	}

	// 삭제
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete3(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			System.out.println(param.toString());
			super.commonDao.update("hbs020ukrServiceImpl.delete3", param);

		}
		return paramList;
	}

	/**
	 * 근태코드등록 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll4(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("update2")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList != null) {
				this.update2(updateList, user);
				tlabCodeService.reload(true);
			}
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}
	/**
	 * 휴무별근무시간 등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	// 조회
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList4(Map param, LoginVO loginVO)
			throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList4",
				param);
	}

	/**
	 * 등록 및 삭제기능은 없고 수정기능은 근태코드등록의 수정기능(update2)을 사용 read :
	 * 'hbs020ukrService.selectList4', update: 'hbs020ukrService.update2'
	 */
	/**
	 * 근무조등록 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll6(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete2")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insert2")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update2")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.delete2(deleteList, user);
			if(insertList != null) this.insert2(insertList, user);
			if(updateList != null) this.update2(updateList, user);
			tlabCodeService.reload(true);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}
	/**
	 * 근무조 등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	/**
	 * read : 'hbs020ukrService.selectList4', create:
	 * 'hbs020ukrService.insert2', update: 'hbs020ukrService.update2', destroy:
	 * 'hbs020ukrService.delete2'
	 */

	/**
	 * 년월차기준 등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	// 조회
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList8(Map param, LoginVO loginVO)
			throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList8",
				param);
	}

	/**
	 * 년월차기준 등록
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll8(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete8")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insert8")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update8")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.delete8(deleteList, user);
			if(insertList != null) this.insert8(insertList, user);
			if(updateList != null) this.update8(updateList, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	// 입력
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert8(List<Map> paramList, LoginVO loginVO)throws Exception {
		try{
			for (Map param : paramList) {
				param.put("S_COMP_CODE", loginVO.getCompCode());
				param.put("USER_ID", loginVO.getUserID());

				System.out.println(param.toString());
				super.commonDao.update("hbs020ukrServiceImpl.insert8", param);
			}
		}catch(Exception e){
			logger.error(e.toString());
			throw new  UniDirectValidateException(this.getMessage("2627", loginVO));
		}
		return paramList;
	}

	// 수정
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update8(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("USER_ID", loginVO.getUserID());

			System.out.println(param.toString());
			super.commonDao.update("hbs020ukrServiceImpl.update8", param);

		}
		return paramList;
	}

	// 삭제
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete8(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			super.commonDao.update("hbs020ukrServiceImpl.delete8", param);

		}
		return paramList;
	}

	/**
	 * 지급/공제코드 등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	// 조회
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList9sub1(Map param, LoginVO loginVO)
			throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList9_1",
				param);
	}

	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList9sub2(Map param, LoginVO loginVO)
			throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList9_2",
				param);
	}

	/**
	 * 코드명 수정시 HPA200 이나 HPA300 에 있으면 수정 삭제 못하게 한다.
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map> useExistCheck9sub2(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("hbs020ukrServiceImpl.useExistCheck9sub2", param);
	}

	/**
	 * 지급/공제코드등록 (지급내역) 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll9_2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete9sub2")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insert9sub2")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update9sub2")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.delete9sub2(deleteList, user);
			if(insertList != null) this.insert9sub2(insertList, user);
			if(updateList != null) this.update9sub2(updateList, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	// 입력
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert9sub2(List<Map> paramList, LoginVO loginVO) throws Exception {
		try{
			for (Map param : paramList) {
				param.put("S_COMP_CODE", loginVO.getCompCode());
				param.put("USER_ID", loginVO.getUserID());


				System.out.println(param.toString());
				super.commonDao.update("hbs020ukrServiceImpl.insert9_2", param);
			}
		}catch(Exception e){
			logger.error(e.toString());
			throw new  UniDirectValidateException(this.getMessage("2627", loginVO));
		}
		return paramList;
	}

	// 수정
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update9sub2(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("USER_ID", loginVO.getUserID());

			System.out.println(param.toString());
			super.commonDao.update("hbs020ukrServiceImpl.update9_2", param);

		}
		return paramList;
	}

	// 삭제
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete9sub2(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			super.commonDao.update("hbs020ukrServiceImpl.delete9_2", param);

		}
		return paramList;
	}

	/**
	 * 지급/공제코드등록 (지급내역) 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll9_3(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete9sub3")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insert9sub3")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update9sub3")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.delete9sub3(deleteList, user);
			if(insertList != null) this.insert9sub3(insertList, user);
			if(updateList != null) this.update9sub3(updateList, user);
			tlabCodeService.reload(true);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert9sub3(List<Map> paramList, LoginVO loginVO) throws Exception {
		try{
			Map selectParam = new HashMap();
			selectParam.put("MAIN_CODE", paramList.get(0).get("MAIN_CODE"));
			selectParam.put("S_COMP_CODE", loginVO.getCompCode());
			System.out.println(paramList.toString());

			List sub_length = (List) super.commonDao.list(
					"hbs020ukrServiceImpl.sub_length", selectParam);
			String sl = (String) sub_length.get(0);

			for (Map param : paramList) {
				param.put("S_COMP_CODE", loginVO.getCompCode());
				param.put("USER_ID", loginVO.getUserID());
				param.put("SUB_LENGTH", sl);

				System.out.println(param.toString());
				super.commonDao.update("hbs020ukrServiceImpl.insert9_3", param);
			}

			tlabCodeService.reload(true);
		}catch(Exception e){
			logger.error(e.toString());
			throw new  UniDirectValidateException(this.getMessage("2627", loginVO));
		}
		return paramList;
	}


	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update9sub3(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		Map selectParam = new HashMap();
		selectParam.put("MAIN_CODE", paramList.get(0).get("MAIN_CODE"));
		selectParam.put("S_COMP_CODE", loginVO.getCompCode());
		System.out.println(paramList.toString());

		List sub_length = (List) super.commonDao.list(
				"hbs020ukrServiceImpl.sub_length", selectParam);
		String sl = (String) sub_length.get(0);
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("USER_ID", loginVO.getUserID());
			param.put("SUB_LENGTH", sl);

			System.out.println(param.toString());
			super.commonDao.update("hbs020ukrServiceImpl.update9_3", param);

		}

		tlabCodeService.reload(true);
		return paramList;
	}

	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete9sub3(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			super.commonDao.update("hbs020ukrServiceImpl.delete9_3", param);

		}

		tlabCodeService.reload(true);
		return paramList;
	}

	/**
	 * 입퇴사자 지급 등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	// 조회
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList10(Map param, LoginVO loginVO)
			throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());

		System.out.println(param.toString());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList10",
				param);
	}

	/**
	 * 입퇴사자 지급 등록 수당코드 리스트 가져오기
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getWagesCode(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("hbs020ukrServiceImpl.getWagesCode", param);
	}

	/**
	 * 지급/공제항목
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
	public List<ComboItemModel> getWagesCode2(Map param) throws Exception {
		return (List<ComboItemModel>) super.commonDao.list("hbs020ukrServiceImpl.getWagesCode2", param);
	}



	/**
	 * 입/퇴사자 지급기준등록 스토어 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll10(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete10")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insert10")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update10")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.delete10(deleteList, user);
			if(insertList != null) this.insert10(insertList, user);
			if(updateList != null) this.update10(updateList, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}


	// 입력
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert10(List<Map> paramList, LoginVO loginVO) throws Exception {
		try{
			for (Map param : paramList) {
				param.put("S_COMP_CODE", loginVO.getCompCode());
				param.put("USER_ID", loginVO.getUserID());

				System.out.println(param.toString());
				super.commonDao.update("hbs020ukrServiceImpl.insert10", param);
			}
		}catch(Exception e){
			logger.error(e.toString());
			throw new  UniDirectValidateException(this.getMessage("2627", loginVO));
		}
		return paramList;
	}

	// 수정
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update10(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("USER_ID", loginVO.getUserID());

			System.out.println(param.toString());
			super.commonDao.update("hbs020ukrServiceImpl.update10", param);

		}
		return paramList;
	}

	// 삭제
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete10(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			super.commonDao.update("hbs020ukrServiceImpl.delete10", param);

		}
		return paramList;
	}

	/**
	 * 부서별요율 등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	// 조회
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList13(Map param, LoginVO loginVO)
			throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());

		System.out.println(param.toString());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList13",
				param);
	}

	/**
	 * 부서별요율 등록 대상부서일괄생성 버튼 클릭시 부서 생성
	 * @param param
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map> createBaseDept(Map param, LoginVO user) throws Exception {
		return  super.commonDao.list("hbs020ukrServiceImpl.createBaseDept", param);
	}

	/**
	 * 부서별요율등록 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll13(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete13")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insert13")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update13")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.delete13(deleteList, user);
			if(insertList != null) this.insert13(insertList, user);
			if(updateList != null) this.update13(updateList, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	// 입력
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert13(List<Map> paramList, LoginVO loginVO) throws Exception {
		try{
			for (Map param : paramList) {
				param.put("S_COMP_CODE", loginVO.getCompCode());
				param.put("USER_ID", loginVO.getUserID());

				System.out.println(param.toString());
				 super.commonDao.update("hbs020ukrServiceImpl.insert13", param);
			}
		}catch(Exception e){
			logger.error(e.toString());
			throw new  UniDirectValidateException(this.getMessage("2627", loginVO));
		}
		return paramList;
	}

	// 수정
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update13(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("USER_ID", loginVO.getUserID());

			System.out.println(param.toString());
			super.commonDao.update("hbs020ukrServiceImpl.update13", param);

		}
		return paramList;
	}

	// 삭제
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete13(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			super.commonDao.update("hbs020ukrServiceImpl.delete13", param);

		}
		return paramList;
	}



	/**
	 * 끝전처리기준등록 > 지급/공제항목 콤보 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */

    @ExtDirectMethod(value = ExtDirectMethodType.STORE_READ)
    public List<ComboItemModel> fnGetWagesType (Map param) throws Exception {
        return (List<ComboItemModel>) super.commonDao.list("hbs020ukrServiceImpl.fnGetWagesType", param);
    }
	/**
	 * 끝전처리기준 등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	// 조회
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList14(Map param, LoginVO loginVO)
			throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());

		System.out.println(param.toString());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList14",
				param);
	}

	/**
	 * 끝전처리기준 등록 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll14(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete14")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insert14")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update14")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.delete14(deleteList, user);
			if(insertList != null) this.insert14(insertList, user);
			if(updateList != null) this.update14(updateList, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	// 입력
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert14(List<Map> paramList, LoginVO loginVO)throws Exception {
		try{
			for (Map param : paramList) {
				param.put("S_COMP_CODE", loginVO.getCompCode());
				param.put("USER_ID", loginVO.getUserID());

				System.out.println(param.toString());
				 super.commonDao.update("hbs020ukrServiceImpl.insert14", param);
			}
		}catch(Exception e){
			logger.error(e.toString());
			throw new  UniDirectValidateException(this.getMessage("2627", loginVO));
		}
		return paramList;
	}

	// 수정
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update14(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("USER_ID", loginVO.getUserID());

			System.out.println(param.toString());
			super.commonDao.update("hbs020ukrServiceImpl.update14", param);

		}
		return paramList;
	}

	// 삭제
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete14(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			super.commonDao.update("hbs020ukrServiceImpl.delete14", param);

		}
		return paramList;
	}


	/**
	 * 근속수당기준 등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	// 조회
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList16(Map param, LoginVO loginVO)
			throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());

		System.out.println(param.toString());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList16",
				param);
	}

	/**
	 * 근속수당기준 등록 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll16(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete16")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insert16")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update16")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.delete16(deleteList, user);
			if(insertList != null) this.insert16(insertList, user);
			if(updateList != null) this.update16(updateList, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	// 입력
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert16(List<Map> paramList, LoginVO loginVO) throws Exception {
		try{
			for (Map param : paramList) {
				param.put("S_COMP_CODE", loginVO.getCompCode());
				param.put("USER_ID", loginVO.getUserID());

				System.out.println(param.toString());
				 super.commonDao.update("hbs020ukrServiceImpl.insert16", param);
			}
		}catch(Exception e){
			logger.error(e.toString());
			throw new  UniDirectValidateException(this.getMessage("2627", loginVO));
		}
		return paramList;
	}

	// 수정
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update16(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("USER_ID", loginVO.getUserID());

			System.out.println(param.toString());
			super.commonDao.update("hbs020ukrServiceImpl.update16", param);

		}
		return paramList;
	}

	// 삭제
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete16(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			super.commonDao.update("hbs020ukrServiceImpl.delete16", param);

		}
		return paramList;
	}



	/**
	 * 상여구분자 등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	/**
	 * read : 'hbs020ukrService.selectList4',
        create: 'hbs020ukrService.insert2',
        update: 'hbs020ukrService.update2',
        destroy: 'hbs020ukrService.delete2'
	 */


	/**
	 * 서류내역 등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	// 조회
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList19(Map param, LoginVO loginVO)
			throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());

		System.out.println(param.toString());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList19",
				param);
	}

	/**
	 * 서류내역등록 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll19(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete19")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insert19")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update19")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.delete19(deleteList, user);
			if(insertList != null) this.insert19(insertList, user);
			if(updateList != null) this.update19(updateList, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	// 입력
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert19(List<Map> paramList, LoginVO loginVO) throws Exception {
		try{
			for (Map param : paramList) {
				param.put("S_COMP_CODE", loginVO.getCompCode());
				param.put("USER_ID", loginVO.getUserID());

				System.out.println(param.toString());
				 super.commonDao.update("hbs020ukrServiceImpl.insert19", param);
			}
		}catch(Exception e){
			logger.error(e.toString());
			throw new  UniDirectValidateException(this.getMessage("2627", loginVO));
		}
		return paramList;
	}

	// 수정
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update19(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("USER_ID", loginVO.getUserID());

			System.out.println(param.toString());
			super.commonDao.update("hbs020ukrServiceImpl.update19", param);

		}
		return paramList;
	}

	// 삭제
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete19(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			super.commonDao.update("hbs020ukrServiceImpl.delete19", param);

		}
		return paramList;
	}



	/**
	 * 주민세신고지점 등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	// 조회
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList20(Map param, LoginVO loginVO)
			throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());

		System.out.println(param.toString());
		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList20",
				param);
	}

	/**
	 * 지방소득세신고지점등록 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll20(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("delete20")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insert20")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("update20")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.delete20(deleteList, user);
			if(insertList != null) this.insert20(insertList, user);
			if(updateList != null) this.update20(updateList, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	// 입력
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insert20(List<Map> paramList, LoginVO loginVO) throws Exception {
		try{
			for (Map param : paramList) {
				param.put("S_COMP_CODE", loginVO.getCompCode());
				param.put("USER_ID", loginVO.getUserID());

				System.out.println(param.toString());
				 super.commonDao.update("hbs020ukrServiceImpl.insert20", param);
			}
		}catch(Exception e){
			logger.error(e.toString());
			throw new  UniDirectValidateException(this.getMessage("2627", loginVO));
		}
		return paramList;
	}

	// 수정
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> update20(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("USER_ID", loginVO.getUserID());

			System.out.println(param.toString());
			super.commonDao.update("hbs020ukrServiceImpl.update20", param);

		}
		return paramList;
	}

	// 삭제
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> delete20(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			super.commonDao.update("hbs020ukrServiceImpl.delete20", param);

		}
		return paramList;
	}


	/**
	 * 메일서버정보 등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	// 조회
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList21(Map param, LoginVO loginVO)
			throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());

		System.out.println(param.toString());

		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList21", param);
	}


	// 수정
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public int submit21(Map<String, Object> param, LoginVO loginVO) throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());
		return super.commonDao.update("hbs020ukrServiceImpl.submit21", param);

	}


	/**
	 * 금융기관코드매칭 등록 작업자 : 구민석
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	// 조회
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList22(Map param, LoginVO loginVO)
			throws Exception {
		param.put("S_COMP_CODE", loginVO.getCompCode());

		System.out.println(param.toString());

		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList22", param);
	}

	/**
	 * 금융기관코드 매칭 등록 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll22(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
			    if(dataListMap.get("method").equals("update22")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateList != null) this.update22(updateList, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	// 수정
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "human")
	public List<Map> update22(List<Map> paramList, LoginVO loginVO)
			throws Exception {
		for (Map param : paramList) {
			param.put("S_COMP_CODE", loginVO.getCompCode());
			param.put("USER_ID", loginVO.getUserID());

			System.out.println(param.toString());
			super.commonDao.update("hbs020ukrServiceImpl.update22", param);

		}
		return paramList;
	}

	// sync All
	@ExtDirectMethod(group = "human")
	public Integer syncAll(Map param) throws Exception {
		logger.debug("syncAll:" + param);
		return  0;
	}


	@ExtDirectMethod(group = "human")
	public Map insertCalendar(Map params, LoginVO loginVO) throws Exception {

		return params;
	}

	@ExtDirectMethod(group = "human")
	public Map insertCopyCalendar(Map params, LoginVO loginVO) throws Exception {

		return params;
	}

	@ExtDirectMethod(group = "human")
	public Map nsertAllCopyCalendar(Map params, LoginVO loginVO) throws Exception {

		return params;
	}












    /**
     * 급호봉 정보 엑셀업로드
     *
     * @param jobID
     * @param param
     */
    public void excelValidate11 ( String jobID, Map param ) throws Exception {
    	//20200701 추가: 지급/공제코드 등록(HBS300T)에 등록되어 있는 수당코드 여부 체크로직 추가
        super.commonDao.update("hbs020ukrServiceImpl.beforeExcelCheck1", param);

    	//임시 테이블에 데이저 저장 시, 오류발생여부 체크
        Object excelCheck = super.commonDao.select("hbs020ukrServiceImpl.beforeExcelCheck", param);
        //임시 테이블에 insert 시, 오류가 없으면...
        if (ObjUtils.isEmpty(excelCheck)) {
            //업로드 된 데이터 가져오기
            List<Map> getData = (List<Map>)super.commonDao.list("hbs020ukrServiceImpl.getData", param);

            if (!getData.isEmpty()) {
            	Map resultMap = (Map) super.commonDao.select("hbs020ukrServiceImpl.excelValidate11", param);
            	if(ObjUtils.isNotEmpty(resultMap)) {
                  param.put("ROWNUM"	, getData.size());
                  param.put("MSG", "데이터 업로드 중 오류가 발생했습니다. \n 관리자에게 문의하시기 바랍니다.");
                  super.commonDao.update("hbs020ukrServiceImpl.insertErrorMsg", param);
            	}
            }
        }
    }

    /**
     * 에러 메세지 조회
     *
     * @param param
     * @return
     * @throws Exception
     */
    @ExtDirectMethod( group = "human", value = ExtDirectMethodType.STORE_READ )
    public Object getErrMsg ( Map param, LoginVO user ) throws Exception {
        return super.commonDao.select("hbs020ukrServiceImpl.getErrMsg", param);
    }
    
    
    /**
	 * 최저임금정보 조회
	 *
	 * @param param
	 * @param loginVO
	 * @return
	 * @throws Exception
	 */
	// 조회
	@Transactional(readOnly = true)
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "human")
	public List<Map<String, Object>> selectList23(Map param, LoginVO loginVO)
			throws Exception {

		return (List) super.commonDao.list("hbs020ukrServiceImpl.selectList23", param);
	}

	/**
	 * 최저임금정보 저장
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "human")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll23(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("deleteList23")) {
					deleteList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("insertList23")) {
					insertList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("updateList23")) {
					updateList = (List<Map>)dataListMap.get("data");
				}
			}
			if(deleteList != null) this.deleteList23(deleteList, user);
			if(insertList != null) this.insertList23(insertList, user);
			if(updateList != null) this.updateList23(updateList, user);
		}
		paramList.add(0, paramMaster);

		return  paramList;
	}

	// 입력
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertList23(List<Map> paramList, LoginVO loginVO) throws Exception {
		for (Map param : paramList) {
			 super.commonDao.update("hbs020ukrServiceImpl.insert23", param);
		}
		return paramList;
	}

	// 수정
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateList23(List<Map> paramList, LoginVO loginVO) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("hbs020ukrServiceImpl.update23", param);
		}
		return paramList;
	}

	// 삭제
	@ExtDirectMethod(group = "human", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> deleteList23(List<Map> paramList, LoginVO loginVO) throws Exception {
		for (Map param : paramList) {
			super.commonDao.update("hbs020ukrServiceImpl.delete23", param);
		}
		return paramList;
	}
}
