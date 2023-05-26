package foren.unilite.modules.sales.sof;

import java.util.ArrayList;
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
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.service.impl.TlabBadgeService;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.sales.sof.Sof100ukrvModel;

@Service("sof190ukrvService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Sof190ukrvServiceImpl  extends TlabAbstractServiceImpl {
	
	// 20201207 뱃지 기능 추가
	@Resource(name="tlabBadgeService")
	private TlabBadgeService tlabBadgeService;

	/**sof200t Master data 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList1(Map param,LoginVO user) throws Exception {
		param.put("MONEY_UNIT", user.getCurrency());
		return  super.commonDao.list("sof190ukrvServiceImpl.selectList1", param);
	}

	/** sof220t Master data 조회
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "sales")
	public List<Map<String, Object>>  selectList2(Map param,LoginVO user) throws Exception {
		return  super.commonDao.list("sof190ukrvServiceImpl.selectList2", param);
	}





	/**수주 확정 / 취소 로직
	 * @param paramList
	 * @param paramMaster
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
	public List<Map> saveAll(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramDetail:" + paramList);
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		String oprFlag = "";

		List<Map> dataList = new ArrayList<Map>();
		if(paramList != null) {
			for(Map param: paramList) {
				dataList = (List<Map>)param.get("data");
//				insertLogMaster(dataList, keyValue, oprFlag, user);
				
				for(Map dataListMap: dataList) {
					int orderSeq = 0;
					if(!"".equals(dataListMap.get("ITEM_LIST"))) {
						if("Y".equals(dataListMap.get("SAVE_FLAG"))) {
							String keyValue = getLogKey();
	
							if(dataMaster.get("STATUS_FLAG").equals("9")) {
								oprFlag = "D";
							} else if(dataMaster.get("STATUS_FLAG").equals("2")) {
								oprFlag = "N";
							}
	
							//1.master data L_SOF100T에 insert
							dataListMap.put("KEY_VALUE"		, keyValue);
							//202103223 수정: master OPR_FLAG = 'D' 대신 'U'로 넘김
							if("D".equals(oprFlag)) {
								dataListMap.put("OPR_FLAG"	, "U");
							} else {
								dataListMap.put("OPR_FLAG"	, oprFlag);
							}
							dataListMap.put("DIV_CODE"		, user.getDivCode());
							dataListMap.put("sMONEY_UNIT"	, user.getCurrency());
							super.commonDao.insert("sof190ukrvServiceImpl.insertLogMaster", dataListMap);
	
							//2.detail data L_SOF110T에 insert: master data와 SO_NUM이 같은 data만 oprFlag 받아서 insert
							if(dataMaster.get("detailArray") != null){
								List<Map<String, Object>> detailArray = (List) dataMaster.get("detailArray");
								if(detailArray != null && detailArray.size() > 0){
									for (int i = 0; i < detailArray.size(); i++) {
										Map<String, Object> map = detailArray.get(i);
										if(map.get("SO_NUM").equals(dataListMap.get("SO_NUM")) && map.get("ORDER_NUM").equals(dataListMap.get("ORDER_NUM"))) {
											orderSeq = orderSeq + 1;
											map.put("KEY_VALUE"		, keyValue);
											map.put("OPR_FLAG"		, oprFlag);
											map.put("S_COMP_CODE"	, user.getCompCode());
											map.put("DIV_CODE"		, user.getDivCode());
											map.put("INIT_DVRY_DATE", map.get("DVRY_DATE"));
											map.put("S_USER_ID"		, user.getUserID());
											if(map.get("SER_NO").equals(0)) {
												map.put("SER_NO"	, orderSeq);
											}
											//수주 디테일 로그정보 저장
											super.commonDao.insert("sof190ukrvServiceImpl.insertLogDetail",map);
										}
									}
								}
							}
			
							//3.수주저장 Stored Procedure 실행
							Map<String, Object> spParam = new HashMap<String, Object>();
							spParam.put("KeyValue", keyValue);
							spParam.put("LangCode", user.getLanguage());
		
							super.commonDao.queryForObject("sof190ukrvServiceImpl.spSalesOrder", spParam);
			
							String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));
							if(ObjUtils.isNotEmpty(errorDesc)){
								dataMaster.put("ORDER_NUM", "");
								throw new UniDirectValidateException(this.getMessage(errorDesc, user));			//20210323 수정: Exception(errorDesc); ->
							}
							//20210323 추가: 변경된 상태값 그리드에서 표시하도록 set
							if(dataMaster.get("STATUS_FLAG").equals("9")) {
								dataListMap.put("STATUS_FLAG", "2");
							} else if(dataMaster.get("STATUS_FLAG").equals("2")) {
								dataListMap.put("STATUS_FLAG", "9");
							}
							dataListMap.put("SAVE_FLAG", "");

							//4.수주데이터 저장 후 비고 / 상태값 UPDATE
							if(dataMaster.get("detailArray") != null){
								List<Map<String, Object>> detailArray = (List) dataMaster.get("detailArray");
								if(detailArray != null && detailArray.size() > 0){
									for (int i = 0; i < detailArray.size(); i++) {
										Map<String, Object> map = detailArray.get(i);
										if(map.get("SO_NUM").equals(dataListMap.get("SO_NUM")) && map.get("ORDER_NUM").equals(dataListMap.get("ORDER_NUM"))) {
											map.put("S_COMP_CODE"	, user.getCompCode());
											map.put("S_USER_ID"		, user.getUserID());
											map.put("OPR_FLAG"		, oprFlag);
		
											super.commonDao.update("sof190ukrvServiceImpl.updateDetail", map);
										}
									}
								}
							}
							// 5. 알람뱃지 추가
							super.commonDao.update("sof190ukrvServiceImpl.updateAlert", dataListMap);
						}
					}
				}
			}
		}
		paramList.add(0, paramMaster);

		tlabBadgeService.reload();
		return paramList;
	}

	/**수주 마스터 로그정보 저장
	 * @param params
	 * @param keyValue
	 * @param oprFlag
	 * @return
	 * @throws Exception
	 */
//	public List<Map> insertLogMaster(List<Map> params, String keyValue, String oprFlag, LoginVO user) throws Exception {
//		for(Map param: params) {
//			if("Y".equals(param.get("SAVE_FLAG"))) {
//				param.put("KEY_VALUE"	, keyValue);
//				param.put("OPR_FLAG"	, oprFlag);
//				param.put("DIV_CODE"	, user.getDivCode());
//				param.put("sMONEY_UNIT"	, user.getCurrency());
//				super.commonDao.insert("sof190ukrvServiceImpl.insertLogMaster", param);
//			}
//		}
//		return params;
//	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	public List<Map> updateDetail(List<Map> params, LoginVO user, Map dataMaster) throws Exception {
		return params;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	public List<Map> deleteDetail(List<Map> params, LoginVO user, Map dataMaster) throws Exception {
		return params;
	}





	/**주문 디테일 데이터 저장 로직
	 * @param params
	 * @param user
	 * @param dataMaster
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})   
	public List<Map> saveAll2(List<Map> paramList, Map paramMaster, LoginVO user) throws Exception {
		//logger.debug("[saveAll] paramDetail:" + paramList);
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");

		if(paramList != null)	{
			List<Map> updateDetail2 = null;
			
			for(Map dataListMap: paramList) {
				if(dataListMap.get("method").equals("updateDetail2")) {
					updateDetail2 = (List<Map>)dataListMap.get("data");
				}
			}
			if(updateDetail2 != null) this.updateDetail2(updateDetail2, user, dataMaster);
		}
		paramList.add(0, paramMaster);
				
		return  paramList;
	}

	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "sales")
	public List<Map> updateDetail2(List<Map> params, LoginVO user, Map dataMaster) throws Exception {
		for(Map param: params) {
			super.commonDao.update("sof190ukrvServiceImpl.updateDetail2", param);
		}
		return params;
	}
}
