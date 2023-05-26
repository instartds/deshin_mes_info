package foren.unilite.modules.z_wm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
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

@Service("s_mms200ukrv_wmService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Mms200ukrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/** 
	 * 유효기간 관련 - 사용 안 함
	 * @param param
	 * @return
	 * @throws Exception
	 */
/*	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public Object selectExpirationdate(Map param) throws Exception {
		return super.commonDao.select("s_mms200ukrv_wmServiceImpl.selectExpirationdate", param);
	}*/

	/**
	 * 20201230 추가 - 동적 그리드 구현(공통코드(불량코드(수입검사), Q011)에서 컬럼 가져오는 로직)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "z_wm")
	public List selectColumns(LoginVO loginVO) throws Exception {
		return (List)super.commonDao.list("s_mms200ukrv_wmServiceImpl.selectColumns", loginVO);
	}


	/**
	 * 검사등록 -> 검사내역조회
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		if("N".equals(param.get("rdoSelect"))) {	//미검사 품목 조회
			return super.commonDao.list("s_mms200ukrv_wmServiceImpl.selectList", param);
		} else {									//검사된 품목 조회
			return super.commonDao.list("s_mms200ukrv_wmServiceImpl.selectList1", param);
		}
	}






	/**
	 * 검사등록 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "z_wm")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue					= getLogKey();
		List<Map> dataList				= new ArrayList<Map>();
		Map<String, Object> dataMaster	= (Map<String, Object>) paramMaster.get("data");
		ArrayList badList				= new ArrayList();
		badList							= (ArrayList) dataMaster.get("gsBadQArray");
		ArrayList badList2				= new ArrayList();
		badList2						= (ArrayList) dataMaster.get("gsBadQArray2");
		String OPR_FLAG					= "";

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			if(paramData.get("method").equals("deleteDetail")) {
				OPR_FLAG = "D";
			}

			for(Map param: dataList) {
				ArrayList badColList	= new ArrayList();
				ArrayList badQList		= new ArrayList();
				for (int i=0; i < badList.size(); i++) {
					badColList.add("BAD_Q"+(i+1));
					badQList.add(param.get(badList.get(i)));
				}
				param.put("KEY_VALUE"	, keyValue);
				if(ObjUtils.isEmpty(param.get("OPR_FLAG"))) {
					param.put("OPR_FLAG", OPR_FLAG);
				}
				param.put("badColList"	, badColList);
				param.put("badQList"	, badQList);
				param.put("data"		, super.commonDao.insert("s_mms200ukrv_wmServiceImpl.insertLogMaster", param));
			}
		}

		//4.검사등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		spParam.put("KEY_VALUE"	, keyValue);
		spParam.put("LANG_CODE"	, user.getLanguage());

		super.commonDao.queryForObject("sp_s_mms200ukrv_wm", spParam);
		String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));

		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INSPEC_NUM", "");
			String[] messsage = errorDesc.split(";");
			throw new UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			int autoInputChk						= 0;
			List<Map> autoInputList					= new ArrayList<Map>();//자동입고 양품리스트(외주가 아닌 것)
			List<Map> autoInputOutList				= new ArrayList<Map>();//자동입고 리스트(외주)
			List<Map> autoInputBadList				= new ArrayList<Map>();//자동입고 불량리스트(외주가 아닌 것)
			List<Map> autoInputBadOutList			= new ArrayList<Map>();//자동입고 불량리스트(외주)
			List<Map> autoInputBeforeDeleteList		= new ArrayList<Map>();//자동입고전 삭제리스트(외주가 아닌 것)
			List<Map> autoInputBeforeDeleteOutList	= new ArrayList<Map>();//자동입고전 삭제리스트(외주)
			String autoInputBeforeDeleteKeyValue	= "";
			String autoInputKeyValue				= "";
			Map<String, Object> deleteSpParam		= new HashMap<String, Object>();
			Map<String, Object> insertSpParam		= new HashMap<String, Object>();
			String ErrorDesc						= "";
			String createLoc						= "2";

			Map<String, Object> autoInputParam = new HashMap<String, Object>();//자동입고 관련 파라미터
			autoInputParam.put("COMP_CODE", user.getCompCode());
			//자동입고 사용 여부 가져오기, 20201230 주석: 월드와이드메모리에서는 자동입고 로직 수행하지 않음
//			autoInputChk = (int) super.commonDao.select("s_mms200ukrv_wmServiceImpl.autoInputCheck", autoInputParam);
			//자동입고 사용시
			if(autoInputChk > 0){
				autoInputParam.put("DIV_CODE"		, dataMaster.get("DIV_CODE"));
				autoInputParam.put("INSPEC_NUM"		, ObjUtils.getSafeString(spParam.get("INSPEC_NUM")));//검사번호
				autoInputParam.put("GOOD_WH_CODE"	, ObjUtils.getSafeString(dataMaster.get("GOOD_WH_CODE")));
				autoInputParam.put("BAD_WH_CODE"	, ObjUtils.getSafeString(dataMaster.get("BAD_WH_CODE")));
				autoInputParam.put("USER_ID"		, user.getUserID());

				//1.자동입고전 삭제(외주가 아닌 것)
				//1-1발주유형이 외주가 아닌 건에대하여 기존에 수불내역이 있으면 삭제
				autoInputBeforeDeleteList = super.commonDao.list("s_mms200ukrv_wmServiceImpl.selectAutoInputBeforeDeletetList", autoInputParam);
				if(autoInputBeforeDeleteList.size() > 0){
					autoInputBeforeDeleteKeyValue = getLogKey(); //자동입고전 삭제key value(외주가 아닌 것)
					for(Map param: autoInputBeforeDeleteList) {
						param.put("KEY_VALUE"	, autoInputBeforeDeleteKeyValue);
						param.put("OPR_FLAG"	, "D");
						param.put("S_USER_ID"	, user.getUserID());
						createLoc = (String) param.get("CREATE_LOC");
						super.commonDao.insert("mms510ukrvServiceImpl.insertLogDetail", param);
					}
					deleteSpParam.put("KeyValue"	, autoInputBeforeDeleteKeyValue);
					deleteSpParam.put("LangCode"	, user.getLanguage());
					deleteSpParam.put("CreateType"	, createLoc);
					super.commonDao.queryForObject("mms510ukrvServiceImpl.spReceiving", deleteSpParam);

					ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
					if(!ObjUtils.isEmpty(ErrorDesc)){
						throw new UniDirectValidateException(this.getMessage(ErrorDesc, user));
					}
				}

				//2.자동입고전 삭제key value(외주)
				//2-1발주유형이 외주인 건 수불내역의 삭제할 건 조회
				autoInputBeforeDeleteOutList = super.commonDao.list("s_mms200ukrv_wmServiceImpl.selectAutoInputBeforeDeletetOutList", autoInputParam);
				if(autoInputBeforeDeleteOutList.size() > 0){
					autoInputBeforeDeleteKeyValue = getLogKey();
					for(Map param: autoInputBeforeDeleteOutList) {
						param.put("KEY_VALUE"	, autoInputBeforeDeleteKeyValue);
						param.put("OPR_FLAG"	, "D");
						param.put("S_USER_ID"	, user.getUserID());
						createLoc = (String) param.get("CREATE_LOC");
						super.commonDao.insert("otr120ukrvServiceImpl.insertLogDetail", param);
					}
					deleteSpParam.put("KeyValue"	, autoInputBeforeDeleteKeyValue);
					deleteSpParam.put("LangCode"	, user.getLanguage());
					deleteSpParam.put("CreateType"	, createLoc);
					super.commonDao.queryForObject("otr120ukrvServiceImpl.spOtr120ukrv", deleteSpParam);

					ErrorDesc = ObjUtils.getSafeString(deleteSpParam.get("ErrorDesc"));
					if(!ObjUtils.isEmpty(ErrorDesc)){
						throw new UniDirectValidateException(this.getMessage(ErrorDesc, user));
					}
				}

				//3.자동입고 key value(외주가 아닌 것)
				autoInputList = 	super.commonDao.list("s_mms200ukrv_wmServiceImpl.selectAutoInputList", autoInputParam);
				if(autoInputList.size() > 0){
					autoInputKeyValue = getLogKey();//자동입고 key value(외주가 아닌 것)
					int i = 0;
					for(Map param: autoInputList) {
						i = i + 1;
						param.put("KEY_VALUE"	, autoInputKeyValue);
						param.put("OPR_FLAG"	, "N");
						param.put("S_USER_ID"	, user.getUserID());
						param.put("INOUT_SEQ"	, i);
						if( param.get("ACCOUNT_YNC").equals("Y") && !param.get("INOUT_TYPE_DETAIL").equals("91") && !param.get("INOUT_TYPE_DETAIL").equals("20")&& param.get("PRICE_YN").equals("Y")){
							if(ObjUtils.parseDouble(param.get("ORDER_UNIT_FOR_P"))<= 0){
//								throw new UniDirectValidateException("입고유형이 금액보정이 아닐때 구매단가가 0 이거나 0보다 작을 수 없습니다.");
								throw new UniDirectValidateException(this.getMessage("800004",user));
							}else{
								 super.commonDao.insert("mms510ukrvServiceImpl.insertLogDetail", param);
							}
						}else{
								 super.commonDao.insert("mms510ukrvServiceImpl.insertLogDetail", param);
						}
					}
					insertSpParam.put("KeyValue"	, autoInputKeyValue);
					insertSpParam.put("LangCode"	, user.getLanguage());
					insertSpParam.put("CreateType"	, createLoc);
					super.commonDao.queryForObject("mms510ukrvServiceImpl.spReceiving", insertSpParam);

					ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
					if(!ObjUtils.isEmpty(ErrorDesc)){
						throw new UniDirectValidateException(this.getMessage(ErrorDesc, user));
					}
				}

				//3-1양품창고와 불량창고가 다르면 추가로 불량창고에 불량내역 입고
				if(! ObjUtils.getSafeString(dataMaster.get("GOOD_WH_CODE")).equals(ObjUtils.getSafeString(dataMaster.get("BAD_WH_CODE")))){
					autoInputBadList = super.commonDao.list("s_mms200ukrv_wmServiceImpl.selectAutoInputBadList", autoInputParam);
					if(autoInputBadList.size() > 0){
						autoInputKeyValue = getLogKey();//자동입고 key value(외주가 아닌 것)
						int i = 0;
						for(Map param: autoInputBadList) {
							i = i + 1;
							param.put("KEY_VALUE"	, autoInputKeyValue);
							param.put("OPR_FLAG"	, "N");
							param.put("S_USER_ID"	, user.getUserID());
							param.put("INOUT_SEQ"	, i);
							super.commonDao.insert("mms510ukrvServiceImpl.insertLogDetail", param);
						}
					}
					insertSpParam.put("KeyValue"	, autoInputKeyValue);
					insertSpParam.put("LangCode"	, user.getLanguage());
					insertSpParam.put("CreateType"	, createLoc);

					super.commonDao.queryForObject("mms510ukrvServiceImpl.spReceiving", insertSpParam);
					ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
					if(!ObjUtils.isEmpty(ErrorDesc)){
						throw new UniDirectValidateException(this.getMessage(ErrorDesc, user));
					}
				}

				//4.자동입고 (외주)
				autoInputOutList = super.commonDao.list("s_mms200ukrv_wmServiceImpl.selectAutoInputOutList", autoInputParam);
				if(autoInputOutList.size() > 0){//자동입고 key value(외주)
					autoInputKeyValue = getLogKey();
					int i = 0;
					for(Map param: autoInputOutList) {
						i = i + 1;
						param.put("KEY_VALUE"	, autoInputKeyValue);
						param.put("OPR_FLAG"	, "N");
						param.put("S_USER_ID"	, user.getUserID());
						param.put("INOUT_SEQ"	, i);
						if( param.get("ACCOUNT_YNC").equals("Y") && !param.get("INOUT_TYPE_DETAIL").equals("91") && param.get("PRICE_YN").equals("Y")){
							if(ObjUtils.parseInt(param.get("ORDER_UNIT_FOR_P"))<= 0){
//								throw new UniDirectValidateException("입고유형이 금액보정이 아닐때 구매단가가 0 이거나 0보다 작을 수 없습니다");
								throw new UniDirectValidateException(this.getMessage("800004",user));
							}else{
								super.commonDao.insert("otr120ukrvServiceImpl.insertLogDetail", param);
							}
						}else{
							super.commonDao.insert("otr120ukrvServiceImpl.insertLogDetail", param);
						}
					}
					insertSpParam.put("KeyValue"	, autoInputKeyValue);
					insertSpParam.put("LangCode"	, user.getLanguage());
					insertSpParam.put("CreateType"	, createLoc);
					super.commonDao.queryForObject("otr120ukrvServiceImpl.spOtr120ukrv", insertSpParam);

					ErrorDesc = ObjUtils.getSafeString(insertSpParam.get("ErrorDesc"));
					if(!ObjUtils.isEmpty(ErrorDesc)){
						throw new UniDirectValidateException(this.getMessage(ErrorDesc, user));
					}
				}

				//4-1양품창고와 불량창고가 다르면 추가로 불량창고에 불량내역 입고(외주)
				if(! ObjUtils.getSafeString(dataMaster.get("GOOD_WH_CODE")).equals(ObjUtils.getSafeString(dataMaster.get("BAD_WH_CODE")))){
					autoInputBadOutList = super.commonDao.list("s_mms200ukrv_wmServiceImpl.selectAutoInputOutBadList", autoInputParam);
					if(autoInputBadOutList.size() > 0){
						autoInputKeyValue = getLogKey();
						int i = 0;
						for(Map param: autoInputBadOutList) {
							i = i + 1;
							param.put("KEY_VALUE"	, autoInputKeyValue);
							param.put("OPR_FLAG"	, "N");
							param.put("S_USER_ID"	, user.getUserID());
							param.put("INOUT_SEQ"	, i);
							super.commonDao.insert("otr120ukrvServiceImpl.insertLogDetail", param);
						}
						insertSpParam.put("KeyValue"	, autoInputKeyValue);
						insertSpParam.put("LangCode"	, user.getLanguage());
						insertSpParam.put("CreateType"	, createLoc);
						super.commonDao.queryForObject("otr120ukrvServiceImpl.spOtr120ukrv", insertSpParam);

						ErrorDesc = ObjUtils.getSafeString(insertSpParam.get("ErrorDesc"));
						if(!ObjUtils.isEmpty(ErrorDesc)){
							throw new UniDirectValidateException(this.getMessage(ErrorDesc, user));
						}
					}
				}
			}
			//20210104 추가: 불량내역 저장하는 로직 추가
			List badDataList		= super.commonDao.list("s_mms200ukrv_wmServiceImpl.selectBadList", spParam);
			ArrayList badColNameList= new ArrayList();
			Map badColQtyMap		= new HashMap();
			String badColName		= "";
			for (int i=0; i < badDataList.size(); i++) {
				badColQtyMap = (Map) badDataList.get(i);
				for (int j=0; j < badList2.size(); j++) {
					badColNameList.add(badList2.get(j));
					badColName		= "BAD_Q" + ObjUtils.getSafeString(j+1);
					badColQtyMap.put("BAD_INSPEC_CODE"	, badList2.get(j));
					badColQtyMap.put("BAD_INSPEC_Q"		, badColQtyMap.get(badColName));
					super.commonDao.update("s_mms200ukrv_wmServiceImpl.insertQms210T", badColQtyMap);
				}
			}
		}
		paramList.add(0, paramMaster);
		return paramList;
	}


	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		return params;
	}

	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		return params;
	}

	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
		return;
	}





	/**
	 * 검사량이 있는지 점검
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map<String, Object>> inspecQtyCheck(Map param) throws Exception {
		return super.commonDao.list("s_mms200ukrv_wmServiceImpl.inspecQtyCheck", param);
	}





	/**
	 * 검사결과서 출력: 20201021 추가
	 * @param paramList
	 * @param user
	 * @param paramMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printMasterData(Map param) throws Exception {
		return super.commonDao.list("s_mms200ukrv_wmServiceImpl.printMasterData", param);
	}

	@ExtDirectMethod(group = "z_wm", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> printDetailData(Map param) throws Exception {
		return super.commonDao.list("s_mms200ukrv_wmServiceImpl.printDetailData", param);
	}
}