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

@Service("s_mms510ukrv_wmService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class S_Mms510ukrv_wmServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 창고변경 시, 창고cell 가져오는 로직 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object getWhCellCode(Map param) throws Exception {
		return super.commonDao.select("s_mms510ukrv_wmServiceImpl.getWhCellCode", param);
	}

	/**
	 * 유효기간 관련
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object selectExpirationdate(Map param) throws Exception {
		return super.commonDao.select("s_mms510ukrv_wmServiceImpl.selectExpirationdate", param);
	}

	/**
	 * 단가 조회
	 */
	@Transactional(readOnly=true)
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object fnOrderPrice(Map param) throws Exception {
		return super.commonDao.select("s_mms510ukrv_wmServiceImpl.fnOrderPrice", param);
	}

	/**
	 * 과세구분
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public Object taxType(Map param) throws Exception {
		return super.commonDao.select("s_mms510ukrv_wmServiceImpl.taxType", param);
	}



	/**
	 * 입고내역 조회
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return super.commonDao.list("s_mms510ukrv_wmServiceImpl.selectList", param);
	}

	/**
	 * 조회팝업 -> 입고번호 검색
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectinoutNoMasterList(Map param) throws Exception {
		return super.commonDao.list("s_mms510ukrv_wmServiceImpl.selectinoutNoMasterList", param);
	}

	/**
	 * 미입고참조
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectnoReceiveList(Map param) throws Exception {
		return super.commonDao.list("s_mms510ukrv_wmServiceImpl.selectnoReceiveList", param);
	}

	/**
	 * 반품가능발주참조
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectreturnPossibleList(Map param) throws Exception {
		return super.commonDao.list("s_mms510ukrv_wmServiceImpl.selectreturnPossibleList", param);
	}

	/**
	 * 검사/무검사 결과참조
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectinspectResultList(Map param) throws Exception {
		List<Map<String, Object>> resultList = null;
		if(ObjUtils.getSafeString(param.get("WINDOW_FLAG")).equals("inspectResult")){	// 검사결과
			resultList = super.commonDao.list("s_mms510ukrv_wmServiceImpl.selectinspectResultList1", param);
		}else{																			// 무검사
			resultList = super.commonDao.list("s_mms510ukrv_wmServiceImpl.selectinspectResultList2", param);
		}
		return resultList;
	}



	/**
	 * 저장
	 * @param paramList 리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @param CreateType
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "matrl")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();
		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();

		for(Map paramData: paramList) {
			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertDetail"))	oprFlag="N";
			if(paramData.get("method").equals("updateDetail"))	oprFlag="U";
			if(paramData.get("method").equals("deleteDetail"))	oprFlag="D";

			for(Map param: dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);

				if(param.get("LOT_ASSIGNED_YN") == null){
					param.put("LOT_ASSIGNED_YN",'Y');
				}

				if (oprFlag.equals("N")
					&& param.get("ACCOUNT_YNC").equals("Y")
					&& !param.get("INOUT_TYPE_DETAIL").equals("91")
					&& !param.get("INOUT_TYPE_DETAIL").equals("20")
					//20190613 - M103.40(사급입고) 추가
					&& !param.get("INOUT_TYPE_DETAIL").equals("40")
					&& param.get("PRICE_YN").equals("Y")
				){
					logger.debug("[입고단가]" + ObjUtils.parseDouble(param.get("ORDER_UNIT_FOR_P")));
					if(ObjUtils.parseDouble(param.get("ORDER_UNIT_FOR_P"))<= 0){
//						throw new UniDirectValidateException("입고유형이 금액보정이 아닐때 구매단가가 0 이거나 0보다 작을 수 없습니다.");
						throw new UniDirectValidateException(this.getMessage("800004",user));
					}else{
						param.put("data", super.commonDao.insert("s_mms510ukrv_wmServiceImpl.insertLogDetail", param));
					}
				}else{
					if("N".equals(oprFlag) || "D".equals(oprFlag)){
						param.put("data", super.commonDao.insert("s_mms510ukrv_wmServiceImpl.insertLogDetail", param));
					}else{
						param.put("data", super.commonDao.insert("s_mms510ukrv_wmServiceImpl.updateLogDetail", param));
					}
				}
			}
		}

		//4.출하지시저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("CreateType", dataMaster.get("CREATE_LOC"));

		super.commonDao.queryForObject("s_mms510ukrv_wmServiceImpl.spReceiving", spParam);
		String ErrorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));

		//출하지시 마스터 출하지시 번호 update
//		for(Map param : paramList ) {
		if(!ObjUtils.isEmpty(ErrorDesc)){
//			dataMaster.put("INOUT_NUM", "");
			String[] messsage = ErrorDesc.split(";");
			throw new UniDirectValidateException(this.getMessage(messsage[0], user));
		} else {
			//마스터에 SET
			dataMaster.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
			//그리드에 SET
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
				if(param.get("method").equals("insertDetail")) {
					List<Map> datas = (List<Map>)param.get("data");
					for(Map data: datas){
						data.put("INOUT_NUM", ObjUtils.getSafeString(spParam.get("InOutNum")));
					}
				}
			}
		}
		paramList.add(0, paramMaster);

		return paramList;
	}

	/**
	 * Detail 입력
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertDetail(List<Map> params, LoginVO user) throws Exception {
		return params;
	}

	/**
	 * Detail 수정
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateDetail(List<Map> params, LoginVO user) throws Exception {
		return params;
	}

	/**
	 * Detail 삭제
	 */
	@ExtDirectMethod(group = "matrl", value = ExtDirectMethodType.STORE_MODIFY)
	public void deleteDetail(List<Map> params, LoginVO user) throws Exception {
	}











	/**
	 * 입고등록_라벨_메인리포트
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> mainReport_label(Map param) throws Exception {
		return super.commonDao.list("s_mms510ukrv_wmServiceImpl.mainReport_label", param);
	}

	/**
	 * 발주품목의 후공정 가져오는 쿼리
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> mainReport_label_afterProg(Map param) throws Exception {
		return super.commonDao.list("s_mms510ukrv_wmServiceImpl.mainReport_label_afterProg", param);
	}



	/**
	 * 매입명세표_메인리포트 - 20210415 추가
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> printMasterData(Map param) throws Exception {
		return super.commonDao.list("s_mms510ukrv_wmServiceImpl.printMasterData", param);
	}

	/**
	 * 매입명세표_디테일리포트 - 20210415 추가
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "prodt")
	public List<Map<String, Object>> printDetailData(Map param) throws Exception {
		return super.commonDao.list("s_mms510ukrv_wmServiceImpl.printDetailData", param);
	}
}