package foren.unilite.modules.z_mek;

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

@Service("s_mms200ukrv_mekService")
public class S_mms200ukrv_mekServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 유효기간 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object selectExpirationdate(Map param) throws Exception {
		return super.commonDao.select("s_mms200ukrv_mekServiceImpl.selectExpirationdate", param);
	}
	
	/**
	 * 검사등록 -> 검사내역조회
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		return super.commonDao.list("s_mms200ukrv_mekServiceImpl.selectList1", param);
	}
	
	/**
	 * 검사등록 -> 불량내역조회
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return super.commonDao.list("s_mms200ukrv_mekServiceImpl.selectList2", param);
	}
	
	/**
	 * 검사등록->접수참조
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectreceiptList(Map param) throws Exception {
		return super.commonDao.list("s_mms200ukrv_mekServiceImpl.selectreceiptList", param);
	}
	
	/**
	 * 검사등록->검사내역검색
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectreceiptNumMasterList(Map param) throws Exception {
		return super.commonDao.list("s_mms200ukrv_mekServiceImpl.selectreceiptNumMasterList", param);
	}
	
	/**
	 * 검사등록 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();
		
		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		
		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";
			
			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
				if("N".equals(oprFlag) && (param.get("INSPEC_NUM") == null || "".equals(param.get("INSPEC_NUM")))){
					param.put("INSPEC_NUM", dataMaster.get("INSPEC_NUM"));
				}
				param.put("data", super.commonDao.insert("s_mms200ukrv_mekServiceImpl.insertLogMaster", param));
			}
		}
		
		//4.접수등록 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		
		spParam.put("KEY_VALUE", keyValue);
		spParam.put("LANG_CODE", user.getLanguage());
		spParam.put("INSPEC_NUM", dataMaster.get("INSPEC_NUM"));
		
		super.commonDao.queryForObject("s_mms200ukrv_mekServiceImpl.spUSP_MATRL_MMS200UKRV", spParam);
		
		String errorDesc = ObjUtils.getSafeString(spParam.get("ERROR_DESC"));
		
		if(!ObjUtils.isEmpty(errorDesc)){
			dataMaster.put("INSPEC_NUM", "");
			String[] messsage = errorDesc.split(";");
			throw new  UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			int autoInputChk = 0;
			List<Map> autoInputList = new ArrayList<Map>();//자동입고 양품리스트(외주가 아닌 것)
			List<Map> autoInputOutList = new ArrayList<Map>();//자동입고 리스트(외주)
			List<Map> autoInputBadList = new ArrayList<Map>();//자동입고 불량리스트(외주가 아닌 것)
			List<Map> autoInputBadOutList = new ArrayList<Map>();//자동입고 불량리스트(외주)
			List<Map> autoInputBeforeDeleteList = new ArrayList<Map>();//자동입고전 삭제리스트(외주가 아닌 것)
			List<Map> autoInputBeforeDeleteOutList = new ArrayList<Map>();//자동입고전 삭제리스트(외주)
			String autoInputBeforeDeleteKeyValue = "";
			String autoInputKeyValue = "";
			Map<String, Object> deleteSpParam = new HashMap<String, Object>();
			Map<String, Object> insertSpParam = new HashMap<String, Object>();
			String ErrorDesc = "";
			String createLoc = "2";
			Map<String, Object> autoInputParam = new HashMap<String, Object>();//자동입고 관련 파라미터
			autoInputParam.put("COMP_CODE", user.getCompCode());
			
			//자동입고 사용 여부 가져오기
			autoInputChk = (int) super.commonDao.select("s_mms200ukrv_mekServiceImpl.autoInputCheck", autoInputParam);
			//자동입고 사용시
			if(autoInputChk > 0){
				autoInputParam.put("DIV_CODE", dataMaster.get("DIV_CODE"));
				autoInputParam.put("INSPEC_NUM", ObjUtils.getSafeString(spParam.get("INSPEC_NUM")));//검사번호
				autoInputParam.put("GOOD_WH_CODE", ObjUtils.getSafeString(dataMaster.get("GOOD_WH_CODE")));
				autoInputParam.put("BAD_WH_CODE", ObjUtils.getSafeString(dataMaster.get("BAD_WH_CODE")));
				autoInputParam.put("USER_ID", user.getUserID());
				
				//1.자동입고전 삭제(외주가 아닌 것)
				//1-1발주유형이 외주가 아닌 건에대하여 기존에 수불내역이 있으면 삭제
				autoInputBeforeDeleteList = super.commonDao.list("s_mms200ukrv_mekServiceImpl.selectAutoInputBeforeDeletetList", autoInputParam);
				if(autoInputBeforeDeleteList.size() > 0){
					autoInputBeforeDeleteKeyValue = getLogKey(); //자동입고전 삭제key value(외주가 아닌 것)
					for(Map param:  autoInputBeforeDeleteList) {
						param.put("KEY_VALUE", autoInputBeforeDeleteKeyValue);
						param.put("OPR_FLAG", "D");
						param.put("S_USER_ID", user.getUserID());
						createLoc = (String) param.get("CREATE_LOC");
						super.commonDao.insert("mms510ukrvServiceImpl.insertLogDetail", param);
					}
					
					deleteSpParam.put("KeyValue", autoInputBeforeDeleteKeyValue);
					deleteSpParam.put("LangCode", user.getLanguage());
					deleteSpParam.put("CreateType", createLoc);
					
					super.commonDao.queryForObject("mms510ukrvServiceImpl.spReceiving", deleteSpParam);
					
					ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
					if(!ObjUtils.isEmpty(ErrorDesc)){
						throw new  UniDirectValidateException(this.getMessage(ErrorDesc, user));
					}
				}
				
				//2.자동입고전 삭제key value(외주)
				//2-1발주유형이 외주인 건 수불내역의 삭제할 건 조회
				autoInputBeforeDeleteOutList = super.commonDao.list("s_mms200ukrv_mekServiceImpl.selectAutoInputBeforeDeletetOutList", autoInputParam);
				if(autoInputBeforeDeleteOutList.size() > 0){
					 autoInputBeforeDeleteKeyValue = getLogKey();
					for(Map param:  autoInputBeforeDeleteOutList) {
						param.put("KEY_VALUE", autoInputBeforeDeleteKeyValue);
						param.put("OPR_FLAG", "D");
						param.put("S_USER_ID", user.getUserID());
						createLoc = (String) param.get("CREATE_LOC");
						super.commonDao.insert("otr120ukrvServiceImpl.insertLogDetail", param);
					}
					
					deleteSpParam.put("KeyValue", autoInputBeforeDeleteKeyValue);
					deleteSpParam.put("LangCode", user.getLanguage());
					deleteSpParam.put("CreateType", createLoc);
					
					super.commonDao.queryForObject("otr120ukrvServiceImpl.spOtr120ukrv", deleteSpParam);
					ErrorDesc = ObjUtils.getSafeString(deleteSpParam.get("ErrorDesc"));
					if(!ObjUtils.isEmpty(ErrorDesc)){
						throw new  UniDirectValidateException(this.getMessage(ErrorDesc, user));
					}
				}
				
				//3.자동입고 key value(외주가 아닌 것)
				autoInputList = 	super.commonDao.list("s_mms200ukrv_mekServiceImpl.selectAutoInputList", autoInputParam);
				if(autoInputList.size() > 0){
					autoInputKeyValue = getLogKey();//자동입고 key value(외주가 아닌 것)
					int i = 0;
					for(Map param:  autoInputList) {
						i = i + 1;
						param.put("KEY_VALUE", autoInputKeyValue);
						param.put("OPR_FLAG", "N");
						param.put("S_USER_ID", user.getUserID());
						param.put("INOUT_SEQ",i);
						if( param.get("ACCOUNT_YNC").equals("Y") && !param.get("INOUT_TYPE_DETAIL").equals("91") && !param.get("INOUT_TYPE_DETAIL").equals("20")&& param.get("PRICE_YN").equals("Y")){
							if(ObjUtils.parseDouble(param.get("ORDER_UNIT_FOR_P"))<= 0){
								throw new  UniDirectValidateException(this.getMessage("800004",user));
							}else{
								super.commonDao.insert("mms510ukrvServiceImpl.insertLogDetail", param);
							}
						}else{
							super.commonDao.insert("mms510ukrvServiceImpl.insertLogDetail", param);
						}
					}
					insertSpParam.put("KeyValue", autoInputKeyValue);
					insertSpParam.put("LangCode", user.getLanguage());
					insertSpParam.put("CreateType", createLoc);
					
					super.commonDao.queryForObject("mms510ukrvServiceImpl.spReceiving", insertSpParam);
					
					ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
					if(!ObjUtils.isEmpty(ErrorDesc)){
						throw new  UniDirectValidateException(this.getMessage(ErrorDesc, user));
					}
				}
				
				//3-1양품창고와 불량창고가 다르면 추가로 불량창고에 불량내역 입고
				if(! ObjUtils.getSafeString(dataMaster.get("GOOD_WH_CODE")).equals(ObjUtils.getSafeString(dataMaster.get("BAD_WH_CODE")))){
					autoInputBadList = super.commonDao.list("s_mms200ukrv_mekServiceImpl.selectAutoInputBadList", autoInputParam);
					if(autoInputBadList.size() > 0){
						autoInputKeyValue = getLogKey();//자동입고 key value(외주가 아닌 것)
						int i = 0;
						for(Map param:  autoInputBadList) {
							 i = i + 1;
							param.put("KEY_VALUE", autoInputKeyValue);
							param.put("OPR_FLAG", "N");
							param.put("S_USER_ID", user.getUserID());
							param.put("INOUT_SEQ",i);
							super.commonDao.insert("mms510ukrvServiceImpl.insertLogDetail", param);
						}
					}
					insertSpParam.put("KeyValue", autoInputKeyValue);
					insertSpParam.put("LangCode", user.getLanguage());
					insertSpParam.put("CreateType", createLoc);
					
					super.commonDao.queryForObject("mms510ukrvServiceImpl.spReceiving", insertSpParam);
					ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
					if(!ObjUtils.isEmpty(ErrorDesc)){
						throw new  UniDirectValidateException(this.getMessage(ErrorDesc, user));
					}
				}
				
				//4.자동입고 (외주)
				autoInputOutList = 	super.commonDao.list("s_mms200ukrv_mekServiceImpl.selectAutoInputOutList", autoInputParam);
				if(autoInputOutList.size() > 0){//자동입고 key value(외주)
					autoInputKeyValue = getLogKey();
					int i = 0;
					for(Map param:  autoInputOutList) {
						i = i + 1;
						param.put("KEY_VALUE", autoInputKeyValue);
						param.put("OPR_FLAG", "N");
						param.put("S_USER_ID", user.getUserID());
						param.put("INOUT_SEQ",i);
						if( param.get("ACCOUNT_YNC").equals("Y") && !param.get("INOUT_TYPE_DETAIL").equals("91") && param.get("PRICE_YN").equals("Y")){
							if(ObjUtils.parseInt(param.get("ORDER_UNIT_FOR_P"))<= 0){
								throw new  UniDirectValidateException(this.getMessage("800004",user));
							}else{
								super.commonDao.insert("otr120ukrvServiceImpl.insertLogDetail", param);
							}
						}else{
							super.commonDao.insert("otr120ukrvServiceImpl.insertLogDetail", param);
						}
					}
					insertSpParam.put("KeyValue", autoInputKeyValue);
					insertSpParam.put("LangCode", user.getLanguage());
					insertSpParam.put("CreateType", createLoc);
					
					super.commonDao.queryForObject("otr120ukrvServiceImpl.spOtr120ukrv", insertSpParam);
					ErrorDesc = ObjUtils.getSafeString(insertSpParam.get("ErrorDesc"));
					if(!ObjUtils.isEmpty(ErrorDesc)){
						throw new  UniDirectValidateException(this.getMessage(ErrorDesc, user));
					}
				}
				//4-1양품창고와 불량창고가 다르면 추가로 불량창고에 불량내역 입고(외주)
				if(! ObjUtils.getSafeString(dataMaster.get("GOOD_WH_CODE")).equals(ObjUtils.getSafeString(dataMaster.get("BAD_WH_CODE")))){
					autoInputBadOutList = super.commonDao.list("s_mms200ukrv_mekServiceImpl.selectAutoInputOutBadList", autoInputParam);
					if(autoInputBadOutList.size() > 0){
						autoInputKeyValue = getLogKey();
						int i = 0;
						for(Map param:  autoInputBadOutList) {
							 i = i + 1;
							param.put("KEY_VALUE", autoInputKeyValue);
							param.put("OPR_FLAG", "N");
							param.put("S_USER_ID", user.getUserID());
							param.put("INOUT_SEQ",i);
							super.commonDao.insert("otr120ukrvServiceImpl.insertLogDetail", param);
						}
						insertSpParam.put("KeyValue", autoInputKeyValue);
						insertSpParam.put("LangCode", user.getLanguage());
						insertSpParam.put("CreateType", createLoc);
						
						super.commonDao.queryForObject("otr120ukrvServiceImpl.spOtr120ukrv", insertSpParam);
						ErrorDesc = ObjUtils.getSafeString(insertSpParam.get("ErrorDesc"));
						if(!ObjUtils.isEmpty(ErrorDesc)){
							throw new  UniDirectValidateException(this.getMessage(ErrorDesc, user));
						}
					}
				}
			}
			
			//마스터에 SET
			dataMaster.put("INSPEC_NUM", ObjUtils.getSafeString(spParam.get("INSPEC_NUM")));
			
			//그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("INSPEC_NUM", ObjUtils.getSafeString(spParam.get("INSPEC_NUM")));
					}
				}
			}
		}
		
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	/**
	 * 검사등록 저장
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAllBad(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		List<Map> dataList = new ArrayList<Map>();
		for(Map paramData: paramList) {
			String sInspecNum = "";
			dataList = (List<Map>) paramData.get("data");
			Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
			for(Map param:  dataList) {
				if(param.get("INSPEC_NUM") == null || StringUtils.isBlank((String) param.get("INSPEC_NUM"))){
					// 신규건에 대한 처리
					param.put("INSPEC_NUM", dataMaster.get("INSPEC_NUM"));
					param.put("INSPEC_SEQ", dataMaster.get("INSPEC_SEQ"));
					param.put("DIV_CODE", dataMaster.get("DIV_CODE"));
					super.commonDao.insert("s_mms200ukrv_mekServiceImpl.insertQms210", param);
					
				}else{
					//수정건에 대한 처리
    				super.commonDao.update("s_mms200ukrv_mekServiceImpl.updateQms210", param);
					sInspecNum = (String) param.get("INSPEC_NUM");
					
					//불량리스트는 불량건수에 대해서만 기록을 유지하는데
					//불량검사량을 0 으로 수정할 경우가 존재 하므로
					//이럴 경우를 대비해서 0으로 UPDATE 진행 후 삭제
					super.commonDao.delete("s_mms200ukrv_mekServiceImpl.deleteQms210", param);
				}
				//불량수량저장시 MPO200T의BAD_RETURN_Q수량을 증감하여 업데이트토록수정
				List<Map<String, Object>> resultList = commonDao.list("s_mms200ukrv_mekServiceImpl.selectQMS200", param);
				
				if(resultList == null || resultList.size() == 0){
					throw new UniDirectValidateException(this.getMessage("55306", user));
				}else{
					for(Map<String, Object> result: resultList){
						// 발주내역 불량검사량 업데이트
						param.put("ORDER_NUM", result.get("ORDER_NUM"));
						param.put("ORDER_SEQ", result.get("ORDER_SEQ"));
						super.commonDao.update("s_mms200ukrv_mekServiceImpl.updateMpo200", param);
					}
				}
			}
			//불량내역 등록과 동시에 검사내역에 합격수량과(양품검사량-불량) 불량수량에 반영
			super.commonDao.update("s_mms200ukrv_mekServiceImpl.updateQms200", dataMaster);
			//샘플검사에 해당
			//검사내역의 양품검사량,불량검사량 업데이트
			//검사내역의 접수량을 접수내역의 검사량에 업데이트
			if(StringUtils.isNotBlank(sInspecNum)){
				dataMaster.put("S_INSPEC_NUM", sInspecNum);
				super.commonDao.update("s_mms200ukrv_mekServiceImpl.updateQms200AndQms100", dataMaster);
			}
		}
		paramList.add(0, paramMaster);
		return  paramList;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertBad(List<Map> params, LoginVO user) throws Exception {
		return params;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateBad(List<Map> params, LoginVO user) throws Exception {
		return params;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteBad(List<Map> params, LoginVO user) throws Exception {
		return;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		return params;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		return params;
	}
	
	@ExtDirectMethod(group = "sales", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
		return;
	}

	/**
	 * 검사량이 있는지 점검
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "mpo")
	public List<Map<String, Object>>  inspecQtyCheck(Map param) throws Exception {
		return  super.commonDao.list("s_mms200ukrv_mekServiceImpl.inspecQtyCheck", param);
	}
	
	/**
	 * 시험성적서_메인리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  mainReport(Map param) throws Exception {
		return  super.commonDao.list("s_mms200ukrv_mekServiceImpl.mainReport", param);
	}
	
	/**
	 * 시험성적서_서브리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>>  subReport(Map param) throws Exception {
		return  super.commonDao.list("s_mms200ukrv_mekServiceImpl.subReport", param);
	}
}
