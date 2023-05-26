package foren.unilite.modules.sales.sgp;

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

@Service("sgp200ukrvService")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class Sgp200ukrvServiceImpl extends TlabAbstractServiceImpl  {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "fileMnagerService")
	private FileMnagerService fileMnagerService;
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")	  // 계획년도의 주간 카렌더가 존재 하는지 확인
	public List<Map<String, Object>>  planYear(Map param) throws Exception {  
		return  super.commonDao.list("sgp200ukrvServiceImpl.planYear", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")	  // 계획기간 구하기
	public List<Map<String, Object>>  baseDate(Map param) throws Exception {  
		return  super.commonDao.list("sgp200ukrvServiceImpl.baseDate", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")	  // DEFAULT SETTING
	public List<Map<String, Object>>  defaultSet(Map param) throws Exception {  
		return  super.commonDao.list("sgp200ukrvServiceImpl.defaultSet", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")	  // 계획기간FR 바꿀때
	public List<Map<String, Object>>  planDateFrSet(Map param) throws Exception {  
		return  super.commonDao.list("sgp200ukrvServiceImpl.planDateFrSet", param);
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")	  // 행추가 시 날짜 가져오는 로직
	public List<Map<String, Object>>  fnGetDate(Map param) throws Exception {  
		return  super.commonDao.list("sgp200ukrvServiceImpl.fnGetDate", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")	  // 1~16주까지 구하기
	public List<Map<String, Object>>  selectWeek(Map param) throws Exception {  
		return  super.commonDao.list("sgp200ukrvServiceImpl.selectWeek", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")	  // 탭1
	public List<Map<String, Object>>  selectList1(Map param) throws Exception { 
		List<Map> sYear = (List<Map>) super.commonDao.list("sgp200ukrvServiceImpl.selectYear", param);
		for(int i=0; i<sYear.size(); i++){
			param.put("sYear"+i, sYear.get(i).get("SYEAR"));
		}
		List<Map> sWeek = (List<Map>) super.commonDao.list("sgp200ukrvServiceImpl.selectWeek", param);
		for(int i=0; i<sWeek.size(); i++){
			param.put("sWeek"+i, sWeek.get(i).get("CAL_NO"));
		}
		List<Map> refCode = (List<Map>) super.commonDao.list("sgp200ukrvServiceImpl.selectRefCode2", param);
		if(refCode.isEmpty()) {
			param.put("USE_CUSTOM", "N");
		} else {
			param.put("USE_CUSTOM", refCode.get(0).get("REF_CODE1"));
		}
		return  super.commonDao.list("sgp200ukrvServiceImpl.selectList1", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")	  // 탭2
	public List<Map<String, Object>>  selectList2(Map param) throws Exception { 
		List<Map> refCode = (List<Map>) super.commonDao.list("sgp200ukrvServiceImpl.selectRefCode2", param);
		if(refCode.isEmpty()) {
			param.put("USE_CUSTOM", "N");
		} else {
			param.put("USE_CUSTOM", refCode.get(0).get("REF_CODE1"));
		}
		return  super.commonDao.list("sgp200ukrvServiceImpl.selectList2", param);
	}
	
	

	
	
	
	
	
	/**
	 * 주간 판매계획 등록 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	/**저장**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "accnt")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})	
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		if(paramList != null)	{
			List<Map> insertList = null;
			List<Map> updateList = null;
			List<Map> deleteList = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("insertDetail")) {
					insertList = (List<Map>)dataListMap.get("data");
				}else if(dataListMap.get("method").equals("updateDetail")) {
					updateList = (List<Map>)dataListMap.get("data");
				} else if(dataListMap.get("method").equals("deleteDetail")) {
					deleteList = (List<Map>)dataListMap.get("data");	
				} 
			}			
			if(deleteList != null) this.deleteDetail(deleteList, user, dataMaster);
			if(insertList != null) this.insertDetail(insertList, user, dataMaster);
			if(updateList != null) this.insertDetail(updateList, user, dataMaster);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	/**추가**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer insertDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		/* 데이터 insert */
		try {
			int i;
			for(Map param : paramList)	{
				for(i = 0; i <= 15; i++) {
					param.put("DIV_CODE"			, paramMaster.get("DIV_CODE"));
					param.put("APPL_DATE"			, param.get("APPL_DATE" + i));
					param.put("BASE_DATE"			, param.get("BASE_DATE" + i));
					if(ObjUtils.isNotEmpty(param.get("BASE_DATE"))) {
						int baseMonth = ObjUtils.parseInt(param.get("BASE_DATE").toString().substring(4, 6));
						param.put("BASE_MONTH"			, baseMonth);
					}

					param.put("PLAN_QTY"			, param.get("PLAN_QTY" + i));
					param.put("PLAN_AMT"			, param.get("PLAN_AMT" + i));
					param.put("PLAN_WEEK"			, paramMaster.get("PLAN_DATE_FR"));
					param.put("BASE_WEEK"			, paramMaster.get("BASE_WEEK"));
					param.put("P_ENT_MONEY_UNIT"	, paramMaster.get("ENT_MONEY_UNIT"));
													
					//0. EXCELUPLOAD의 경우 무조건 INSERT
					if ( param.get("EXCEL_YN").equals("Y")																			//엑셀업로드 된 데이터 중에
						&& (ObjUtils.isNotEmpty(param.get("PLAN_QTY")) && ObjUtils.parseInt(param.get("PLAN_QTY")) != 0)			//수량
//						&& (ObjUtils.isNotEmpty(param.get("PLAN_AMT")) && ObjUtils.parseInt(param.get("PLAN_AMT")) != 0)			//금액이 존재하면 insert
						) {
						super.commonDao.insert("sgp200ukrvServiceImpl.insertList", param);
					
					//1. EXCELUPLOAD가 아닐 경우
					} else if (ObjUtils.isEmpty(param.get("EXCEL_YN"))) {
						//1-1. 적용일자, 수량/금액이 존재하는 경우 
						if ( ObjUtils.isNotEmpty(param.get("APPL_DATE"))															//적용일자가 존재하고
							&& (ObjUtils.isNotEmpty(param.get("PLAN_QTY")) && ObjUtils.parseInt(param.get("PLAN_QTY")) != 0)		//수량
//							&& (ObjUtils.isNotEmpty(param.get("PLAN_AMT")) && ObjUtils.parseInt(param.get("PLAN_AMT")) != 0)		//금액이 존재하면 insert/update
							) {
							super.commonDao.insert("sgp200ukrvServiceImpl.insertList", param);
						
						//1-2. 적용일자가 존재하고 수량/금액이 존재하지 않는 경우
						} else if (ObjUtils.isNotEmpty(param.get("APPL_DATE"))														//적용일자가 존재하고,
								&& (ObjUtils.isEmpty(param.get("PLAN_QTY")) || ObjUtils.parseInt(param.get("PLAN_QTY")) == 0)		//수량
//								&& (ObjUtils.isEmpty(param.get("PLAN_AMT")) || ObjUtils.parseInt(param.get("PLAN_AMT")) == 0)		//금액이 0이면 삭제
							) {
							super.commonDao.update("sgp200ukrvServiceImpl.deleteList1", param);
							super.commonDao.update("sgp200ukrvServiceImpl.deleteList2", param);
						}
					}
				}
			}
			//월간 품목별 판매계획에 반영
			this.updateMonth(paramMaster, user);
			
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8114", user));
		}
		
		return 0;
	}	

	/**수정**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateDetail(List<Map> paramList, LoginVO user, Map paramMaster) throws Exception {
		return 0;
	} 
	
	/**삭제**/
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer deleteDetail(List<Map> paramList,  LoginVO user, Map paramMaster) throws Exception {
		try {
			for(Map param :paramList)	{
				int i;
				for(i = 0; i <= 15; i++) {
					param.put("DIV_CODE"			, paramMaster.get("DIV_CODE"));
					param.put("APPL_DATE"			, param.get("APPL_DATE" + i));
					param.put("BASE_DATE"			, param.get("BASE_DATE" + i));
					if(ObjUtils.isNotEmpty(param.get("BASE_DATE"))) {
						int baseMonth = ObjUtils.parseInt(param.get("BASE_DATE").toString().substring(4, 6));
						param.put("BASE_MONTH"			, baseMonth);
					}
					
					param.put("WK_PLAN_QTY"			, param.get("WK_PLAN_QTY" + i));
					param.put("PLAN_QTY"			, param.get("PLAN_QTY" + i));
					param.put("PLAN_AMT"			, param.get("PLAN_AMT" + i));
					param.put("PLAN_WEEK"			, paramMaster.get("PLAN_DATE_FR"));
					param.put("BASE_WEEK"			, paramMaster.get("BASE_WEEK"));
					
 
					if (ObjUtils.parseInt(param.get("WK_PLAN_QTY")) == 0) {
						super.commonDao.update("sgp200ukrvServiceImpl.deleteList1", param);
						super.commonDao.update("sgp200ukrvServiceImpl.deleteList2", param);
					}
				}
			}
			//월간 품목별 판매계획에 반영
			this.updateMonth(paramMaster, user);
			
		}catch(Exception e)	{
			throw new  UniDirectValidateException(this.getMessage("547",user));
		}	
		return 0;
	}
	
	/**
	 * 월간 품목별 판매계획에 반영
	 * => 월간 판매계획의 테이블이 1월 ~ 12월 컬럼이 존재 하므로
	 *    주간판매계획의 기준일에 따라 유동적으로 쿼리를 변경하면서 반영해야 한다.
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_MODIFY, group = "accnt")
	public Integer updateMonth(Map paramMaster, LoginVO user) throws Exception {
		try {
			Map<String, Object> param = new HashMap<String, Object>();
	
			param.put("S_COMP_CODE"		, user.getCompCode());
			param.put("DIV_CODE"		, paramMaster.get("DIV_CODE"));
			param.put("PLAN_TYPE1"		, paramMaster.get("ORDER_TYPE"));
			param.put("MONEY_UNIT"		, paramMaster.get("MONEY_UNIT"));
			param.put("ENT_MONEY_UNIT"	, paramMaster.get("ENT_MONEY_UNIT"));
			param.put("PLAN_WEEK_FR"	, paramMaster.get("PLAN_DATE_FR"));
			param.put("PLAN_WEEK_TO"	, paramMaster.get("PLAN_DATE_TO"));
	
			List<Map> getData = (List<Map>) super.commonDao.list("sgp200ukrvServiceImpl.getDataInfo", param);
			
			if(ObjUtils.isNotEmpty(getData)) {
				for(Map datum : getData)	{
					int baseMonth = ObjUtils.parseInt(datum.get("BASE_MONTH").toString().substring(4, 6));
					if(baseMonth > 12 || baseMonth < 1) {
						throw new  UniDirectValidateException(this.getMessage("8115", user));
					}
					datum.put("BASE_MONTH"		, baseMonth);
					datum.put("S_COMP_CODE"		, user.getCompCode());
					datum.put("S_USER_ID"		, user.getUserID());
					super.commonDao.insert("sgp200ukrvServiceImpl.insertMonth", datum);
				}
			}
			
		}catch(Exception e){
			throw new  UniDirectValidateException(this.getMessage("8116", user));
		}
		
		return 0;
	} 
	
	
	
	
	/**
	 * 기준요일 확인
	 * 공통코드 B604의 REF_CODE1
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  selectRefCode (Map param) throws Exception {
		return  super.commonDao.list("sgp200ukrvServiceImpl.selectRefCode", param);
	}
	
	/**
	 * 고객관리여부 확인
	 * 공통코드 S060의 REF_CODE1
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  selectRefCode2 (Map param) throws Exception {
		return  super.commonDao.list("sgp200ukrvServiceImpl.selectRefCode2", param);
	}
	
	/**
	 * 판매단가 확인
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")
	public List<Map<String, Object>>  getSaleCost (Map param) throws Exception {
		return super.commonDao.list("sgp200ukrvServiceImpl.getSaleCost", param);
	}









	/**
	 * 주간판매계획 엑셀업로드
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void excelValidate(String jobID, Map param) throws Exception {
		logger.debug("validate: {}", jobID);
		//UPLOAD 전 데이터 존재여부 체크
		List<Map> getData = (List<Map>) super.commonDao.list("sgp200ukrvServiceImpl.getData", param);
		
		if(!getData.isEmpty()){
			//excel 파일의 데이터 체크
			for(Map data : getData )  {
				param.put("ROWNUM"		, data.get("_EXCEL_ROWNUM"));
				param.put("COMP_CODE"	, data.get("COMP_CODE"));
				param.put("ITEM_CODE"	, data.get("ITEM_CODE"));
				param.put("CUSTOM_CODE"	, data.get("CUSTOM_CODE"));

				//업로드 된 데이터의 품목코드 기등록여부 확인
				String itemExistYn =  (String) super.commonDao.select("sgp200ukrvServiceImpl.checkItem", param);
				if (itemExistYn.equals("N")) {					
					if(ObjUtils.isNotEmpty(data.get("ITEM_CODE"))) {
						param.put("MSG", "품목코드 [" + data.get("ITEM_CODE") +"]를 먼저 등록한 후 업로드 해 주세요.");
						super.commonDao.update("sgp200ukrvServiceImpl.insertErrorMsg", param);
					}
				}
				//업로드 된 데이터의 거래처 기등록여부 확인
				String custExistYn =  (String) super.commonDao.select("sgp200ukrvServiceImpl.checkCust", param);
				if (custExistYn.equals("N")) {
					if(ObjUtils.isNotEmpty(data.get("CUSTOM_CODE"))) {
						param.put("MSG", "거래처코드 [" + data.get("CUSTOM_CODE") +"]를 먼저 등록한 후 업로드 해 주세요.");
						super.commonDao.update("sgp200ukrvServiceImpl.insertErrorMsg", param);
					}
				}
			}
		} 
	}
	
	@ExtDirectMethod(group = "sgp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectExcelUploadSheet1(Map param) throws Exception {
		return super.commonDao.list("sgp200ukrvServiceImpl.selectExcelUploadSheet1", param);
	}
	
	/**
	 * 업로드 한 데이터를 masterGrid1에 set하기 위해 select
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "sgp", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectUploadData(Map param) throws Exception {
		return super.commonDao.list("sgp200ukrvServiceImpl.selectUploadData", param);
	}









	/**
	 * SRM 데이터 수신
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "accnt")			//SRM 데이터 수신
	public List<Map<String, Object>>  receiveSRM (Map param) throws Exception {
		return  super.commonDao.list("sgp200ukrvServiceImpl.receiveSRM", param);
	}

}
